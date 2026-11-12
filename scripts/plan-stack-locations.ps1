# Record where one chat's transcripts live after a workspace path change.
# Cursor names the transcript folder from the workspace path and may mint a new
# chat id on move. This script keeps those ids and folders as aliases of the
# first chat id. It does not start a second plan stack.
#
# Usage:
#   pwsh scripts/plan-stack-locations.ps1 record-move --canonical <id> `
#     --from-cursor-chat <id> --to-cursor-chat <id> `
#     --from-project-key <slug> --to-project-key <slug> `
#     --from-root <folder> --to-root <folder> `
#     [--from-workspace-uri <uri> --to-workspace-uri <uri>]
#   pwsh scripts/plan-stack-locations.ps1 resolve --chat <id> [--cursor-chat <id>] [--segment <n>] [--turn <n>] [--quote <text>]
#   pwsh scripts/plan-stack-locations.ps1 repair --chat <id> [--cursor-chat <id> --live-root <folder>] [--live-project-key <slug>] [--live-workspace-uri <uri>] [--files-moved]
#   pwsh scripts/plan-stack-locations.ps1 show --chat <id>

$ErrorActionPreference = 'Stop'

function Get-AgentWorkspaceRoot {
    if ($env:AGENT_WORKSPACE_ROOT) { return $env:AGENT_WORKSPACE_ROOT }
    return (Join-Path $env:LOCALAPPDATA 'AgentWorkspace')
}

function Set-Utf8NoBomContent {
    param([string]$Path, [string]$Value)
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Value.Replace("`r`n", "`n").Replace("`n", "`r`n"), $utf8)
}

function Get-KdlQuote {
    param([string]$Value)
    return '"' + ($Value -replace '\\', '\\' -replace '"', '\"') + '"'
}

function Read-Args {
    param([string[]]$Rest)
    $map = @{}
    for ($i = 0; $i -lt $Rest.Count; $i++) {
        $token = $Rest[$i]
        if ($token -notlike '--*') { throw "Unexpected argument '$token'. Flags look like --chat <id>." }
        $name = $token.Substring(2)
        if ($name -eq 'files-moved') {
            $map[$name] = 'true'
            continue
        }
        $i++
        if ($i -ge $Rest.Count) { throw "Missing value for --$name." }
        $map[$name] = $Rest[$i]
    }
    return $map
}

function Read-LocationEntries {
    param([string]$Path)
    $chat = $null
    $entries = New-Object System.Collections.Generic.List[object]
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        if ($line -match '^\s*chat\s+"((?:\\.|[^"\\])*)"') {
            $chat = $Matches[1] -replace '\\"', '"' -replace '\\\\', '\'
            continue
        }
        if ($line -match '^\s*(cursor-chat|project-key|workspace-uri|root)\s+"((?:\\.|[^"\\])*)"\s*(.*)$') {
            $kind = $Matches[1]
            $value = $Matches[2] -replace '\\"', '"' -replace '\\\\', '\'
            $props = @{}
            foreach ($m in [regex]::Matches($Matches[3], '(\w+)=(?:"((?:\\.|[^"\\])*)"|(\S+))')) {
                $raw = if ($m.Groups[2].Success) { $m.Groups[2].Value -replace '\\"', '"' -replace '\\\\', '\' } else { $m.Groups[3].Value }
                $props[$m.Groups[1].Value] = $raw
            }
            $entries.Add([pscustomobject]@{ Kind = $kind; Value = $value; Props = $props }) | Out-Null
        }
    }
    return [pscustomobject]@{ Chat = $chat; Entries = $entries; Path = $Path }
}

function Format-LocationFile {
    param($Doc)
    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add('// Locations for one chat. The folder name is the canonical id: the first chat id recorded for this conversation.')
    $lines.Add('// A later Cursor chat id, project slug, or transcript folder is an alias. Links name the canonical id plus the transcript id that held the sentence.')
    $lines.Add('// A project slug is not a chat key. Many chats share one workspace folder.')
    $lines.Add('// live=true is the folder Cursor is writing now. Older keys stay so a link recorded against them still resolves.')
    $lines.Add(('chat {0} {{' -f (Get-KdlQuote $Doc.Chat)))
    foreach ($entry in $Doc.Entries) {
        $bits = New-Object System.Collections.Generic.List[string]
        foreach ($key in @('role', 'live', 'status', 'since', 'reason')) {
            if ($entry.Props.ContainsKey($key) -and $entry.Props[$key]) {
                $val = [string]$entry.Props[$key]
                if ($key -eq 'live') { $bits.Add("$key=$val") }
                else { $bits.Add(('{0}={1}' -f $key, (Get-KdlQuote $val))) }
            }
        }
        $lines.Add(('  {0} {1} {2}' -f $entry.Kind, (Get-KdlQuote $entry.Value), ($bits -join ' ')))
    }
    $lines.Add('}')
    return ($lines -join "`n") + "`n"
}

