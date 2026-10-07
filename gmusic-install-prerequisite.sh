#!/usr/bin/env bash
# Check or install the host packages required by the G.Music watch, analysis,
# engraving, audio rendering, publishing, and Gaia rsync workflow.
#
# Credentials are deliberately not installed or copied. Provision ~/.env on
# each host separately when Groq transcription is required.
set -Eeuo pipefail

MODE="check"
case "${1:-}" in
  ""|--check) ;;
  --install) MODE="install" ;;
  -h|--help)
    cat <<'EOF'
Usage: gmusic-install-prerequisite.sh [--check|--install]

  --check    Report missing commands, Python modules, and the soundfont (default)
  --install  Install Debian/Ubuntu packages with apt, then run the checks

Packages cover rsync/SSH, ABC engraving, SVG conversion, FluidSynth rendering,
FFmpeg probing/encoding, ImageMagick, JSON/HTTP/file helpers, NumPy, SciPy, and
the FluidR3 General MIDI soundfont.

Secrets are outside this script. Create ~/.env manually on the target host if
GROQ_API_KEY-backed transcription is needed.
EOF
    exit 0 ;;
  *) echo "Unknown option: $1" >&2; exit 2 ;;
esac

PACKAGES=(
  rsync
  openssh-client
  git
  abcmidi
  abcm2ps
  librsvg2-bin
  fluidsynth
  fluid-soundfont-gm
  ffmpeg
  lame
  jq
  curl
  file
  imagemagick
  python3
  python3-numpy
  python3-scipy
)

if [[ "$MODE" == install ]]; then
  command -v apt-get >/dev/null || {
    echo "Automatic installation currently supports Debian/Ubuntu apt hosts only." >&2
    exit 1
  }
  if [[ $EUID -eq 0 ]]; then
    APT=(apt-get)
  else
    command -v sudo >/dev/null || { echo "sudo is required for --install" >&2; exit 1; }
    APT=(sudo apt-get)
  fi
  "${APT[@]}" update
  "${APT[@]}" install -y "${PACKAGES[@]}"
fi

missing=0
check_command() {
  local command_name="$1" package_name="$2"
  if path=$(command -v "$command_name" 2>/dev/null); then
    printf 'OK      %-16s %s\n' "$command_name" "$path"
  else
    printf 'MISSING %-16s apt package: %s\n' "$command_name" "$package_name"
    missing=$((missing + 1))
  fi
}

check_command rsync rsync
check_command ssh openssh-client
check_command git git
check_command abc2midi abcmidi
check_command abcm2ps abcm2ps
check_command rsvg-convert librsvg2-bin
check_command fluidsynth fluidsynth
check_command ffmpeg ffmpeg
check_command ffprobe ffmpeg
check_command lame lame
check_command jq jq
check_command curl curl
check_command file file
check_command convert imagemagick
check_command python3 python3

if python3 -c 'import numpy, scipy' >/dev/null 2>&1; then
  printf 'OK      %-16s %s\n' 'numpy+scipy' "$(python3 -c 'import numpy, scipy; print("numpy=" + numpy.__version__ + " scipy=" + scipy.__version__)')"
else
  printf 'MISSING %-16s apt packages: python3-numpy python3-scipy\n' 'numpy+scipy'
  missing=$((missing + 1))
fi

SOUNDFONT="${JAMAI_SOUNDFONT:-/usr/share/sounds/sf2/FluidR3_GM.sf2}"
if [[ -r "$SOUNDFONT" ]]; then
  printf 'OK      %-16s %s\n' soundfont "$SOUNDFONT"
else
  printf 'MISSING %-16s apt package: fluid-soundfont-gm (%s)\n' soundfont "$SOUNDFONT"
  missing=$((missing + 1))
fi

if ((missing)); then
  printf '\n%d prerequisite check(s) failed. Run %s --install on an apt host.\n' \
    "$missing" "$0" >&2
  exit 1
fi
printf '\nAll G.Music host prerequisites are present.\n'
