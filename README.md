# Helm Push
![Build](https://github.com/bsord/helm-push/workflows/Build/badge.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/bsord/helm-push.svg)
![License](https://img.shields.io/github/license/bsord/helm-push.svg?style=flat)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-green.svg)

Push a chart to a ChartMuseum compatible repository with Helm v3

## Usage
Using Token Auth:
```yaml
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: bsord/helm-push@v1
    with:
      access-token: ${{ secrets.HELM_API_KEY }}
      repository-url: 'https://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```

Using Password Auth:
```yaml
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: bsord/helm-push@v1
    with:
      username: ${{ secrets.HELM_USERNAME }}
      password: ${{ secrets.HELM_PASSWORD }}
      repository-url: 'https://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```

### Parameters

| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `access-token` | API Token from CodeFresh with Helm read/write permissions | **Yes** (if using token auth) | "" |
| `username` | Username for repository | **Yes** (if using pw auth) | "" |
| `password` | Password for repository | **Yes** (if using pw auth) | "" |
| `repository-url` | ChartMuseum repository url | **Yes** | "" |
| `chart-folder` | Relative path to chart folder to be published| No | chart |
| `force` | Force overwrite if version already exists | No | false |

## License

This project is distributed under the [MIT license](LICENSE.md).
