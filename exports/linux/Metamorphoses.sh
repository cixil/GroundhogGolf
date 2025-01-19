#!/bin/sh
echo -ne '\033c\033]0;Metamorphoses\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Metamorphoses.x86_64" "$@"
