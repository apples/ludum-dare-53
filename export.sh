#!/usr/bin/env bash
set -e

GODOT=/c/Users/dbral/Downloads/Godot_v4.0.2-stable_win64.exe/Godot_v4.0.2-stable_win64_console
EXPORT=--export-release
BUILDS_DIR=.builds

HTML5_TEMPLATE="Web"
HTML5_DIR="html5"

WIN64_TEMPLATE="Windows Desktop"
WIN64_DIR="win64"

VERSION=$(git describe --always)
VNAME="grav_garb_$VERSION"

# HTML5

mkdir -p "$BUILDS_DIR/$HTML5_DIR"
"$GODOT" "$EXPORT" "$HTML5_TEMPLATE"
pushd "$BUILDS_DIR"
find "$HTML5_DIR" -printf "%P\n" | tar -avcf "${VNAME}_html5.zip" --no-recursion -C "$HTML5_DIR" -T -
popd

# Windows x64

WIN64_VDIR="${VNAME}_win64"
mkdir -p "$BUILDS_DIR/$WIN64_DIR"
"$GODOT" "$EXPORT" "$WIN64_TEMPLATE"
pushd "$BUILDS_DIR"
cp -a "$WIN64_DIR/." "$WIN64_VDIR"
tar -avcf "$WIN64_VDIR.zip" "$WIN64_VDIR"
rm -rf "$WIN64_VDIR"
popd

