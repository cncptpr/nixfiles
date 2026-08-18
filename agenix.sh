#!/usr/bin/env bash

git add . --intend-to-add
nix run github:oddlama/agenix-rekey -- $@
git add . --intend-to-add
