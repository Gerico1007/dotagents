---
name: miadi-apt-buildkite-pipeline-setup
description: Use when a Buildkite Package Registry and pipeline for `apt install`-style .deb distribution do not exist yet for an account — first-time setup of the registry, GitHub App connection, pipeline, tag-build trigger, and cluster secret. Not for adding another repo to an already-working setup, or for troubleshooting an existing one (see miadi-apt-buildkite-pipeline-management for both).
---

# Miadi Apt / Buildkite Pipeline — First-Time Setup

## Overview

Buildkite Package Registries (formerly packagecloud, now folded into Buildkite
itself) can host a real Debian/Ubuntu apt repository, and Buildkite pipelines
can build and publish to it automatically on release. This skill is the
from-scratch path: nothing exists yet for this account — no registry, no
pipeline, no GitHub connection. Built and verified end-to-end 2026-07-30
(miadisabelle account, `mia-parallel-code` repo, `miadi-apt` registry — two
versions published, one caught up after fixing the gotcha in step 5).

**Before this skill:** confirm the app's built package can't be self-hosted
via plain git+GitHub Pages — GitHub hard-blocks any pushed blob over 100MB, so
Electron-sized `.deb` files (100MB+) need a real package host, not a hand-rolled
`dists/`+`pool/` repo in a git-backed Pages site. Buildkite Package Registries
has no such limit.

**Login gotcha:** log in to Buildkite via **"Sign in with GitHub"** using the
target GitHub account, not email/password or Google — Buildkite orgs are keyed
to how you authenticated, and a different login method can land you in an
unrelated personal org that only superficially looks right.

## Prerequisites already provided by any Buildkite org

Every Buildkite org comes with a **"Default cluster"** already created,
pre-stocked with **Hosted Agent queues** (typically `linux-small`,
`linux-medium`, `linux-large`, `macos-medium`, `macos-large`) — these are
Buildkite-managed runners that auto-scale on demand. For the common case
there is nothing to provision: no self-hosted agent to install, no cluster to
create, no queue to configure. `agents: { queue: "linux-medium" }` in a
pipeline step just picks one of these existing hosted queues by name (check
**Agents** in the org nav → the cluster's **Queues** tab for the exact names
available — they can differ by plan). Only reach for self-hosted agents /
custom clusters if hosted queues genuinely don't fit (special OS, on-prem
network access, GPU, etc.) — that's out of scope for this skill.

**Plan/billing gate:** Package Registries and hosted agents can be limited by
plan (evaluation trials show a countdown banner like "N days left on your
evaluation trial"). If registry creation or a build unexpectedly fails outside
anything this skill covers, check the org's plan/trial status before assuming
a configuration mistake.

## Workflow

### 1. Create the Package Registry
Buildkite → **Package Registries** → New Registry:
- Ecosystem: **Debian/Ubuntu (deb)**
- Teams: **Everyone** (or as scoped as the org needs)
- Name it for the *distribution*, not the app — one registry can (and should)
  host every app's `.deb` if there will be more than one, so a name like
  `<org>-apt` beats a per-app name.
- After creating, go to registry **Settings** → **Registry Management** →
  **Make registry public**. The confirmation dialog shows the exact slug in
  the dialog text itself (`please type the slug of this registry: <slug>`) —
  retype exactly what's displayed there, don't derive or guess it. This is
  required — `apt install` needs anonymous reads, and non-public registries
  only serve authenticated users.

### 2. Connect the GitHub repo to a new pipeline
Buildkite → **Pipelines** → **New Pipeline** → **Git scope** dropdown → if the
target GitHub account isn't listed, **Connect GitHub account**. This installs
Buildkite's **GitHub App** (not a classic per-repo "Add webhook" — the app
install itself registers the webhook, and the browser flow may auto-select the
repo you were about to add). **If the target account is a GitHub organization
(not a personal account), this install may need approval from an org owner**
before it completes — a human-gated step like step 6's token, not something
to work around. Confirm the repo is preselected, name the pipeline (matches
the repo name by convention).

### 3. Set the pipeline's initial steps to the bootstrap pattern
In the **YAML Steps editor** on that same New Pipeline screen, replace
whatever's there with:
```yaml
steps:
  - command: buildkite-agent pipeline upload
```
This makes the pipeline always re-read `.buildkite/pipeline.yml` fresh from
whatever commit it's building — never hand-edit the real steps in Buildkite's
UI, edit the file in the repo. Create the pipeline.

