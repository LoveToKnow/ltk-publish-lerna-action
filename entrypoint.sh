#!/bin/sh -l

# Exit immediately if something goes wrong
set -e

echo "🤖 Starting automated publishing..."

# consts
EVENT_JSON_PATH=$GITHUB_EVENT_PATH
BREAKING_CHANGE="BREAKING CHANGE"

# only for testing purposes :)
# jq . < $EVENT_JSON_PATH


# git setup
git config --global --add safe.directory /github/workspace
git config --global user.name '🤖 gh-actions release bot'
git config --global user.email 'github-actions-release[bot]@users.noreply.github.com'
git remote set-url origin https://x-access-token:${PRIVATE_REPO_PAT}@github.com/$GITHUB_REPOSITORY

# npm setup
#  remove .npmrc if exists to avoid interference with lerna publishing
rm -f .npmrc
#  set .npmrc based on our .npmrc.ci to ensure we always have the correct setup for npm :)
mv /.npmrc.ci .npmrc

# parse the event json...
# If it contains the 'BREAKING CHANGE' text it is a MAJOR release
# We check in the event the commit messages and the head_commit message 
# to make sure we will find the information we are interested into :)
if jq '.commits[].message, .head_commit.message' < $EVENT_JSON_PATH | grep -q "$BREAKING_CHANGE";
then
    # Handle major release
    echo "🤖 Publishing a MAJOR release..."
    npx lerna@4.0.0 publish major --yes
else
    # Let lerna handle the other cases :)
    echo "🤖 Publishing..."
    npx lerna@4.0.0 publish --yes
fi
