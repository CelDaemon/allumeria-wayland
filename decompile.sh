#!/bin/sh

set -eu

base_dir="$(dirname "$(realpath "$0")")"
patch_dir="$base_dir/patch"
game_dir="$1"

allumeria_dll="$game_dir/Allumeria.dll"

decomp_dir="$base_dir/Allumeria"

if ! [ -f "$allumeria_dll" ]
then
    echo "Could not find Allumeria.dll" >&2
    exit 1
fi

# rm -r "$decomp_dir"

dotnet tool run ilspycmd -- --nested-directories -p -o "$base_dir/Allumeria" "$allumeria_dll"

echo "Finished decompiling"

cp "$patch_dir/Allumeria.csproj" "$decomp_dir/Allumeria.csproj"

echo "Replaced Project"

cd "$decomp_dir"

echo "Checked out decomp dir, applying patches"

for file in "$patch_dir"/*.patch
do
    patch -p1 < "$file"
done

echo "Applies patches"

cp -r "$game_dir/res" "$decomp_dir"

echo "Copied resources"
