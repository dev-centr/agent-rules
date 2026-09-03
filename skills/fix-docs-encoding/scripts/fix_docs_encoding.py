#!/usr/bin/env python3
"""Detect and repair double-encoded UTF-8 (mojibake) in docs sources; validate SVGs as XML.

This is a *transcode / corruption* repair — not a refactor. Prefer ASCII punctuation
in hand-authored SVGs; recover mojibake in .adoc/.md/.svg when present.

Usage:
  python fix_docs_encoding.py --check [paths...]
  python fix_docs_encoding.py --fix [paths...]
  python fix_docs_encoding.py --check --fix docs/modules/ROOT

Default roots when no paths given: cwd's docs/, or . if that is missing.
"""
from __future__ import annotations

import argparse
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

TEXT_SUFFIXES = {".adoc", ".md", ".svg", ".txt", ".asciidoc"}
MOJIBAKE_MARKERS = (
    "â€œ",  # “
    "â€",  # ”
    "â€™",  # ’
    "â€˜",  # ‘
    "â€”",  # —
    "â€“",  # –
    "â€¦",  # …
    "â†’",  # →
    "â†",  # ←
    "Â·",  # ·
    "Ã—",  # ×
)

# Prefer ASCII in SVG labels after recovery (stable on Windows tooling).
ASCII_MAP = {
    "\u201c": '"',
    "\u201d": '"',
    "\u2018": "'",
    "\u2019": "'",
    "\u2014": "--",
    "\u2013": "-",
    "\u2026": "...",
    "\u2192": "->",
    "\u2190": "<-",
    "\u00b7": " / ",
}


def has_mojibake(text: str) -> bool:
    return any(m in text for m in MOJIBAKE_MARKERS)


def recover_mojibake(text: str) -> str:
    """UTF-8 bytes mis-decoded as cp1252, then stored as UTF-8 again."""
    try:
        import ftfy  # optional

        recovered = ftfy.fix_text(text, normalization="NFKC")
    except Exception:
        try:
            recovered = text.encode("cp1252").decode("utf-8")
        except (UnicodeEncodeError, UnicodeDecodeError):
            recovered = text
            pairs = [
                ("â€œ", "\u201c"),
                ("â€", "\u201d"),
                ("â€™", "\u2019"),
                ("â€˜", "\u2018"),
                ("â€”", "\u2014"),
                ("â€“", "\u2013"),
                ("â€¦", "\u2026"),
                ("â†’", "\u2192"),
                ("â†", "\u2190"),
                ("Â·", "\u00b7"),
            ]
            for bad, good in pairs:
                recovered = recovered.replace(bad, good)
    out = recovered
    for ch, repl in ASCII_MAP.items():
        out = out.replace(ch, repl)
    out = re.sub(r"[ \t]+/[ \t]+", " / ", out)
    return out


def iter_files(paths: list[Path]) -> list[Path]:
    files: list[Path] = []
    for p in paths:
        if p.is_file() and p.suffix.lower() in TEXT_SUFFIXES:
            files.append(p)
        elif p.is_dir():
            for child in p.rglob("*"):
                if child.is_file() and child.suffix.lower() in TEXT_SUFFIXES:
                    if "node_modules" in child.parts or ".git" in child.parts:
                        continue
                    files.append(child)
    return sorted(set(files))


def check_svg_xml(path: Path) -> str | None:
    try:
        ET.parse(path)
    except ET.ParseError as e:
        return str(e)
    return None


def process(paths: list[Path], *, do_fix: bool, check_only: bool) -> int:
    files = iter_files(paths)
    problems = 0
    fixed = 0
    for path in files:
        raw = path.read_bytes()
        if raw.startswith(b"\xff\xfe") or raw.startswith(b"\xfe\xff"):
            print(f"FAIL {path}: UTF-16 BOM (not supported; re-save as UTF-8)")
            problems += 1
            continue
        if raw.startswith(b"\xef\xbb\xbf"):
            print(f"WARN {path}: UTF-8 BOM")
            problems += 1
            if do_fix:
                raw = raw[3:]
                path.write_bytes(raw)
                fixed += 1

        try:
            text = raw.decode("utf-8")
            latin1_rescue = False
        except UnicodeDecodeError as e:
            # Common Windows authoring bug: SVG declares UTF-8 but labels use
            # single-byte cp1252/latin-1 (e.g. MIDDLE DOT 0xB7). Browsers then
            # show XML "Encoding error" and the <img> looks broken.
            print(f"FAIL {path}: not UTF-8 ({e})")
            problems += 1
            if not do_fix:
                continue
            text = raw.decode("latin-1")
            latin1_rescue = True

        if has_mojibake(text) or latin1_rescue:
            if has_mojibake(text):
                print(f"MOJIBAKE {path}")
                if not latin1_rescue:
                    problems += 1
            if do_fix:
                new = recover_mojibake(text)
                # ASCII separators for middot (map above keeps a middot glyph —
                # force slash so SVG stays ASCII-safe on Windows tooling).
                new = new.replace("\u00b7", " / ")
                new = re.sub(r" +/ +", " / ", new)
                if path.suffix.lower() == ".svg":
                    new = re.sub(
                        r"&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9a-fA-F]+;)",
                        "&amp;",
                        new,
                    )
                if has_mojibake(new):
                    print(f"  still has markers after recovery — manual edit needed")
                else:
                    path.write_text(new, encoding="utf-8", newline="\n")
                    fixed += 1
                    print(f"  fixed")
                    text = new

        if path.suffix.lower() == ".svg":
            err = check_svg_xml(path)
            if err:
                print(f"SVG-XML {path}: {err}")
                problems += 1
            # bare & in text nodes is caught by XML parse

    if check_only or not do_fix:
        print(f"checked {len(files)} files; problems={problems}; fixed={fixed}")
    else:
        print(f"checked {len(files)} files; problems={problems}; fixed={fixed}")
    return 1 if problems and not do_fix else (1 if problems and do_fix and fixed < problems else 0)


def default_roots() -> list[Path]:
    cwd = Path.cwd()
    docs = cwd / "docs"
    if docs.is_dir():
        return [docs]
    return [cwd]


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("paths", nargs="*", type=Path, help="Files or directories")
    ap.add_argument("--check", action="store_true", help="Report problems (default)")
    ap.add_argument("--fix", action="store_true", help="Repair mojibake / strip BOM")
    args = ap.parse_args(argv)
    paths = list(args.paths) if args.paths else default_roots()
    do_check = args.check or not args.fix
    return process(paths, do_fix=args.fix, check_only=do_check and not args.fix)


if __name__ == "__main__":
    sys.exit(main())
