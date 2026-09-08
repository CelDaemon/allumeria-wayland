#!/bin/sh

set -eu

base_dir="$(dirname "$(realpath "$0")")"
patch_dir="$base_dir/patch"
extra_dir="$base_dir/extra"
decomp_dir="$base_dir/Allumeria"

if [ -e "$decomp_dir" ]
then
    echo "Decomp dir already exists, cannot continue" >&2
    exit 1
fi

if [ -z "${1:-}" ]
then
    echo "No game dir provided" >&2
    exit 1
fi

game_dir="$1"
allumeria_dll="$game_dir/Allumeria.dll"

if ! [ -f "$allumeria_dll" ]
then
    echo "Could not find Allumeria.dll" >&2
    exit 1
fi

dotnet tool restore

dotnet tool run ilspycmd -- --nested-directories -p -o "$decomp_dir" "$allumeria_dll"

echo "Finished decompiling"

cp -r "$game_dir/res" "$decomp_dir"

echo "Copied resources"

for file in "$extra_dir"/*
do
    cp "$file" "$decomp_dir"
done

echo "Wrote extras"

git -C "$decomp_dir" init
git -C "$decomp_dir" add -A
git -C "$decomp_dir" commit -m 'Initial Commit'
git -C "$decomp_dir" tag -m 'base' base

echo "Initialised git"

"$base_dir/patch/patch.sh" "$decomp_dir"

echo "Applied patches"
