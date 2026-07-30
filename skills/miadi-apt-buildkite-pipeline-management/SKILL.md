---
name: miadi-apt-buildkite-pipeline-management
description: Use when a Buildkite Package Registry and at least one publishing pipeline already exist for the account, and the need is to onboard another repo into it, troubleshoot why a release didn't publish, catch up a missed release, or rotate the publish token. Not for first-time setup of the registry/GitHub connection itself (see miadi-apt-buildkite-pipeline-setup).
---

# Miadi Apt / Buildkite Pipeline — Onboarding & Maintenance

## Overview

Assumes the account-level and registry-level work is already done: a
Buildkite org connected via GitHub App, at least one public Debian Package
Registry, and at least one repo already publishing `.deb`s to it. This skill
covers the *ongoing* work — adding repo #2, #3, ... into the same registry,
and diagnosing/fixing the one failure mode that looks identical to "nothing
went wrong yet." Companion to **miadi-apt-buildkite-pipeline-setup**, which
this does not repeat in full — cross-reference it for exact click-paths.

## When to use which skill

- Nothing exists yet (no registry, no pipeline, GitHub not connected) →
  `miadi-apt-buildkite-pipeline-setup`.
- Registry + at least one pipeline already work → this skill.

## Onboarding another repo into the existing registry

Don't create a second registry unless there's a real reason to segment
audiences (different visibility, different team). One registry serves every
app's `.deb` — apt clients add the source once and get every onboarded app.

1. Repeat `miadi-apt-buildkite-pipeline-setup` steps 2–7 for the new repo,
   pointing the `curl` publish URL at the **same** registry slug the first
   repo uses (`.../registries/<same-registry-slug>/packages`).
2. The cluster secret (`PACKAGES_API_TOKEN`) is already there — reuse it,
   don't create a per-repo secret, unless the org wants per-repo credential
   scoping (then name it distinctly and update that repo's `pipeline.yml`
   accordingly).
3. Still turn "Build tags" on for the new pipeline — this setting is
   per-pipeline, not inherited from the first one.
4. Still document the three-release-legs picture in the new repo's own
   `CLAUDE.md`/`AGENTS.md` — it doesn't carry over from another repo.

## Troubleshooting: "my release didn't show up in the registry"

Work through in order — don't skip to guessing:

1. **Confirm the tag actually reached GitHub:**
   `git tag -l 'vX.Y.Z'` and `git ls-remote origin` (or `gh api
   repos/<owner>/<repo>/tags`).
2. **Confirm GitHub delivered the webhook:**
   First find Buildkite's hook ID — `gh api repos/<owner>/<repo>/hooks` and
   pick the entry whose `config.url` contains `webhook.buildkite.com` (there
   may be other unrelated hooks on the same repo; don't assume there's only
   one). Then `gh api repos/<owner>/<repo>/hooks/<that-id>/deliveries` — look
   for `push` and `create` events near the tag's timestamp, `status: "OK"`.
   **A 200 here proves GitHub sent it. It proves nothing about whether
   Buildkite built anything from it.** (Needs a `gh` token with repo hook-read
   access — the same auth used to manage the repo normally covers this.)
3. **Confirm a build actually exists for that tag:**
   Buildkite pipeline → Builds (or "All branches" filter) — look for a build
   whose ref is the tag. If webhook delivery succeeded but no build exists:
   check Pipeline → Settings → GitHub → GitHub Settings → the `push` group's
   **Build tags** checkbox. Off-by-default is the near-universal cause here
   (see `miadi-apt-buildkite-pipeline-setup` step 5 for why this is easy to
   miss). Turn it on, save.
4. **If a build exists but the publish step didn't run:** check whether it
   was a real tag-push build or a manually-created one ("New Build" with a
   tag name typed into the Branch field). Manual builds do not set
   `build.tag` — an `if: build.tag != null` step is silently skipped, shown
   as "N skipped steps hidden" in the build view, not as a failure. This is
   not a bug to fix in the pipeline; it's a property of manual builds.
5. **If the secret lookup or curl failed:** open the build's job log for the
   publish step directly — `buildkite-agent secret get` returns a clear error
   if the secret is missing/misnamed, and `curl -f` surfaces a non-2xx
   registry response.

## Catching up a release that was missed

If a version was already built and shipped elsewhere (e.g. to GitHub
Releases) before the tag-build fix above, and the local `./release/` (or
equivalent build output directory) still has the matching artifact:

1. Generate a **short-lived** API Access Token yourself (scopes
   `read_packages` + `write_packages`), described as a one-off catch-up so
   its purpose is legible in the token list.
2. `curl -X POST https://api.buildkite.com/v2/packages/organizations/<org>/registries/<registry-slug>/packages -H "Authorization: Bearer $TOKEN" -F "file=@<path-to-deb>"` —
   same call the real pipeline makes.
3. **Revoke that token immediately after**, and say so explicitly. This is
   the one case where the agent generating/using a token itself is fine — it
   never becomes a standing credential, and revocation closes the exposure
   window the same turn it opened.
4. Don't try to force a manual Buildkite build to do this instead — see
   step 4 of Troubleshooting above for why that path doesn't set `build.tag`.

## Rotating the publish token

1. Generate a new API Access Token (same scopes) — human does this step,
   generates it, and pastes the value into the cluster secret's edit screen
   themselves (Buildkite → Agents → cluster → Secrets → the secret → edit
   value). The agent names the exact field and exact destination; it does
   not type the value in.
2. Once confirmed working (next release, or a manual catch-up per above),
   revoke the old token from User → API Access Tokens.

## Checking registry health

- **What's published:** Package Registries → registry → **Releases** tab
  lists every package/version currently hosted.
- **Client install snippet for a specific package:** that package's
  **Installation** tab — always use Buildkite's own generated snippet
  (GPG key URL + `sources.list` line + `apt install` line), don't compose
  one from memory; the exact `packages.buildkite.com/<org>/<registry>/...`
  paths are generated per-registry.
- **Never used yet:** a cluster secret's "Last read" column stays "Never"
  until a real pipeline build actually calls `buildkite-agent secret get`
  for it — a useful early signal that no real tag-triggered build has run.

## Common Mistakes

- Creating a second registry per repo instead of reusing the one shared
  registry — fragments the apt source users have to add.
- Assuming "Build tags" carries over when onboarding a new repo — it's set
  per pipeline.
- Treating a 200 OK webhook delivery as proof a build ran.
- Fighting manual-build semantics to reproduce a tag-triggered release —
  publish directly instead (see Catching up, above).
- Generating a long-lived rotation token and pasting it in yourself instead
  of directing the human to.
