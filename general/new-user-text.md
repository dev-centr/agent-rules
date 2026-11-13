# Text for a new user

Skill: `skills/new-user-text/SKILL.md`.

A command's first screen, an error, an empty state, and a document that teaches a product are how a new person learns the controls. Write them so that person can take the next step without already knowing the model.

Published pages still name their reader in `general/documentation.md`. This file is the shape of the words.

## Order

1. One plain sentence: what this thing does.
2. The actions to try first. Name the command or the control, and say what the person will see.
3. The rest of the interface, grouped by the job the person is doing.
4. Flags, field tables, and exit codes under those groups. They stay available. They do not lead.

## Words

Gloss a special word the first time it appears. Tie the gloss to something the person just saw ("the id in the first column").

An error or a refusal says what to do next. The internal reason can follow in one sentence when the person needs it to choose.

An empty screen says the command or the control that fills it.

## A service start screen

A command that starts a service which can run more than once uses the start card in the Service Manager standard. Skill `service-manager`. The first sentence says whether this window can close or is showing the output. The id and the stop command follow. The log path is the last line.

## Documents

Open on the task. Then the vocabulary. Then the reference. The first commands in a README are the ones a new person runs.
