# cf-helm-push
This action pushes a local chart to a CodeFresh hosted chart museum repository using a token

## Inputs

### `cf-api-key`

**Required** CodeFresh API Key.

## Outputs

### `time`

The time it completed

## Example usage

uses: actions/hello-world-docker-action@v7
with:
  api-key: ${secrets.cf-api-key}
  reposiory: "cm://h.cfcr.io/your_cf_user/default"