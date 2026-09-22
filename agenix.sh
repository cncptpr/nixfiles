#!/usr/bin/env bash

git add . --intent-to-add
nix run github:oddlama/agenix-rekey -- $@
git add . --intent-to-add
