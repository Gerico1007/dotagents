---
name: episode-voice-channel
description: Hold a spoken, two-way conversation with Jerry through a Pixel Recorder episode — speak to him in an Assembly voice, and transcribe the audio replies he records back. Use this whenever Jerry is away from the screen (walking, driving, on an Android node) and says things like "talk to me through the episode", "I can't see the screen", "send me audio", "read me my recording", "transcribe what I just said", "reply in the episode", or asks you to answer by voice instead of text. Also use it when a written answer would be long and he is mobile — an episode clip reaches him where a terminal cannot.
---

# Episode Voice Channel

Jerry often works away from a screen. The episode composition is the room where
you both leave things: you speak into it, he listens on his phone, he records a
reply, you transcribe it and read it as your next prompt. Everything — audio,
screenshots, written notes — accumulates in one thread he can scroll later.

Three systems already on the box make this work. This skill wires them into one
path so you do not rediscover it:

- **assembly-voice** — Edge-TTS with a voice per Assembly persona
- **Pixel Recorder** — HTTPS portal on 8768 hosting compositions and recordings
- **Groq `whisper-large-v3`** — one call returns French transcription *and*
  English translation

## Start here

```bash
scripts/episode preflight
```

Run this before your first exchange in a session. It checks the three things
that fail quietly, each of which can cost a long time to chase from the symptom
alone. If it reports a problem, fix that before speaking — the errors downstream
point somewhere unhelpful.

Then find or make the room:

```bash
scripts/episode status                       # workspace, compositions, what is waiting
scripts/episode open "Episode Title"         # prints the slug; safe to re-run
```

## Speaking to Jerry

```bash
scripts/episode say --persona synth --to worktree-territory-map \
  --text "Jerry, Synth here. The transcription failure was two quote characters …"
```

For anything longer than a couple of sentences, write the text to a file first
and pass `--file`. Long inline strings are easy to mangle in a shell.

**Write for the ear, not the eye.** He is walking. Spell out what would be read
as a symbol — "line seventy two", not "line 72"; "dot env file", not `~/.env`.
Lead with the conclusion, then the reason. Skip paths, flags, and JSON entirely;
those belong in `episode note`, where he can read them later.

Personas carry different voices and languages — `nyro`, `jamai`, `synth` speak
English; `aureon` and `salix` speak French. Pick the one whose role fits the
message: Synth for diagnostics and execution, Nyro for structure, Aureon for
reflection, JamAI for anything musical.

## Listening to Jerry

```bash
scripts/episode listen              # transcribe everything new he recorded
scripts/episode listen --latest     # just his most recent take
```

`listen` prints both languages. Treat the result as a prompt addressed to you and
act on it — that is the whole point of the channel.

It skips your own voice. Every clip you speak is written to a small ledger under
`~/.local/state/episode-voice/`, so the channel never loops back on itself. It
also skips anything already transcribed, so re-running is cheap and safe.

## Leaving the written version

Audio is for walking; notes are for reading afterward. After any substantial
spoken answer, put the detail — commands, paths, file names, links — in the
composition notes:

```bash
scripts/episode note worktree-territory-map --append --file findings.md
```

This is where exact strings belong. Saying a shell command aloud is useless; he
needs to be able to copy it when he is back at the machine.

## A full exchange

```bash
scripts/episode preflight
SLUG=$(scripts/episode open "Session Notes")

scripts/episode say --persona synth --to "$SLUG" --file answer.txt
scripts/episode note "$SLUG" --append --file answer-details.md

# … he listens, records a reply …

scripts/episode listen --to "$SLUG"     # transcribe and attach his take
```

## What breaks, and why it is not obvious

**The recorder rejects `.mp3`.** Its `AUDIO_EXTENSIONS` list covers m4a, opus,
aac, wav and amr. TTS emits mp3, so an import of raw TTS output is refused. The
script converts to AAC in an `.m4a` container first; if you ever bypass the
script, do that conversion yourself.

**A quoted key in `~/.env` fails as `invalid_api_key`.** The recorder parses that
file with `process.env[k] = match[2].trim()` and never strips quotes, so
`GROQ_API_KEY="gsk_…"` is sent as `Bearer "gsk_…"` with the quote characters
attached. Groq rejects it, and the message names the key rather than the quoting —
which sends you hunting for a bad key that is actually fine. `preflight` catches
this.

**`Start Recording` cannot work on a Linux host.** That button shells out to
`termux-microphone-record`, which exists only on Android. On Eury it fails with
`not found`, and because the portal respawns with `stdio: 'ignore'` after a
workspace switch, you may not see the error anywhere. Jerry's path on a computer
is the **Import** button; recording happens on an Android node.

**The portal's workspace decides where audio lands.** Recordings live in a folder
that follows the active workspace, so a clip imported while the portal serves
`episodes` sits beside Jerry's own takes for that workspace. Check with
`episode status` before speaking if you are unsure which room you are in.

## Configuration

Defaults suit Eury. Override by environment when they do not:

| variable | default |
|---|---|
| `PIXEL_RECORDER_URL` | `https://localhost:8768` |
| `ASSEMBLY_VOICE_DIR` | `~/salix/repos/assembly-voice` |
| `EPISODE_STATE_DIR` | `~/.local/state/episode-voice` |

The portal uses a self-signed certificate, so every call goes through `curl -k`.
