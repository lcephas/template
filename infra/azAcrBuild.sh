#!/bin/bash
set -e

echo "Building and uploading nginx image. Please wait..."
az acr build --resource-group $GROUP_NAME \
  --registry $ACR_NAME \
  --image nginx https://github.com/lcephas/template.git#main:images/nginx \
  --file Dockerfile \
  --platform linux \
  --no-logs \
  --output none
echo "Success!"

echo "Building and uploading otel-collector image. Please wait..."
az acr build --resource-group $GROUP_NAME \
  --registry $ACR_NAME \
  --image otel-collector https://github.com/lcephas/template.git#main:images/otel-collector \
  --file Dockerfile \
  --platform linux \
  --no-logs \
  --output none
echo "Success!"
