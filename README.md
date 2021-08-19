# ltk-publish-lerna-action
Shared github action for automated package publishing in lerna monorepos

This Dockerized action is using **Node v12**

## What it does
Checks your commit messages and
- If it detects the text `BREAKING CHANGE` it publishes a MAJOR version 
- Otherwise it publishes a PATCH or MINOR version following the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) format

## Setup
1. Your project should be a lerna monorepo

2. In case you have configured an "allowBranch" in your `lerna.json` make sure that the action ONLY runs in that branch



## Example Usage

The follwing config assumes that
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

      - name: Publish 🚀
        uses: LoveToKnow/ltk-publish-lerna-action@main
```

