#!/usr/bin/env sh
set -eu

sh -c "git config --global --add safe.directory $PWD"

/setup-ssh.sh

export GIT_SSH_COMMAND="ssh -v -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no -l $INPUT_SSH_USERNAME"
git remote add mirror "$INPUT_TARGET_MONOREPO_URL"

git fetch --all
git submodule update --init --recursive

for submodule in $(git submodule--helper list | awk '{print $4}'); do
    echo "Processing submodule: $submodule"

    # Move the submodule content to a regular directory
    git submodule deinit -f -- $submodule
    rm -rf .git/modules/$submodule

    # Make sure the submodule directory has its contents
    git add $submodule

    # Remove the .git folder to convert it to a regular directory
    rm -rf $submodule/.git

    # Stage the changes
    git add $submodule
done

git push --tags --force --prune --verbose mirror main
