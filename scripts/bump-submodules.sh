#!/usr/bin/env bash

set -ex

pushd source-repo
  git submodule update --recursive --remote

  if [ -n "$(git status --porcelain)" ]; then
    git config user.email "pivotal-netgarden-eng@pivotal.io"
    git config user.name "CI (Automated)"
    git add .
    git commit -m "Update submodules"
  fi
popd

cp -r source-repo/. bumped-repo/