function Write-LocationDoc {
    param($Doc)
    $dir = Split-Path -Parent $Doc.Path
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
    Set-Utf8NoBomContent -Path $Doc.Path -Value (Format-LocationFile $Doc)
}

function Get-SessionsRoot {
    return (Join-Path (Get-AgentWorkspaceRoot) 'sessions')
}

function Get-LocationPath {
    param([string]$Canonical)
    return (Join-Path (Join-Path (Get-SessionsRoot) $Canonical) 'locations.kdl')
}

function Get-AllLocationDocs {
    $root = Get-SessionsRoot
    $docs = @()
    if (-not (Test-Path -LiteralPath $root)) { return $docs }
    foreach ($file in (Get-ChildItem -LiteralPath $root -Recurse -Filter 'locations.kdl' -File)) {
        $doc = Read-LocationEntries $file.FullName
        if ($doc -and $doc.Chat) { $docs += $doc }
    }
    return $docs
}

function Write-Index {
    param($Docs)
    $lines = @(
        '// Built from sessions/*/locations.kdl. Do not edit by hand.',
        '// A Cursor chat id or one transcript folder maps to the canonical chat id.',
        '// A project slug is not an index key. Many chats share one workspace folder.',
        'index {'
    )
    foreach ($doc in $Docs) {
        foreach ($entry in $doc.Entries) {
            if ($entry.Kind -eq 'cursor-chat' -or $entry.Kind -eq 'root') {
                $lines += ('  {0} {1} chat={2}' -f $entry.Kind, (Get-KdlQuote $entry.Value), (Get-KdlQuote $doc.Chat))
            }
        }
    }
    $lines += '}'
    $path = Join-Path (Get-SessionsRoot) 'location-index.kdl'
    if (-not (Test-Path -LiteralPath (Get-SessionsRoot))) { New-Item -ItemType Directory -Path (Get-SessionsRoot) | Out-Null }
    Set-Utf8NoBomContent -Path $path -Value (($lines -join "`n") + "`n")
}

function Find-Canonical {
    param([string]$Chat)
    $direct = Get-LocationPath $Chat
    if (Test-Path -LiteralPath $direct) {
        $doc = Read-LocationEntries $direct
        if ($doc.Chat -eq $Chat) { return $doc }
    }
    foreach ($doc in (Get-AllLocationDocs)) {
        foreach ($entry in $doc.Entries) {
            if ($entry.Kind -eq 'cursor-chat' -and $entry.Value -eq $Chat) { return $doc }
            if ($entry.Kind -eq 'root' -and ($entry.Value -eq $Chat)) { return $doc }
        }
    }
    return $null
}

function Add-OrUpdateEntry {
    param($Doc, [string]$Kind, [string]$Value, [hashtable]$Props)
    $existing = $Doc.Entries | Where-Object { $_.Kind -eq $Kind -and $_.Value -eq $Value } | Select-Object -First 1
    if ($existing) {
        foreach ($key in @('live', 'status')) {
            if ($Props.ContainsKey($key)) { $existing.Props[$key] = $Props[$key] }
        }
        return
    }
    $Doc.Entries.Add([pscustomobject]@{ Kind = $Kind; Value = $Value; Props = $Props }) | Out-Null
}

function Set-Live {
    param($Doc, [string]$Kind, [string]$Value)
    foreach ($entry in $Doc.Entries) {
        if ($entry.Kind -ne $Kind) { continue }
        $entry.Props['live'] = $(if ($entry.Value -eq $Value) { 'true' } else { 'false' })
    }
}

function New-Doc {
    param([string]$Canonical)
    return [pscustomobject]@{
        Chat = $Canonical
        Path = (Get-LocationPath $Canonical)
        Entries = (New-Object System.Collections.Generic.List[object])
    }
}

function Get-RootStatus {
    param([string]$Folder)
    if (Test-Path -LiteralPath $Folder) { return 'present' }
    return 'missing'
}

