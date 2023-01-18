# ltk-publish-lerna-action
Shared github action for automated package publishing in lerna monorepos

This Dockerized action is using **Node v16**

## What it does
Checks your commit messages and
- If it detects the text `BREAKING CHANGE` it publishes a MAJOR version 
- Otherwise it publishes a PATCH or MINOR version following the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) format

## Setup
1. Your project should be a lerna monorepo

2. In case you have configured an "allowBranch" in your `lerna.json` make sure that the action ONLY runs in that branch

3. In your action make sure to configure the env variable of `PRIVATE_REPO_PAT`

## Example Usage

The following config assumes that
- The branch used for publishing is the `main` 
- Only runs for the `push` event
- Runs only if a change in the `packages` folder has been made

```yaml
name: Publish
on:
  push:
    branches:
      - main
    paths:
      - 'packages/**'
jobs:
  publish-lerna-packages:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout 🛎️
        uses: actions/checkout@v2.3.1
        with:
          # pulls all commits (needed for lerna / semantic release to correctly version)
          fetch-depth: "0"

      - name: Publish 🚀
        uses: LoveToKnow/ltk-publish-lerna-action@node-16
        env:
          PRIVATE_REPO_PAT: ${{ secrets.PRIVATE_REPO_PAT }}
```

