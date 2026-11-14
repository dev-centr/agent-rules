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
- Feedback Loop (FBL): `fbl@`

A Feedback Loop is a program a mailbox provider (Yahoo, Microsoft, and others) offers the sender. When someone at that provider marks the sender's message as spam, the provider emails a copy to an address the sender registered. The copy uses the Abuse Reporting Format (RFC 5965): the complaint outside, the original message attached. Our registered address for that automated copy is `fbl@`. `abuse@` is not that address. Gmail does not send these per-message copies.

`bounces@mail.userdata.cloud` is the envelope return path for mail the platform sends. A later delivery-status notice uses a null envelope sender and From `mailer-daemon@mail.userdata.cloud`. Those two addresses are operator destinations, not user accounts. `fbl@` is on each domain that already receives mail, including `mail.userdata.cloud`. It is not a published public contact.

## mailer-daemon is hard-whitelisted

`mailer-daemon@` is a platform address. Deliver it to the inbox of the verified destination. Do not mark it as spam. Do not train a filter on it. Do not route it to junk.

Google once had a compromised mailer daemon that sent spam. After that spam was reported, later legitimate mail from the same daemon address kept landing in spam. Leave the whitelist in place. A later agent must not remove it as cleanup.

On every domain where `mailer-daemon@` exists (at least `mailer-daemon@mail.userdata.cloud`), the destination mailbox filter matches From or Return-Path for that address, keeps the message in the inbox (Primary and Important), and removes Spam. The filter must not add Spam and must not remove Inbox. Do not delete unrelated filters. Whitelist `postmaster@` only when it is the same operational path. The required hard whitelist is `mailer-daemon`.

If the mailbox connection can read mail but cannot create filters, write this rule and stop. Do not guess a destination, and do not start a login to widen access unless the person asks.

## A spam complaint is an incident

Anything this organization controls that is reported as spam is a cause for concern and investigation. That includes `mailer-daemon`, `support`, `postmaster`, `abuse`, `bounces`, any other address on these domains, the sending IPs, and the domains themselves. A spam complaint is an incident. It is not a reason to blacklist the address or to remove the inbox whitelist.

`abuse@` is the public contact a person or another postmaster writes to. A person reads it. It is for a report that an address on the domain is sending spam, phishing, or other abuse. It is not the inbox for feedback-loop aggregates, Postmaster Tools, or the hijack detector. A spam complaint does not turn `abuse@` into a machine inbox.

The Spam button at Gmail, Yahoo, or Microsoft does not forward the message to the operator. That provider trains its own filter. Never report `mailer-daemon`, or any platform address, with that button.

The detector reads `fbl@`. Do not register that loop to `abuse@`. Gmail complaint rates are aggregate, via Postmaster Tools. Do not point Postmaster Tools at `abuse@`.

Compare the attached original on `fbl@` to mail the platform sent: sending IP, DKIM, and the bounce id or VERP token. A foreign IP is forgery. A platform IP with no matching send is a hijacked credential or daemon. Record it. Leave the inbox whitelist in place.

## A claimed-from-us spoof

When inbound mail for a local user claims to be from an address we control (including `mailer-daemon@`) and the sending IP or DKIM signature is not ours, or a platform IP has no matching bounce id or VERP token, treat it as a spoof.

Tell the recipient in two places. Put a warning in the web UI. Also deliver a new message into that user's own mailbox explaining the spoof, in the same thread as the spoofed message, so an IMAP or other mail app shows it with no web UI. The new message is from the platform (`mailer-daemon` or a notices address we control), addressed to the user. It is not an SMTP autoreply to the forged sender. Do not send anything to the spoof's envelope sender. That would be backscatter.

Draft specification: [Email protocol addendum](https://team.docs.userdata.cloud/home/reference/email-protocol-addendum/) (member site). Source: `userdata-cloud/team-docs` `docs/modules/ROOT/pages/reference/email-protocol-addendum.adoc`.

The operator incident still goes to the detector that reads `fbl@`. `abuse@` stays the public human contact. A spoof does not remove the `mailer-daemon` inbox whitelist.

This delivery behavior has to live in a mail server we can modify. A third-party mailbox host for end users does not give us a place to file that warning.

## DNS

Read MX before changing a zone. If MX already points at a provider, do not replace it. Add the three apex addresses in that provider when the logged-in tooling can. If there is no MX, Cloudflare Email Routing is acceptable. The forward destination must already be verified on the account.

A null MX (`0 .`) means the domain refuses mail. Leave it.

When Email Routing is enabled, SPF includes `include:_spf.mx.cloudflare.net`. Merge that into an existing SPF record. Do not wipe a record that already authorizes a sender.

Add `v=DMARC1; p=none` only when that name has no DMARC record. Do not set `p=reject`.

Leave website A and CNAME records alone.

Skill: `org-mail-addresses`.
