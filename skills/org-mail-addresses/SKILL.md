---
name: org-mail-addresses
description: >-
  Use when setting up org email, support@, postmaster@, abuse@,
  mailer-daemon, bounces@, default addresses on a domain, hard whitelist,
  do not mark mailer-daemon as spam, Email Routing, catch-all, bootstrap
  domain email, or operator mail on an owned apex.
---

# Operator mail addresses

Standing practice: `general/org-mail-addresses.md`. Public reference: the Cloudflare Email Routing page on the Dev-Centr docs hub, section "Operator addresses".

## What to create

On each apex the org controls:

- `support@`
- `postmaster@`
- `abuse@`

Do not invent a `mail.` hostname on other domains. On `mail.userdata.cloud` only, also keep `postmaster@`, `abuse@`, `bounces@`, and `mailer-daemon@`. `bounces@` is the envelope return path. A DSN uses a null envelope sender and From `mailer-daemon@`. Those two are operator destinations, not user accounts. Do not open `name@mail.userdata.cloud` until a person has an account.

Do not enable a catch-all. Do not reserve a username blacklist.

## mailer-daemon

`mailer-daemon@` is hard-whitelisted. Deliver it to the inbox of the already-verified destination. Do not mark it as spam and do not train a filter on it.

Google once had a compromised mailer daemon that sent spam. After that spam was reported, later legitimate mail from the same address kept landing in spam. Do not delete this whitelist later.

Where the destination mailbox can take a filter, match From or Return-Path for `mailer-daemon@` on each domain where that address exists. Keep the message in the inbox. Remove Spam. Do not add Spam, do not remove Inbox, and do not delete unrelated filters. Whitelist `postmaster@` only when it is the same operational path.

If creating the filter needs a new mailbox login or a broader settings scope, say so and still record the rule. Do not guess a destination.

## DNS

Read MX first. If a provider already has MX, do not replace it. Add the three addresses there when the logged-in tooling can. If there is no MX, Cloudflare Email Routing is acceptable and the destination must already be verified. Leave a null MX (`0 .`) in place.

Merge `include:_spf.mx.cloudflare.net` into an existing SPF record. Do not wipe a sender that is already authorized. Add DMARC `p=none` only when no DMARC record exists. Do not set `p=reject`. Leave website A and CNAME records alone.
