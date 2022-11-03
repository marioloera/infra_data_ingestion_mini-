module "bucket_catalystone_import" {
  source = "../modules/bucket"

  name              = "catalystone-import"
  delete_after_days = 30
}

module "bucket_data_science" {
  source = "../modules/bucket"

  name = "data-science"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_github_action_data_science_deployment.email),
    "group:bigquery.powerusers@trustly.com",
  ]
}

module "bucket_entercash_import" {
  source = "../modules/bucket"

  name = "entercash-import"
}

module "bucket_gluepay_export" {
  source = "../modules/bucket"

  name              = "gluepay-export"
  delete_after_days = 30
  object_admin = [
    "group:team.datascience@trustly.com",
    "group:team.dataengineeringemea@trustly.com",
  ]
  object_viewer = [
    format("serviceAccount:%s", google_service_account.svc_bi_etl.email),
    "group:team.database@trustly.com",
  ]
}
module "bucket_gluepay_import" {
  source = "../modules/bucket"

  name              = "gluepay-import"
  delete_after_days = 30
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_bi_etl.email),
  ]
}

module "bucket_jira_import" {
  source = "../modules/bucket"

  name              = "jira-import"
  delete_after_days = 30
}

module "bucket_phoenix_import" {
  source = "../modules/bucket"

  name = "phoenix-import"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_kafka_connect.email)
  ]
  object_viewer = [
    "group:team.tech@trustly.com",
  ]
}

module "bucket_phoenix_staging_import" {
  source = "../modules/bucket"

  name = "phoenix-staging-import"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_kafka_connect.email)
  ]
  object_viewer = [
    "group:team.tech@trustly.com",
  ]
}

module "bucket_phoenix_schemas" {
  source = "../modules/bucket"

  name = "phoenix-schemas"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com",
  ]
  object_viewer = [
    "group:team.tech@trustly.com",
  ]
}

module "bucket_salesforce_import" {
  source = "../modules/bucket"

  name              = "salesforce-import"
  delete_after_days = 30
}

module "bucket_schemas" {
  source = "../modules/bucket"

  name = "schemas"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_bi_etl.email),
  ]
  object_viewer = [
  ]
}

module "bucket_schemas_secure" {
  source = "../modules/bucket"

  name              = "schemas-secure"
  delete_after_days = 30
  object_viewer = [
  ]
}

module "bucket_paywithmybank_import" {
  source = "../modules/bucket"

  name = "paywithmybank-import"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_paywithmybank.email)
  ]
}

module "bucket_slack_import" {
  source = "../modules/bucket"

  name = "slack-import"
}

module "bucket_dataflow_temp" {
  source = "../modules/bucket"

  name = "dataflow-temp"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}

# Used to store Dataflow Templates created by a CD job and triggered (typically) by Airflow
module "bucket_dataflow_templates" {
  source = "../modules/bucket"

  name = "dataflow-templates"
  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}
