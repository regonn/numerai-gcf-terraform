Put `gcp-json-keyfile.json` file from [GCP service account keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-create-console)

### Need Enable APIs

- Cloud Functions API
  - https://console.cloud.google.com/marketplace/product/google/cloudfunctions.googleapis.com
- Cloud Run API
  - https://console.cloud.google.com/marketplace/product/google/run.googleapis.com
- Artifact Registry API
  - https://console.cloud.google.com/marketplace/product/google/artifactregistry.googleapis.com
- Cloud Build API
  - https://console.cloud.google.com/apis/library/cloudbuild.googleapis.com

### Make Function zip file

```
$ cd ml_function
$ zip -r ../ml_function.zip *
```

### Install terraform cli

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

### Deploy Terraform

```
$ terraform init
$ terraform plan
$ terraform apply
```
