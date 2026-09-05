#!/bin/sh

game_dir="$1"

allumeria_dll="$game_dir/Allumeria.dll"


if ! [ -f "$allumeria_dll" ]
then
    echo "Could not find Allumeria.dll" >&2
    exit 1
fi
