## Module for Storage buckets

This module creates Google Cloud Storage buckets and sets [Storage IAM permissions](https://cloud.google.com/storage/docs/access-control/iam-roles) on them. The motivation to create a module out of this is that the permissions mapping needs two separate objects and would lead to a lot of copy-pasted boilerplate code if defined from scratch each time we need a new bucket. The [google_iam_policy](https://www.terraform.io/docs/providers/google/d/iam_policy.html) resource defined here groups all the bindings that are applied to the bucket with [google_storage_bucket_iam_policy](https://www.terraform.io/docs/providers/google/r/storage_bucket_iam.html).

To be able to further modify a bucket after creation, the Terraform service account needs to be roles/storage.admin on the bucket. This is defined on the project level though.

## To add a new bucket
Import this module and set the relevant variables.

## To add a new role and binding
Define the binding in [main.tf](main.tf) and create a variable to keep the member arguments (passed in when using the module) in [variables.tf](variables.tf).
