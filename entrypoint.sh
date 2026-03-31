#!/bin/sh

set -e


# Bidirectional sync between GITLAB_INSTANCE_URL and GITLAB_API_PROTOCOL/GITLAB_HOST
if [ -n "$GITLAB_INSTANCE_URL" ]; then
  # If GITLAB_INSTANCE_URL is set, parse it to set GITLAB_HOST and GITLAB_API_PROTOCOL
  proto_host=$(echo "$GITLAB_INSTANCE_URL" | sed -E 's#(https?)://([^/]+).*#\1 \2#')
  GITLAB_API_PROTOCOL=$(echo $proto_host | awk '{print $1}')
  GITLAB_HOST=$(echo $proto_host | awk '{print $2}')
else
  # If not set, construct GITLAB_INSTANCE_URL from protocol and host
  GITLAB_INSTANCE_URL="${GITLAB_API_PROTOCOL}://${GITLAB_HOST}"
fi

# Setup auth in glab and git commands
glab auth login \
  --hostname $GITLAB_HOST \
  --token "$GITLAB_TOKEN" \
  --api-protocol $GITLAB_API_PROTOCOL \
  --git-protocol $GITLAB_GIT_PROTOCOL
echo "machine $GITLAB_HOST login oauth2 password $GITLAB_TOKEN" > ~/.netrc
chmod 600 ~/.netrc

# Clone the project repository
glab repo clone $PROJECT_URL . -- --depth 1

exec $@