#!/bin/sh
set -e

# Setup auth in glab and git commands
glab auth login \
  --hostname $GITLAB_HOST \
  --token "$GITLAB_AUTH_TOKEN" \
  --api-protocol $GITLAB_API_PROTOCOL \
  --git-protocol $GITLAB_GIT_PROTOCOL
echo "machine $GITLAB_HOST login oauth2 password $GITLAB_AUTH_TOKEN" > ~/.netrc
chmod 600 ~/.netrc

# Clone the project repository
glab repo clone $PROJECT_URL . -- --depth 1

exec $@