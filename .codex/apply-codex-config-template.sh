#!/bin/sh

# Expand the portable Codex config.toml.template with this machine's HOME and
# atomically install it as $HOME/.codex/config.toml. The existing config is
# saved as config.toml.bak before it is replaced.

set -eu
umask 077

script_name=${0##*/}

if [ -z "${HOME:-}" ]; then
  printf '%s: HOME must be set and non-empty\n' "$script_name" >&2
  exit 1
fi

script_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd -P)
template=$script_dir/config.toml.template
target_dir=$HOME/.codex
target=$target_dir/config.toml
backup=$target.bak
tmp_file=
backup_tmp=

cleanup() {
  if [ -n "${tmp_file:-}" ]; then
    rm -f "$tmp_file" || :
  fi
  if [ -n "${backup_tmp:-}" ]; then
    rm -f "$backup_tmp" || :
  fi
}

on_signal() {
  cleanup
  exit 1
}

trap cleanup 0
trap on_signal HUP INT TERM

if [ ! -r "$template" ]; then
  printf '%s: template not readable: %s\n' "$script_name" "$template" >&2
  exit 1
fi

mkdir -p "$target_dir"
tmp_file=$(mktemp "$target_dir/.config.toml.tmp.XXXXXX")

awk '
  BEGIN {
    marker = "$HOME"
    home = ENVIRON["HOME"]
  }
  {
    line = $0
    expanded = ""
    while ((position = index(line, marker)) != 0) {
      expanded = expanded substr(line, 1, position - 1) home
      line = substr(line, position + length(marker))
    }
    print expanded line
  }
' "$template" > "$tmp_file"

if [ -f "$target" ]; then
  backup_tmp=$(mktemp "$target_dir/.config.toml.bak.tmp.XXXXXX")
  cp -p "$target" "$backup_tmp"
  mv "$backup_tmp" "$backup"
  backup_tmp=
fi

mv "$tmp_file" "$target"
tmp_file=
