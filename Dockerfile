ARG IMAGE=ghcr.io/anomalyco/opencode
ARG TAG=latest
FROM ${IMAGE}:${TAG}

LABEL maintainer="@metbosch"

# Set default environment variables for GitLab authentication and configuration
ENV GITLAB_HOST=gitlab.com
ENV GITLAB_AUTH_TOKEN=invalid-auth-token
ENV GITLAB_API_PROTOCOL=https
ENV GITLAB_GIT_PROTOCOL=https

# Set a default project URL for cloning (this should be overridden with a valid URL in production)
ENV PROJECT_URL=invalid-project-url
ENV MERGE_REQUEST_IID=0
ENV ADDITIONAL_COMMENTS=""

RUN apk update \
  && apk add --no-cache jq bash git coreutils glab

RUN mkdir -p /root/.config/opencode
COPY opencode /root/.config/opencode/
COPY entrypoint.sh /entrypoint.sh

WORKDIR /var/src/app
ENTRYPOINT ["/entrypoint.sh"]
