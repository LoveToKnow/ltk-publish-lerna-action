# Container image that runs your code
FROM node:12-alpine

# Install tools needed
RUN apk add --no-cache \
            jq \
            git

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY .npmrc.ci /.npmrc.ci
COPY entrypoint.sh /entrypoint.sh

# https://docs.npmjs.com/cli/v6/using-npm/config#unsafe-perm
RUN npm set unsafe-perm true

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
