#!/bin/sh
set -e

# Setup auth in glab and git commands
glab auth login \
  --hostname $GITLAB_INSTANCE_URL \
  --token "$GITLAB_TOKEN" \
  --api-protocol $GITLAB_API_PROTOCOL \
  --git-protocol $GITLAB_GIT_PROTOCOL
echo "machine $GITLAB_INSTANCE_URL login oauth2 password $GITLAB_TOKEN" > ~/.netrc
chmod 600 ~/.netrc

# Clone the project repository
glab repo clone $PROJECT_URL . -- --depth 1

exec $@