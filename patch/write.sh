#!/bin/sh

set -u

base_dir="$(dirname "$(realpath "$0")")"

if [ -z "${1:-}" ]
then
    echo "No source dir provided" >&2
    exit 1
fi

src_dir="$1"

if ! [ -d "$src_dir" ]
then
    echo "Source dir is not a directory" >&2
    exit 1
fi

rm -r "$base_dir"/*.patch

git -C "$src_dir" format-patch -o "$base_dir" base

