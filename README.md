# opencode gitlab docker

This project aims to provide a prebuild docker image to integrate opencode into gitlab.
The image is build on top of `ghcr.io/anomalyco/opencode` and provides the follwoing extra features:
- Extra shell commands:
  - glab
  - git
  - jq
  - bash
  - coreutils
- Extra opencode commands:
  - mr-review
    Performs a Merge request review. It will check the changes, related issues, provide inline feedback and approve/reject the MR.

The image can be used with Gitlab webhooks to react to MR and issues comments like `@opencode review this` or `@opencode implement this`.

## Environment variables
The image requires callers to provide a minimal information using environment variables:
- *GITLAB_AUTH_TOKEN*. Token to autenticate into gitlab. Must have at least the following permisions: `api, write_repository`.
- *PROJECT_URL*. URL of git repository inside *GITLAB_HOST*. Example: `https://gitlab.company.com/group/project1`.
- *MERGE_REQUEST_IID* (mandatory for `mr-review` command). Merge request identifier within *PROJECT_URL* that will be reviewed.
- *ADDITIONAL_COMMENTS* (optional). Additional comments/considerations for agent during command execution.
- *GITLAB_HOST* (optional). Default: `gitlab.com`.
- *GITLAB_API_PROTOCOL* (optional). Default: `https`.
- *GITLAB_GIT_PROTOCOL* (optional). Default: `https`.

## Opencode configuration
The image has the general opencode configuration in folder `/root/.config/opencode`.
This allows callers to customize opencode configuration, for example to set model, providers, etc. options.
Note that options may be also defined using environment variables as in any opencode run. See [opencode config](https://opencode.ai/docs/config/).

### Example to set model and provider api-key using config.json
```sh
bash$ cat my-opencode-config.json 
{
  "$schema": "https://opencode.ai/config.json",
  "model": "opencode/glm-5",
  "provider": {
    "opencode": {
      "options": {
        "apiKey": "sk-123456789123456789"
      }
    }
  }
}
bash$ docker run --rm -v ./my-opencode-config.json:/root/.config/opencode/config.json ...
```

## Docker manual execution
The follwoing example shows a complete docker command to perform a MR review.

```sh
bash$ docker run --rm \
  -v ./my-opencode-config.json:/root/.config/opencode/config.json \
  -e GITLAB_HOST=gitlab.company.com \
  -e GITLAB_AUTH_TOKEN=glpat-123456789 \
  -e PROJECT_URL=https://gitlab.company.com/group/project1 \
  -e MERGE_REQUEST_IID=123 \
  ghcr.io/metbosch/opencode-glab \
  opencode run --command mr-review
```

## Gitlab integration
TBD
