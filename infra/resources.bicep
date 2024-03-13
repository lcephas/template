param location string

resource acr 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: 'acr${uniqueString(resourceGroup().id)}'
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: '${acr.name}-workspace'
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

module applicationInsightsResources 'appInsights.bicep' = {
  name: 'applicationinsights-resources'
  params: {
    prefix: acr.name
    location: location
    workspaceId: logAnalyticsWorkspace.id
  }
}

output APPLICATIONINSIGHTS_CONNECTION_STRING string = applicationInsightsResources.outputs.APPLICATIONINSIGHTS_CONNECTION_STRING
