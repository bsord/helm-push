# cf-helm-push
This action pushes a local chart to a CodeFresh hosted chart museum repository using a token

## Inputs

### `access-token`

**Required** CodeFresh API Key.

### `repository-url`

**Required** ChartMuseum protocol url for destination repository.

### `chart-folder`

Folder within repo that contains the chart to be uploaded.

### `force`

Whether or not to overwrite existing chart with same version.

## Example usage

```
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: bsord/cf-helm-push@v14.0.7
    with:
      access-token: ${{ secrets.CF_API_KEY }}
      repository-url: 'cm://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```