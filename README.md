# Helm Push to ChartMuseum

Push a chart to a ChartMuseum compatible repository using Token based authencation with Helm v3

## Usage
```yaml
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: bsord/cf-helm-push@v1
    with:
      access-token: ${{ secrets.CF_API_KEY }}
      repository-url: 'cm://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```

### Parameters

| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `access-token` | API Token from CodeFresh with Helm read/write permissions | **Yes** | "" |
| `repository-url` | ChartMuseum repository url, prefix with cm:// | **Yes** | "" |
| `chart-folder` | Relative path to chart folder to be published| No | chart |
| `force` | Force overwrite if version already exists | No | false |

## License

This project is distributed under the [MIT license](LICENSE.md).
