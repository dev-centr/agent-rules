# Operator mail addresses

Every domain this organization controls gets three apex addresses, and only these as the default set:

- `support@`
- `postmaster@`
- `abuse@`

They are operator destinations. They are not a username blacklist. Do not reserve extra local-parts. Do not enable a catch-all.

Do not invent a `mail.` hostname on every domain. User addresses, when a person has an account, are `name@mail.userdata.cloud`. That namespace stays closed until then. On `mail.userdata.cloud` the platform addresses are:

- `postmaster@`
- `abuse@`
- `bounces@`
- `mailer-daemon@`
- `fbl@`

`bounces@mail.userdata.cloud` is the envelope return path for mail the platform sends. A later delivery-status notice uses a null envelope sender and From `mailer-daemon@mail.userdata.cloud`. Those two addresses are operator destinations, not user accounts. `fbl@` is the automated feedback-loop address on each domain that already receives mail, including `mail.userdata.cloud`. It is not a published public contact.

## mailer-daemon is hard-whitelisted

`mailer-daemon@` is a platform address. Deliver it to the inbox of the verified destination. Do not mark it as spam. Do not train a filter on it. Do not route it to junk.

Google once had a compromised mailer daemon that sent spam. After that spam was reported, later legitimate mail from the same daemon address kept landing in spam. Leave the whitelist in place. A later agent must not remove it as cleanup.

On every domain where `mailer-daemon@` exists (at least `mailer-daemon@mail.userdata.cloud`), the destination mailbox filter matches From or Return-Path for that address, keeps the message in the inbox (Primary and Important), and removes Spam. The filter must not add Spam and must not remove Inbox. Do not delete unrelated filters. Whitelist `postmaster@` only when it is the same operational path. The required hard whitelist is `mailer-daemon`.

If the mailbox connection can read mail but cannot create filters, write this rule and stop. Do not guess a destination, and do not start a login to widen access unless the person asks.

## A spam complaint is an incident

Anything this organization controls that is reported as spam is a cause for concern and investigation. That includes `mailer-daemon`, `support`, `postmaster`, `abuse`, `bounces`, any other address on these domains, the sending IPs, and the domains themselves. A spam complaint is an incident. It is not a reason to blacklist the address or to remove the inbox whitelist.

`abuse@` is the public contact a person or another postmaster writes to. A person reads it. It is for a report that an address on the domain is sending spam, phishing, or other abuse. It is not the inbox for feedback-loop aggregates, Postmaster Tools, or the hijack detector. A spam complaint does not turn `abuse@` into a machine inbox.

The Spam button at Gmail, Yahoo, or Microsoft does not forward the message to the operator. That provider trains its own filter. Never report `mailer-daemon`, or any platform address, with that button.

Automated Abuse Reporting Format feedback loops (RFC 5965), where a provider offers them, go to `fbl@` on that domain. `fbl@` is not the published public contact. The detector reads `fbl@`. Do not register those loops to `abuse@`.

Gmail does not send per-message ARF copies. Gmail complaint rates are aggregate, via Postmaster Tools. Do not point Postmaster Tools at `abuse@`.

Compare the attached original on `fbl@` to mail the platform sent: sending IP, DKIM, and the bounce id or VERP token. A foreign IP is forgery. A platform IP with no matching send is a hijacked credential or daemon. Record it. Leave the inbox whitelist in place.

## DNS

Read MX before changing a zone. If MX already points at a provider, do not replace it. Add the three apex addresses in that provider when the logged-in tooling can. If there is no MX, Cloudflare Email Routing is acceptable. The forward destination must already be verified on the account.

A null MX (`0 .`) means the domain refuses mail. Leave it.

When Email Routing is enabled, SPF includes `include:_spf.mx.cloudflare.net`. Merge that into an existing SPF record. Do not wipe a record that already authorizes a sender.

Add `v=DMARC1; p=none` only when that name has no DMARC record. Do not set `p=reject`.

Leave website A and CNAME records alone.

Skill: `org-mail-addresses`.
