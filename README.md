# Orderly Serverless Function

## ▶️ Running

1. Copy `terraform.tfvars.backup` to `terraform.tfvars`
2. Enable Google Cloud APIs

```sh
gcloud services enable cloudfunctions.googleapis.com
gcloud services enable storage.googleapis.com
gcloud services enable cloudbuild.googleapis.com
```

3. Start terraform and deploy

```sh
terraform init
terraform plan
terraform apply
```

## ❔ How it works

To deploy a serverless function on Google Cloud Platform (GCP) using Terraform, the process involves:

1. **Packaging your function's code into a zip file**
2. **Uploading it to a Cloud Storage bucket**
3. **Creating a Cloud Function resource that uses this uploaded code.**

- **Serverless Function**: A serverless function is a piece of code that runs in response to events without requiring you to manage a server or runtime environment. It scales automatically and you only pay for the compute time you consume.

- **Cloud Storage Bucket**: The bucket serves as a storage location for the zipped source code of your serverless function. It's necessary because Google Cloud Functions requires the source code to be accessible from Cloud Storage for deployment.

- **Terraform Automation**:
  - **`terraform.tfvars`**: Before running Terraform, you copy `terraform.tfvars.backup` to `terraform.tfvars` to provide required configurations like project ID and region.
  - **`terraform init`**: Initializes Terraform, setting up the necessary plugins.
  - **`terraform plan`**: Shows what Terraform intends to do based on your configurations. It's a way to review changes before applying them.
  - **`terraform apply`**: Executes the deployment, creating the Cloud Storage bucket (if it doesn't already exist), uploading the zipped function code, and deploying the Cloud Function.
