## Infra as code for Data Services

The Data Services project essentially consists of a number of [Cloud Storage](https://cloud.google.com/storage/docs) Buckets, [BigQuery](https://cloud.google.com/bigquery/docs) Datasets and a [Cloud Composer](https://cloud.google.com/composer/docs) environment to shuffle data between those buckets and datasets.

This repo handles the provisioning of all resources needed to build the infrastructure from scratch on a blank project. Some gotchas still remain:
* Terraform might have to be run twice the first time to activate the APIs (could be solved by setting a lot of 'depends_on' attributes but it should be a rare occurrence)
* The Airflow Connections have to be created manually as we have no good secret store to connect to from GCP
* When creating the Cloud Composer environment, Google sets up a lot of things in the background, i.e. service accounts and two Storage buckets. These will be outside of the scope of what Terraform controls and that's ok.

## Usage

A [GitHub Action](.github/workflows/terraform.yml) authored by the Platform team takes care of applying the changes when merging to master. It is possible to apply the change from a local environment if you have created a key for the Terraform Service Account but this is discouraged. See the GitHub Action file for some inspiration on how to do this.


## Development
Make sure that you install the packages
```
python3 -m venv venv
make install
pre-commit install
```

To have same code formate use:
```
make lint
```
This will run the pre-commit hooks and terraform format

__IMPORTANT__: This command does not only analyse the files in the repo but also writes changes to your local version of the files.



### Developer Workflow

The workflow suggested by the platform team is to commit every change we want to make to the git repo, and the Github
Action described above will run the `terraform plan` for us and show the results. If you are going to be making many
incremental changes to the code, or if you are trying to understand how a change affects some resource, its more
efficient to run the code locally.

### Running terraform locally on your machine

1. Run `terraform init` if you havent already done so once. This installs the necessary modules on your machine.

2. To run `terraform plan` successfully, you need a service account key for terraform. This is not the same service account
as composer uses. In the `trustly-data-services-test` project, go to IAM -> Service Accounts and export a key for the
service account named "Terraform Admin".

3. Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to point to the service account key file, for example:
```
$ export GOOGLE_APPLICATION_CREDENTIALS=~/Downloads/trustly-data-services-test-9982db2017e6.json
```

4. Go into the test directory and run terraform plan:

```
$ cd test
$ terraform plan
```

Output should be:

```

------------------------------------------------------------------------

No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```
