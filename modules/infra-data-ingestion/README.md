# Terraform module for data ingestion framework

This module contains the GCP assets necessary to deploy and run the data ingestion framework based on Pub/Sub, Dataflow and BigQuery using Avro for message encoding. The module is designed for inclusion in another, "parent", Terraform deployment.

In brief, the assets that are created are
* a Pub/Sub topic and a subscription
* a Dataflow worker service account
* a BigQuery dataset
* three Google Cloud Storage buckets (for schema registry, unprocessed avro messages, and dataflow temporary files)

To make the pipeline work there are a few more steps
1. upload the Avro schemas to the schema registry bucket
2. create the BigQuery tables
3. launch the pipeline

1 and 2 are normally done by GitHub Actions in the [TrustlyDev/data-lake-message-schema-avro](https://github.com/TrustlyDev/data-lake-message-schema-avro) repo but can be run from command line as well.
3 is done by a GitHub Action in [trustlybi/beam-pubsub-avro](https://github.com/trustlybi/beam-pubsub-avro).

## Example Usage
```
resource "google_service_account" "svc_dataflow_worker" {
  account_id = "svc-dataflow-worker"
}

module "data_ingestion" {
  source = "git::https://github.com/trustlybi/infra-data-ingestion"

  dataflow_worker        = google_service_account.svc_dataflow_worker.email
  schema_registry_bucket = "bi-test-beta-avro-schema-store"
  unprocessed_bucket     = "bi-test-beta-beam-pubsub-unprocessed"
}
```

## Required Arguments Reference
`dataflow_worker` the name (email) of the service account that will run the dataflow job. The module will _not_ create this account.

`schema_registry_bucket` name of the schema registry bucket. Will be created by the module.

`schema_registry_svc_account` name of the GCP service account used by the schema registry GitHub Action to upload schemas and patch tables. The module will _not_ create this account.

`unprocessed_bucket` name of the bucket where messages the pipeline cannot interpret will be stored. Will be created by the module.

`dataflow_temp_bucket` name of the bucket used by Dataflow to store temporary files. Will be created by the module.

See the [varibles.tf](variables.tf) file for a list of other (optional) arguments.


## Attributes Reference
See the [outputs.tf](outputs.tf) file for a list of the attributes this model provides.

## Important: permissions
GCP components defined in Terraform generally have three ways to set permissions:
* IAM Policy: Authoritative. Sets the IAM policy for the resource and replaces any existing policy.
* IAM Binding: Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. Other roles within the IAM policy for the resource are preserved.
* IAM Member: Non-authoritative. Updates the IAM policy to grant a role to a new member. Other members for the role for the resource are preserved.

In order for the pipeline to work, some permissions have to be set, typically for the Dataflow worker service account. This module only uses "IAM Member" for the resources where we can expect other permissions to be added (e.g. the dataset that someone will most likely want to view).

On the other hand, if the project into which this module is imported uses "IAM Policy" or "IAM Binding" on the project level and already has a policy for "roles/dataflow.worker", this module will not work as expected as that policy will in effect remove the permissions for the service account created by this module. Depending on which problems we run into in practice we can try to adapt the module to work for those situations.
