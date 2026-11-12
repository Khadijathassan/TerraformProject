# Hello World Static Site on S3

A static "Hello World" website hosted on Amazon S3 and provisioned with Terraform.

## Layout

```
app/    # Website source (HTML/CSS). Edit the site here.
infra/  # Terraform that creates the S3 bucket and uploads everything in app/.
```

The app and infrastructure are kept separate. Terraform reads `app/` through the `app_dir` variable (default `../app`) and uploads every file in it, setting each file's `Content-Type` from its extension.

## Prerequisites

- Terraform >= 1.5
- AWS credentials configured (for example `aws configure` or `AWS_PROFILE`)

## Deploy

```sh
cd infra
terraform init
terraform plan
terraform apply
```

When the apply finishes, open the `website_url` output in a browser.

To change the region or bucket name prefix, pass `-var 'aws_region=eu-west-1'` or create a `terraform.tfvars` file.

## Update the site

Edit files in `app/`, then run `terraform apply` again from `infra/`. Terraform spots changed files by their MD5 hash and re-uploads only those.

## Tear down

```sh
cd infra
terraform destroy
```

Note: the S3 website endpoint serves over HTTP only. For HTTPS or a custom domain, put CloudFront in front of the bucket.
