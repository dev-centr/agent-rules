# Login reset

A sign-in that depends on a secret the person can forget is unfinished until they can reset that secret themselves.

## When it applies

- The secret is a password, passphrase, or PIN.
- The surface can be a website, a desktop or mobile app, a CLI, a TUI, or a service. The rule is not limited to websites.

Provider-only sign-in (Google, GitHub, Apple, a passkey) with no local password does not add a password reset. There is no password to recover.

## What to ship

- Put the reset on the sign-in surface: a "Forgot your password?" control, a screen in the app, or a CLI command. Do not hide it in settings the person cannot open.
- Send a one-time link or code. The new secret meets the same minimum as sign-up.
- The reply is the same whether or not the account exists.
- After a successful reset, end other sessions for that account.
- Send the message only when outbound mail or the equivalent channel is configured. If it is not, say so. Do not pretend the link was sent.

## While bootstrapping

Skills `bootstrap-org` and `ship-app` follow this file whenever that work adds a password login. A website is one case, not the only one.
