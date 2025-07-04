#!/usr/bin/bash

SCRIPT_DIR=$(dirname "$0")

echo "Script directory is $SCRIPT_DIR"

if [[ ! -d ~/.doom.d/ ]]; then
  echo "Creating ~/.doom.d/"
  mkdir ~/.doom.d
fi

for file in $SCRIPT_DIR/doom/*
do
  if [[ -e $file ]]; then
    echo "Creating symbolic link for $file"
    ln -s "$file" ~/.doom.d/
  else
    echo "No such file: $file"
  fi
done