### 4. Author `.buildkite/pipeline.yml` in the target repo
Gate the actual work on `if: build.tag != null` so ordinary branch pushes are
a no-op and only real releases (tag pushes) build+publish. Read the token via
`buildkite-agent secret get` — never hardcode it, never pass it as a literal
pipeline env var. Example (adapt build commands to the app):
```yaml
steps:
  - label: ":debian: Publish .deb to <registry-slug>"
    if: build.tag != null
    command: |
      apt-get update -qq && apt-get install -y -qq python3 make g++ fakeroot >/dev/null
      npm ci
      npm run build
      deb=$(ls release/*.deb)
      token=$(buildkite-agent secret get PACKAGES_API_TOKEN)
      curl -sf -X POST "https://api.buildkite.com/v2/packages/organizations/<org>/registries/<registry-slug>/packages" \
        -H "Authorization: Bearer ${token}" \
        -F "file=@${deb}"
    agents:
      queue: "linux-medium"
```
Commit and push this to the repo's default branch before relying on it — the
pipeline can't read a file that isn't on GitHub yet.

### 5. Turn on "Build tags" — the one gotcha that silently no-ops everything
Pipeline → **Settings** → **GitHub** → **GitHub Settings** → the `push`
trigger group has two checkboxes: **Build branches** (on by default) and
**Build tags** (**off by default**). If the release trigger is a tag push
(`npm version` + `git push --follow-tags`, or any tag-based release script),
this MUST be turned on.

**Why this is dangerous:** GitHub's webhook delivery log will show the tag's
`push` and `create` events delivered successfully (200 OK) even with "Build
tags" off — Buildkite receives the event and silently declines to create a
build from it. The failure mode looks identical to "everything's fine, nothing
happened yet," not like an error. Always check this toggle explicitly; don't
infer it from a green webhook delivery log.

### 6. Create the cluster secret — human does this step, not the agent
Buildkite → **Agents** → the pipeline's cluster → **Secrets** → **New secret**,
key `PACKAGES_API_TOKEN`. The *value* is a Buildkite API Access Token
(User → API Access Tokens → New, scopes `read_packages` + `write_packages`,
org-scoped) that **the human generates and pastes in themselves** — don't
generate a long-lived credential and relay it through chat/tool calls, even
though the browser tooling could technically type it in. If a human hand-off
is needed, build a plain step-by-step artifact naming the exact fields and
exact destination page rather than describing it in prose.

A short-lived token *you* generate solely to prove the publish call works
once, then revoke immediately after, is a different and acceptable case —
say explicitly that you're doing this and that you revoked it.

### 7. Verify end-to-end
Either wait for a real tag push, or prove the mechanism once with a manual
`curl` publish of an already-built `.deb` using a short-lived, immediately-
revoked token (same shape as step 6's exception). A **Buildkite "New Build"**
with a tag name typed into the Branch field does **not** set `build.tag` —
`if: build.tag != null` steps are silently skipped for manual builds even
when the branch field says `v1.2.3`. Don't rely on manual builds to validate
the tag-triggered path; either push a real tag or publish directly.

### 8. Document the release picture in the repo
If the repo already has a release script (e.g. one that ships to GitHub
Releases), spell out that this Buildkite leg is a **third, independent**
action — it doesn't build from local `./release/` artifacts, doesn't need a
trigger phrase, and fires purely off the tag reaching GitHub. Write this into
the repo's `CLAUDE.md`/`AGENTS.md` so a future agent doesn't assume one
release action covers all of them.

### 9. Hand over the client install snippet
Each published package's **Installation** tab (Package Registries → registry
→ a package) has Buildkite's own generated client instructions — GPG key URL,
`sources.list` line, and the `apt install` command. Use that generated
snippet verbatim rather than composing one from memory; it already has the
right `packages.buildkite.com/<org>/<registry>/...` paths.

## Quick Reference

| Thing | Where |
|---|---|
| Registry create/settings | Package Registries → New Registry / registry Settings |
| Pipeline create | Pipelines → New Pipeline (Git scope → Connect GitHub account if needed) |
| Bootstrap step | Pipeline's initial YAML: `buildkite-agent pipeline upload` |
| Real steps | `.buildkite/pipeline.yml` in the repo, gated `if: build.tag != null` |
| Build tags toggle | Pipeline → Settings → GitHub → GitHub Settings → `push` group |
| Publish token | Cluster → Secrets → `PACKAGES_API_TOKEN`, read via `buildkite-agent secret get` |
| Client install snippet | Package Registries → registry → a package → Installation tab |

## Common Mistakes

- Assuming a delivered (200 OK) webhook event means a build happened — check
  the pipeline's Builds list and the "Build tags" toggle, not just the
  GitHub delivery log.
- Hand-editing pipeline steps in the Buildkite UI instead of the repo's
  `.buildkite/pipeline.yml` — breaks the bootstrap pattern's whole point.
- Generating the long-lived publish token yourself and typing it into a
  form — direct the human to generate and paste it themselves.
- Trying to validate the tag-gated step via a manual "New Build" with a tag
  name in the Branch field — `build.tag` stays null for manual builds.
- Building a self-hosted apt repo on GitHub Pages for an app whose package
  exceeds 100MB — it will not push.

See **miadi-apt-buildkite-pipeline-management** for onboarding another repo
into an already-existing setup, and for troubleshooting/catch-up procedures.