function Write-Result {
    param([hashtable]$Fields)
    foreach ($key in @('status', 'reason', 'canonical', 'via', 'path', 'hint')) {
        if ($Fields.ContainsKey($key) -and $null -ne $Fields[$key] -and $Fields[$key] -ne '') {
            Write-Output ("{0}: {1}" -f $key, $Fields[$key])
        }
    }
}

function Get-SegmentName {
    param([int]$Segment)
    return ('segment_{0:D3}.md' -f $Segment)
}

if ($args.Count -lt 1) {
    throw 'Need a command: record-move, resolve, repair, or show.'
}
$command = $args[0]
$flagArgs = @()
if ($args.Count -gt 1) { $flagArgs = $args[1..($args.Count - 1)] }
$opt = Read-Args $flagArgs
$now = (Get-Date).ToString('yyyy-MM-ddTHH:mm:ssK')

switch ($command) {
    'record-move' {
        foreach ($name in @('canonical', 'from-cursor-chat', 'to-cursor-chat', 'from-project-key', 'to-project-key', 'from-root', 'to-root')) {
            if (-not $opt.ContainsKey($name) -or -not $opt[$name]) { throw "record-move requires --$name." }
        }
        $doc = Find-Canonical $opt['canonical']
        if (-not $doc) { $doc = New-Doc $opt['canonical'] }
        elseif ($doc.Chat -ne $opt['canonical']) { throw "Refusing to record --canonical $($opt['canonical']) onto existing chat $($doc.Chat). Pass the first chat id." }

        $pairs = @(
            @{ Kind = 'cursor-chat'; From = 'from-cursor-chat'; To = 'to-cursor-chat' },
            @{ Kind = 'project-key'; From = 'from-project-key'; To = 'to-project-key' },
            @{ Kind = 'root'; From = 'from-root'; To = 'to-root' }
        )
        if ($opt.ContainsKey('from-workspace-uri') -or $opt.ContainsKey('to-workspace-uri')) {
            $pairs += @{ Kind = 'workspace-uri'; From = 'from-workspace-uri'; To = 'to-workspace-uri' }
        }
        foreach ($pair in $pairs) {
            $fromValue = $opt[$pair.From]
            $toValue = $opt[$pair.To]
            if (-not $fromValue -or -not $toValue) { throw "record-move requires --$($pair.From) and --$($pair.To) together." }
            $fromProps = @{ role = 'original'; live = 'false'; since = $now }
            $toProps = @{ role = 'alias'; live = 'true'; since = $now; reason = 'workspace-move' }
            if ($pair.Kind -eq 'root') {
                $fromProps['status'] = Get-RootStatus $fromValue
                $toProps['status'] = Get-RootStatus $toValue
            }
            if ($fromValue -eq $toValue) {
                $fromProps['live'] = 'true'
                $fromProps.Remove('reason')
                Add-OrUpdateEntry $doc $pair.Kind $fromValue $fromProps
            }
            else {
                Add-OrUpdateEntry $doc $pair.Kind $fromValue $fromProps
                Add-OrUpdateEntry $doc $pair.Kind $toValue $toProps
            }
            Set-Live $doc $pair.Kind $toValue
        }
        # The first value of each kind stays role=original. A later move must not relabel it.
        foreach ($pair in $pairs) {
            $hasOriginal = @($doc.Entries | Where-Object { $_.Kind -eq $pair.Kind -and $_.Props['role'] -eq 'original' })
            if ($hasOriginal.Count -gt 0) { continue }
            $match = $doc.Entries | Where-Object { $_.Kind -eq $pair.Kind -and $_.Value -eq $opt[$pair.From] } | Select-Object -First 1
            if ($match) { $match.Props['role'] = 'original' }
        }
        Write-LocationDoc $doc
        Write-Index (Get-AllLocationDocs)
        Write-Result @{
            status = 'recorded'
            reason = 'workspace-move'
            canonical = $doc.Chat
            via = $opt['to-cursor-chat']
            path = $opt['to-root']
            hint = "Recorded the new transcript folder as an alias of $($doc.Chat). The plan stack stays in that session folder. The previous folder was kept so older links still resolve."
        }
    }
    'show' {
        if (-not $opt['chat']) { throw 'show requires --chat.' }
        $doc = Find-Canonical $opt['chat']
        if (-not $doc) {
            Write-Result @{
                status = 'miss'
                reason = 'never-recorded'
                hint = "No location record for $($opt['chat']). Cursor keys transcript folders by the workspace path, so a rename starts a new folder and can mint a new chat id. If this conversation was moved, record both folders with record-move. Until then a link to this id cannot be followed."
            }
            exit 2
        }
        Write-Output (Format-LocationFile $doc)
    }
    'resolve' {
        if (-not $opt['chat']) { throw 'resolve requires --chat.' }
        $doc = Find-Canonical $opt['chat']
        if (-not $doc) {
            Write-Result @{
                status = 'miss'
                reason = 'never-recorded'
                hint = "No location record for $($opt['chat']). Cursor keys transcript folders by the workspace path, so a rename starts a new folder and can mint a new chat id. If this conversation was moved, record both folders with record-move. Until then a link to this id cannot be followed."
            }
            exit 2
        }
        $roots = @($doc.Entries | Where-Object { $_.Kind -eq 'root' })
        $preferred = $null
        if ($opt['cursor-chat']) { $preferred = $opt['cursor-chat'] }
        $ordered = @($roots | Sort-Object @{ Expression = { if ($_.Props['live'] -eq 'true') { 0 } else { 1 } } }, Value)
        $segmentFile = $null
        if ($opt.ContainsKey('segment')) { $segmentFile = Get-SegmentName ([int]$opt['segment']) }
        if ($segmentFile -and -not $preferred -and -not $opt['quote']) {
            Write-Result @{
                status = 'miss'
                reason = 'workspace-fragmented'
                canonical = $doc.Chat
                hint = "Segment $($opt['segment']) needs the transcript id it was recorded against (--cursor-chat). Each folder numbers its own segments from zero, so segment $($opt['segment']) in another folder is a different sentence. Pass --quote only when you want every folder searched for that exact text."
            }
            exit 2
        }

        $tried = @()
        foreach ($root in $ordered) {
            $folder = $root.Value
            $cursorId = Split-Path -Leaf $folder
            $use = $true
            if ($preferred -and -not $opt['quote']) {
                # Without a quote, only the transcript the link named is eligible.
                $use = ($cursorId -eq $preferred) -or ($folder -eq $preferred)
            }
            if (-not $use) { continue }
            $candidate = $folder
            if ($segmentFile) { $candidate = Join-Path (Join-Path $folder 'compaction') $segmentFile }
            else {
                $jsonl = Join-Path $folder ($cursorId + '.jsonl')
                if (Test-Path -LiteralPath $jsonl) { $candidate = $jsonl }
            }
            $exists = Test-Path -LiteralPath $candidate
            $tried += ('{0} status={1}' -f $candidate, $(if ($exists) { 'present' } else { 'missing' }))
            if (-not $exists) { continue }
            if ($opt['quote']) {
                $body = [System.IO.File]::ReadAllText($candidate)
                if (-not $body.Contains($opt['quote'])) { continue }
            }
            $reason = 'found'
            $hint = "Opened the transcript recorded for $($doc.Chat)."
            if ($roots.Count -gt 1 -and -not $preferred) {
                $older = @($roots | Where-Object { $_.Value -ne $root.Value } | ForEach-Object { $_.Value })
                $hint = "This chat has more than one transcript folder. Opened the live one at $candidate. The earlier folder is still recorded and holds the turns from before the move: $($older -join '; ')."
            }
            if ($root.Props['live'] -ne 'true') {
                $reason = 'resolved-via-alias'
                $live = $roots | Where-Object { $_.Props['live'] -eq 'true' } | Select-Object -First 1
                $livePath = if ($live) { $live.Value } else { '(none recorded)' }
                $hint = "Resolved through an older transcript folder. This chat was rebound and Cursor left the earlier files in place. The current folder is $livePath. The file you asked for is still at $candidate."
            }
            elseif ($root.Props['status'] -eq 'reunited') {
                $hint = "Resolved at the folder recorded after the split was repaired. Older keys still name this same chat."
            }
            Write-Result @{
                status = 'found'
                reason = $reason
                canonical = $doc.Chat
                via = $cursorId
                path = $candidate
                hint = $hint
            }
            exit 0
        }
        $aliasLines = @($doc.Entries | ForEach-Object { '{0}={1} live={2}' -f $_.Kind, $_.Value, $_.Props['live'] })
        $reason = 'file-missing'
        $hint = "The location record exists, and the recorded folder is not on disk. Chat $($doc.Chat) was not deleted from this record. The folder may have been renamed again without record-move."
        $presentCount = @($roots | Where-Object { $_.Props['status'] -eq 'present' -or (Test-Path -LiteralPath $_.Value) }).Count
        if ($roots.Count -gt 1) {
            $reason = 'workspace-fragmented'
            $hint = "This link names chat $($doc.Chat), and Cursor has more than one transcript folder for it. Segment numbers restart in each folder, so a bare segment from another folder was not treated as the same sentence. Tried: $($tried -join '; '). Aliases: $($aliasLines -join '; '). If the files have since been gathered into one folder, run repair with the folder you found."
        }
        elseif ($presentCount -eq 0) {
            $reason = 'file-missing'
        }
        Write-Result @{
            status = 'miss'
            reason = $reason
            canonical = $doc.Chat
            hint = $hint
        }
        exit 2
    }
    'repair' {
        if (-not $opt['chat']) { throw 'repair requires --chat.' }
        $doc = Find-Canonical $opt['chat']
        if (-not $doc) {
            Write-Result @{
                status = 'miss'
                reason = 'never-recorded'
                hint = "No location record for $($opt['chat']). Nothing to repair. If the conversation was moved, record-move both folders first."
            }
            exit 2
        }
        foreach ($entry in @($doc.Entries | Where-Object { $_.Kind -eq 'root' })) {
            $exists = Test-Path -LiteralPath $entry.Value
            if ($exists) { $entry.Props['status'] = 'present' }
            elseif ($opt['files-moved'] -eq 'true') { $entry.Props['status'] = 'reunited' }
            else { $entry.Props['status'] = 'missing' }
        }
        if ($opt['live-root']) {
            if (-not $opt['cursor-chat']) { throw 'repair with --live-root also requires --cursor-chat, the transcript id whose files now live in that folder.' }
            $cursorId = $opt['cursor-chat']
            $already = $doc.Entries | Where-Object { $_.Kind -eq 'root' -and $_.Value -eq $opt['live-root'] } | Select-Object -First 1
            if (-not $already) {
                Add-OrUpdateEntry $doc 'root' $opt['live-root'] @{
                    role = 'alias'; live = 'false'; status = (Get-RootStatus $opt['live-root']); since = $now; reason = 'repaired'
                }
            }
            Set-Live $doc 'root' $opt['live-root']
            $cursorRow = $doc.Entries | Where-Object { $_.Kind -eq 'cursor-chat' -and $_.Value -eq $cursorId } | Select-Object -First 1
            if (-not $cursorRow) {
                Add-OrUpdateEntry $doc 'cursor-chat' $cursorId @{ role = 'alias'; live = 'false'; since = $now; reason = 'repaired' }
            }
            Set-Live $doc 'cursor-chat' $cursorId
            if ($opt['live-project-key']) {
                $keyRow = $doc.Entries | Where-Object { $_.Kind -eq 'project-key' -and $_.Value -eq $opt['live-project-key'] } | Select-Object -First 1
                if (-not $keyRow) {
                    Add-OrUpdateEntry $doc 'project-key' $opt['live-project-key'] @{ role = 'alias'; live = 'false'; since = $now; reason = 'repaired' }
                }
                Set-Live $doc 'project-key' $opt['live-project-key']
            }
            if ($opt['live-workspace-uri']) {
                $uriRow = $doc.Entries | Where-Object { $_.Kind -eq 'workspace-uri' -and $_.Value -eq $opt['live-workspace-uri'] } | Select-Object -First 1
                if (-not $uriRow) {
                    Add-OrUpdateEntry $doc 'workspace-uri' $opt['live-workspace-uri'] @{ role = 'alias'; live = 'false'; since = $now; reason = 'repaired' }
                }
                Set-Live $doc 'workspace-uri' $opt['live-workspace-uri']
            }
        }
        Write-LocationDoc $doc
        Write-Index (Get-AllLocationDocs)
        $liveRoot = @($doc.Entries | Where-Object { $_.Kind -eq 'root' -and $_.Props['live'] -eq 'true' } | Select-Object -First 1)
        Write-Result @{
            status = 'repaired'
            reason = 'workspace-fragmented'
            canonical = $doc.Chat
            path = $(if ($liveRoot) { $liveRoot.Value } else { '' })
            hint = "Marked the live folder current and refreshed present, missing, or reunited on the others. Old keys were kept. Links that stored the canonical id and the transcript id do not need new paths. A later MCP or API should return this same hint when a caller still asks with an old key."
        }
    }
    default { throw "Unknown command '$command'. Use record-move, resolve, repair, or show." }
}
