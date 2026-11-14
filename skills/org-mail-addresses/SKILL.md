---
name: org-mail-addresses
description: >-
  Use when setting up org email, support@, postmaster@, abuse@,
  mailer-daemon, bounces@, Feedback Loop (FBL), fbl@, default addresses on a domain, hard whitelist,
  do not mark mailer-daemon as spam, do not un-whitelist, spam complaint,
  feedback loop, Abuse Reporting Format, RFC 5965, Postmaster Tools,
  Email Routing, catch-all, bootstrap domain email, spoof, backscatter, or operator mail
  on an owned apex.
---

# Operator mail addresses

Standing practice: `general/org-mail-addresses.md`. Public reference: the Cloudflare Email Routing page on the Dev-Centr docs hub, section "Operator addresses".

## What to create

On each apex the org controls:

- `support@`
- `postmaster@`
- `abuse@`

`abuse@` is the public contact a person or another postmaster writes to. A person reads it. It is not an automated aggregate inbox.

Do not invent a `mail.` hostname on other domains. On `mail.userdata.cloud` only, also keep `postmaster@`, `abuse@`, `bounces@`, `mailer-daemon@`, and the Feedback Loop (FBL) address `fbl@`. `bounces@` is the envelope return path. A DSN uses a null envelope sender and From `mailer-daemon@`. Those two are operator destinations, not user accounts. `fbl@` is also created on each apex that already has Email Routing and `abuse@`. It is not a published public contact. Do not open `name@mail.userdata.cloud` until a person has an account. Do not add `fbl@` on a null-MX parked domain.

A Feedback Loop is a program a mailbox provider (Yahoo, Microsoft, and others) offers the sender. When someone at that provider marks the sender's message as spam, the provider emails a copy to an address the sender registered. The copy uses the Abuse Reporting Format (RFC 5965): the complaint outside, the original message attached. Our registered address for that automated copy is `fbl@`. `abuse@` is not that address. Gmail does not send these per-message copies.

Do not enable a catch-all. Do not reserve a username blacklist.

## mailer-daemon

`mailer-daemon@` is hard-whitelisted. Deliver it to the inbox of the already-verified destination. Do not mark it as spam and do not train a filter on it.

Google once had a compromised mailer daemon that sent spam. After that spam was reported, later legitimate mail from the same address kept landing in spam. Do not delete this whitelist later.

Where the destination mailbox can take a filter, match From or Return-Path for `mailer-daemon@` on each domain where that address exists. Keep the message in the inbox. Remove Spam. Do not add Spam, do not remove Inbox, and do not delete unrelated filters. Whitelist `postmaster@` only when it is the same operational path.

If creating the filter needs a new mailbox login or a broader settings scope, say so and still record the rule. Do not guess a destination.

## Spam complaints

A spam complaint about anything the org controls is an incident. That includes `mailer-daemon`, `support`, `postmaster`, `abuse`, `bounces`, any other address, the sending IPs, and the domains. Investigate it. Do not blacklist the address and do not remove the inbox whitelist.

Do not press the Spam button at Gmail, Yahoo, or Microsoft for `mailer-daemon` or any platform address. That button trains the provider's filter and does not forward the message. It does not turn `abuse@` into a machine inbox.

The detector reads `fbl@`. Do not register that loop to `abuse@`. Do not point Postmaster Tools at `abuse@`.

Compare the attached original on `fbl@` to mail the platform sent (sending IP, DKIM, bounce id or VERP token). A foreign IP is forgery. A platform IP with no matching send is a hijacked credential or daemon. Record it. Leave the whitelist in place. Detail: `general/org-mail-addresses.md`.

## A claimed-from-us spoof

When inbound mail for a local user claims to be from an address we control (including `mailer-daemon@`) and the sending IP or DKIM signature is not ours, or a platform IP has no matching bounce id or VERP token, treat it as a spoof.

Tell the recipient in two places. Put a warning in the web UI. Also deliver a new message into that user's own mailbox explaining the spoof, so an IMAP or other mail app shows it with no web UI. The new message is from the platform (`mailer-daemon` or a notices address we control), addressed to the user. It is not an SMTP autoreply to the forged sender. Do not send anything to the spoof's envelope sender. That would be backscatter.

The operator incident still goes to the detector that reads `fbl@`. `abuse@` stays the public human contact. A spoof does not remove the `mailer-daemon` inbox whitelist.

This delivery behavior has to live in a mail server we can modify. A third-party mailbox host for end users does not give us a place to file that warning.

## DNS

Read MX first. If a provider already has MX, do not replace it. Add the three addresses there when the logged-in tooling can. If there is no MX, Cloudflare Email Routing is acceptable and the destination must already be verified. Leave a null MX (`0 .`) in place.

Merge `include:_spf.mx.cloudflare.net` into an existing SPF record. Do not wipe a sender that is already authorized. Add DMARC `p=none` only when no DMARC record exists. Do not set `p=reject`. Leave website A and CNAME records alone.
