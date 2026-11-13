---
name: new-user-text
description: >-
  Use when designing a textual interface, CLI help, first-run message, usage
  text, error message, empty state, prompt, status line, writing a document,
  README, help page, guide, onboarding, beginner, new user, getting used to
  the interface, help text, --help, serve, -listen.
---

# Text for a new user

A textual interface or a document that teaches a product is how a new person learns the controls. Write the first thing they see so they can start. Detail: `general/new-user-text.md`. Published docs also follow `general/documentation.md` for who the reader is.

## First screen

Open with one plain sentence: what this thing stores or does.

Then the one or two actions to try. Name the command or the control, and say what the person will see. Group later commands by the job ("look and edit", "when a folder was renamed"), not as one flat flag list.

The full reference stays on the same screen, below that start path. A new person can stop after the start path. Someone who already knows the tool can keep reading.

## Words

The first time a special word appears, say what it means in the same sentence. "Board" with no gloss is a private name. "The id in the first column is what later commands call a board" teaches the word.

An error says what happened and the next step. One sentence of the internal model may follow when the person needs it to choose. It does not lead.

## A service start screen

When the screen starts a service that can run more than once, that screen is the start card in the Service Manager standard. Load skill `service-manager`. The first sentence says the instance is in the background, or that this window is showing it. The id and the stop command come next. `-listen` is how to watch the lines here. The log path is the last line.

## Documents

A guide opens on the task the reader is trying to do, then the vocabulary, then the reference tables. A README's first commands are the ones a new person runs, with the result of each.
