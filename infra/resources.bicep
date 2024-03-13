param name string
param location string
param resourceToken string
param tags object

resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
}

module nginxImage 'br/public:deployment-scripts/build-acr:2.0.2' = {
  name: 'nginx'
  params: {
    AcrName: acr.name
    location: location
    gitRepositoryUrl: 'https://github.com/lcephas/template.git'
    gitBranch: 'main'
    buildWorkingDirectory: 'images/nginx'
    imageName: 'nginx'
  }
}

module otelImage 'br/public:deployment-scripts/build-acr:2.0.2' = {
  name: 'otel-collector'
  params: {
    AcrName: acr.name
    location: location
    gitRepositoryUrl: 'https://github.com/lcephas/template.git'
    gitBranch: 'main'
    buildWorkingDirectory: 'images/otel-collector'
    imageName: 'otel-collector'
  }
}
