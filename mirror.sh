#!/usr/bin/env sh
set -eu

sh -c "git config --global --add safe.directory $PWD"

/setup-ssh.sh

export GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no -l $INPUT_SSH_USERNAME"
git remote add mirror "$INPUT_TARGET_MONOREPO_URL"

git fetch --all
git submodule update --init --recursive

git push --tags --force --prune --verbose mirror main
