# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A static "Hello World" website hosted on an S3 website endpoint and provisioned with Terraform. The app code and the infrastructure code are deliberately kept apart:

- `app/` holds the plain HTML/CSS site. It has no build step, so files are deployed exactly as they are.
- `infra/` is a single Terraform root module using the AWS provider `~> 5.0` and Terraform >= 1.5. State is local; no backend is configured.

## Commands

Run all of these from `infra/`:

```sh
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform destroy
```

The site URL comes from `terraform output website_url`.

## How app and infra connect

- `infra/main.tf` uploads every file under `var.app_dir` (default `../app`, resolved relative to the module) using `fileset` plus a `for_each` over `aws_s3_object`. Adding a file to `app/` is enough to deploy it.
- Each object's `Content-Type` is looked up by file extension in `local.mime_types`. When you add a new file type, add its extension there; anything unknown is served as `application/octet-stream`, so browsers will download it.
- `etag = filemd5(...)` is what makes Terraform re-upload a file after it changes.
- The website configuration expects `app/index.html` and `app/error.html` to exist.

## Infra notes

- The bucket name comes from `bucket_prefix`, so AWS adds a unique suffix. Don't hardcode a bucket name.
- Public read access needs `block_public_policy` and `restrict_public_buckets` set to false. The bucket policy has `depends_on` on the public access block so the policy isn't applied before those settings are relaxed.
- `force_destroy = true` lets `terraform destroy` remove the bucket even when it still contains objects.
- The S3 website endpoint is HTTP only. HTTPS or a custom domain would need CloudFront.
