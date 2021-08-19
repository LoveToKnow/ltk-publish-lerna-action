#!/bin/sh -l

# Exit immiediately if something goes wrong
set -e

echo "🤖 Starting automated publishing..."

# consts
EVENT_JSON_PATH=$GITHUB_EVENT_PATH
BREAKING_CHANGE="BREAKING CHANGE"

# only for testing purposes :)
# jq . < $EVENT_JSON_PATH


# git setup
git config --global user.name '🤖 gh-actions release bot'
git config --global user.email 'github-actions-release[bot]@users.noreply.github.com'
git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/$GITHUB_REPOSITORY

# parse the event json...
# If it contains the 'BREAKING CHANGE' text it is a MAJOR release
# We check in the event the commit messages and the head_commit message 
# to make sure we will find the information we are interested into :)
if jq '.commits[].message, .head_commit.message' < $EVENT_JSON_PATH | grep -q "$BREAKING_CHANGE";
then
    # Handle major release
    echo "🤖 Publishing a MAJOR release..."
    npx lerna publish major --conventional-commits --yes
else
    # Let lerna handle the other cases :)
    echo "🤖 Publishing..."
    npx lerna publish --conventional-commits --yes
fi
