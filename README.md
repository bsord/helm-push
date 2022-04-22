# Helm Push
![Build](https://github.com/oodlefinance/helm-push/workflows/Build/badge.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/oodlefinance/helm-push.svg)
![License](https://img.shields.io/github/license/oodlefinance/helm-push.svg?style=flat)

Push a chart to a ChartMuseum or OCI compatible registry with Helm v3

## Usage
Using Token Auth with OCI Registry:
```yaml
steps:
  - name: Push Helm chart to OCI compatible registry (Github)
    uses: oodlefinance/helm-push@5.0.0
    with:
      useOCIRegistry: true
      registry-url:  https://ghcr.io/${{ github.repository }}
      username: bsord
      access-token: ${{ secrets.REGISTRY_ACCESS_TOKEN }}
      force: true
      chart-folder: chart
```

Using Token Auth with AWS ECR: (Feel free to use any AWS CLI action step of your choice)
```yaml
steps:
  - name: AWS ECR Login
    id: ecr_login
    uses: KaMeHb-UA/aws-cli-action@v3
    with:
      command: aws ecr get-login-password

  - name: Push Helm chart to Amazon Elastic Container Registry (ECR)
    uses: oodlefinance/helm-push@5.0.0
    with:
      useOCIRegistry: true
      registry-url: oci://123456789123.dkr.ecr.eu-west-1.amazonaws.com
      username: AWS
      access-token: ${{ steps.ecr_login.outputs.result }}
      chart-folder: chart
```

Using Password Auth:
```yaml
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: oodlefinance/helm-push@5.0.0
    with:
      username: ${{ secrets.HELM_USERNAME }}
      password: ${{ secrets.HELM_PASSWORD }}
      registry-url: 'https://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```

Using Token Auth:
```yaml
steps:
  - name: Push Helm Chart to ChartMuseum
    uses: oodlefinance/helm-push@5.0.0
    with:
      access-token: ${{ secrets.HELM_API_KEY }}
      registry-url: 'https://h.cfcr.io/user_or_org/reponame'
      force: true
      chart-folder: chart
```

### Parameters

| Key | Value | Required | Default |
| ------------- | ------------- | ------------- | ------------- |
| `useOCIRegistry` | Push to OCI compatibly registry | No | false |
| `access-token` | API Token with Helm read/write permissions | **Yes** (if using token auth) | "" |
| `username` | Username for registry | **Yes** (if using pw auth) | "" |
| `password` | Password for registry | **Yes** (if using pw auth) | "" |
| `registry-url` | Registry url | **Yes** | "" |
| `chart-folder` | Relative path to chart folder to be published| No | chart |
| `force` | Force overwrite if version already exists | No | false |

## License

This project is distributed under the [MIT license](LICENSE.md).

## TODO
