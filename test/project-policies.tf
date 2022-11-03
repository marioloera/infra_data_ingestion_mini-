/*
  A "google_project_iam_binding" only updates one particular role. If someone is added
  manually to that role (s)he will be removed when the Terraform config is applied.
  If someone is added to a role that is not listed in our Terraform config, that mapping
  will not be affected when the config is applied.

  The alternative would be to use the "google_project_iam_policy" resource which is
  "authoritative" on the project level meaning anything that is not in our Terraform
  config will be remove when it is applied. I think the risk of unintended consequences
  outweighs the extra security that will bring. Example: locking us out of the project
  or messing with Google controlled service accounts whose permissions are set up a bit
  under-the-hood.
*/

locals {
  terraform_admin = "terraform-admin@trustly-data-services-test.iam.gserviceaccount.com"
}

data "google_project" "current_project" {
}

resource "google_project_iam_member" "viewer" {
  project = data.google_project.current_project.id
  role    = "roles/viewer"
  member  = "group:team.businessintelligence@trustly.com"
}

resource "google_project_iam_member" "datascience_editor" {
  project = data.google_project.current_project.id
  role    = "roles/editor"
  member  = "group:team.datascience@trustly.com"
}

# Google managed service account, was removed as Editor when we removed the project_iam_binding
resource "google_project_iam_member" "cloudservices_editor" {
  project = data.google_project.current_project.id
  role    = "roles/editor"
  member = format("serviceAccount:%s@cloudservices.gserviceaccount.com",
  data.google_project.current_project.number)
}

# Google managed service account, was removed as Editor when we removed the project_iam_binding
resource "google_project_iam_member" "containerregistry_editor" {
  project = data.google_project.current_project.id
  role    = "roles/editor"
  member = format("serviceAccount:service-%s@containerregistry.iam.gserviceaccount.com",
  data.google_project.current_project.number)
}

# *********************** STORAGE ***********************
resource "google_project_iam_binding" "storage_admin" {
  project = data.google_project.current_project.id
  role    = "roles/storage.admin"
  members = [
    format("serviceAccount:%s", local.terraform_admin),
    "group:team.dataservices@trustly.com",
    "serviceAccount:svc-app-engine@trustly-data-services-test.iam.gserviceaccount.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email), # CI for data ingestion pipeline
  ]
}

resource "google_project_iam_binding" "storage_object_admin" {
  project = data.google_project.current_project.id
  role    = "roles/storage.objectAdmin"
  members = [
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    "group:team.dataservices@trustly.com",
    "group:bigquery.powerusers@trustly.com",
  ]
}

# *********************** BIGQUERY ***********************
resource "google_project_iam_binding" "bigquery_data_owner" {
  project = data.google_project.current_project.id
  # This role is needed to create tables with a policy tag (bigquery.tables.setCategory)
  # Apart from that most accounts could probably do with just bigquery.dataEditor
  role = "roles/bigquery.dataOwner"
  members = [
    format("serviceAccount:%s", local.terraform_admin),
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com", # CI/CD for dbt
    format("serviceAccount:%s", google_service_account.svc_dbt.email),
  ]
}

resource "google_project_iam_binding" "bigquery_job_user" {
  project = data.google_project.current_project.id
  role    = "roles/bigquery.jobUser"
  members = [
    "group:team.businessintelligence@trustly.com",
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com",     # CI/CD for dbt
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email), # CD for dataflow
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email),
    format("serviceAccount:%s", google_service_account.svc_dbt.email),
    format("serviceAccount:%s", google_service_account.svc_qliksense.email),
    format("serviceAccount:%s", google_service_account.svc_airbyte.email),
    format("serviceAccount:%s", google_service_account.svc_ab_test.email),
    "group:bigquery.powerusers@trustly.com",
    "group:team.tech@trustly.com",
    "user:sebastian.anerud@trustly.com",
  ]
}

resource "google_project_iam_binding" "bigquery_read_session_user" {
  project = data.google_project.current_project.id
  role    = "roles/bigquery.readSessionUser"
  members = [
    format("serviceAccount:%s", google_service_account.svc_qliksense.email),
  ]
}

resource "google_project_iam_binding" "bigquery_admin" {
  project = data.google_project.current_project.id
  role    = "roles/bigquery.admin"
  members = [
    "group:team.dataservices@trustly.com"
  ]
}

resource "google_project_iam_binding" "bigquery_data_editor" {
  project = data.google_project.current_project.id
  role    = "roles/bigquery.dataEditor"
  members = [
    "group:bigquery.powerusers@trustly.com",
  ]
}


# *********************** COMPOSER ***********************
resource "google_project_iam_binding" "composer_service_aggent2ext" {
  project = data.google_project.current_project.id
  role    = "roles/composer.ServiceAgentV2Ext"
  members = [
    format("serviceAccount:service-%s@cloudcomposer-accounts.iam.gserviceaccount.com", data.google_project.current_project.number),
  ]
}
resource "google_project_iam_binding" "composer_worker" {
  project = data.google_project.current_project.id
  role    = "roles/composer.worker"
  members = [
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
  ]
}

resource "google_project_iam_binding" "composer_user" {
  project = data.google_project.current_project.id
  role    = "roles/composer.user"
  members = [
    "group:team.businessintelligence@trustly.com",
    "group:bigquery.powerusers@trustly.com",
  ]
}

# ********************* DATA CATALOG *********************
resource "google_project_iam_binding" "datacatalog_category_fine_grained_reader" {
  project = data.google_project.current_project.id
  role    = "roles/datacatalog.categoryFineGrainedReader"
  members = [
    "group:team.dataservices@trustly.com",
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com", # CI/CD for dbt
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    format("serviceAccount:%s", google_service_account.svc_dbt.email),
    format("serviceAccount:%s", google_service_account.svc_qliksense.email),
  ]
}

resource "google_project_iam_binding" "datacatalog_category_admin" {
  project = data.google_project.current_project.id
  role    = "roles/datacatalog.categoryAdmin"
  members = [
    format("serviceAccount:%s", local.terraform_admin),
    # Needed to create tables with a policy tag (datacatalog.taxonomies.get)
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    format("serviceAccount:%s", google_service_account.svc_dbt.email),
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com", # CI/CD for dbt
    "group:bigquery.powerusers@trustly.com",
  ]
}

# *************** MACHINE LEARNING ENGINE ****************
resource "google_project_iam_binding" "ml_developer" {
  project = data.google_project.current_project.id
  role    = "roles/ml.developer"
  members = [
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email)
  ]
}

resource "google_project_iam_binding" "ml_admin" {
  project = data.google_project.current_project.id
  role    = "roles/ml.admin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_github_action_data_science_deployment.email),
    "group:bigquery.powerusers@trustly.com",
    "group:team.datascience@trustly.com",
  ]
}

# ************************ OTHER *************************
resource "google_project_iam_binding" "logging_log_writer" {
  project = data.google_project.current_project.id
  role    = "roles/logging.logWriter"
  members = [
    format("serviceAccount:%s", data.google_app_engine_default_service_account.default.email),
  ]
}

resource "google_project_iam_binding" "logging_private_log_viewer" {
  project = data.google_project.current_project.id
  role    = "roles/logging.privateLogViewer"
  members = [
    "group:team.dataservices@trustly.com",
    "group:team.datascience@trustly.com",
  ]
}

resource "google_project_iam_binding" "logging_viewer" {
  project = data.google_project.current_project.id
  role    = "roles/logging.viewer"
  members = [
    "group:bigquery.powerusers@trustly.com",
    "group:team.datascience@trustly.com",
  ]
}

resource "google_project_iam_binding" "iam_security_reviewer" {
  project = data.google_project.current_project.id
  role    = "roles/iam.securityReviewer"
  members = [
    "group:team.dataservices@trustly.com",
  ]
}

# ********************** DATAFLOW ************************
resource "google_project_iam_binding" "dataflow_admin" {
  project = data.google_project.current_project.id
  role    = "roles/dataflow.admin"
  members = [
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}

resource "google_project_iam_binding" "dataflow_worker" {
  project = data.google_project.current_project.id
  role    = "roles/dataflow.worker"
  members = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email)
  ]
}

resource "google_project_iam_binding" "dataflow_viewer" {
  project = data.google_project.current_project.id
  role    = "roles/dataflow.viewer"
  members = [
    "group:team.tech@trustly.com",
  ]
}

# *********************** MONITOING  *************************

resource "google_project_iam_binding" "monitoring_viewer" {
  project = data.google_project.current_project.id
  role    = "roles/monitoring.viewer"
  members = [
    "group:team.analytics@trustly.com",
    "group:team.businessintelligence@trustly.com",
    "group:team.tech@trustly.com",
  ]
}

resource "google_project_iam_binding" "monitoring_metric_writer" {
  project = data.google_project.current_project.id
  role    = "roles/monitoring.metricWriter"
  members = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email)
  ]
}

resource "google_project_iam_binding" "monitoring_notification_channels_editor" {
  project = data.google_project.current_project.id
  role    = "roles/monitoring.notificationChannelEditor"
  members = [
    "group:team.dataservices@trustly.com"
  ]
}

# ******************* SECRET MANAGER *********************
resource "google_project_iam_binding" "secretmanager_admin" {
  project = data.google_project.current_project.id
  role    = "roles/secretmanager.admin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_composer_worker.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email)
  ]
}

resource "google_project_iam_binding" "secretmanager_secretaccessor" {
  project = data.google_project.current_project.id
  role    = "roles/secretmanager.secretAccessor"
  members = [
    "serviceAccount:svc-application-deployment@trustly-data-services-prod.iam.gserviceaccount.com", # CI/CD for Netsuite
    format("serviceAccount:%s", data.google_app_engine_default_service_account.default.email),
  ]
}

# ******************** APP ENGINE *************************

resource "google_project_iam_binding" "appengine_admin" {
  project = data.google_project.current_project.id
  role    = "roles/appengine.appAdmin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}

resource "google_project_iam_binding" "appengine_creator" {
  project = data.google_project.current_project.id
  role    = "roles/appengine.appCreator"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}


resource "google_project_iam_binding" "appengine_svc_user" {
  project = data.google_project.current_project.id
  role    = "roles/iam.serviceAccountUser"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}

resource "google_project_iam_binding" "appengine_compute_storageadmin" {
  project = data.google_project.current_project.id
  role    = "roles/compute.storageAdmin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}


resource "google_project_iam_binding" "appengine_cloudbuild_editor" {
  project = data.google_project.current_project.id
  role    = "roles/cloudbuild.builds.editor"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}

# ******************** Cloud SQL *************************
resource "google_project_iam_binding" "cloudsql_client" {
  project = data.google_project.current_project.id
  role    = "roles/cloudsql.client"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", data.google_app_engine_default_service_account.default.email),
  ]
}

resource "google_project_iam_binding" "cloudsql_instanceUser" {
  project = data.google_project.current_project.id
  role    = "roles/cloudsql.instanceUser"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", data.google_app_engine_default_service_account.default.email),
  ]
}

# ******************** IDENTITY AWARE PROXY *************************


resource "google_project_iam_binding" "iap_admin" {
  project = data.google_project.current_project.id
  role    = "roles/iap.admin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}

resource "google_project_iam_binding" "iap_settingsAdmin" {
  project = data.google_project.current_project.id
  role    = "roles/iap.settingsAdmin"
  members = [
    "group:team.dataservices@trustly.com",
    format("serviceAccount:%s", google_service_account.svc_app_engine.email),
  ]
}

# *************************** PUB/SUB *******************************

resource "google_project_iam_binding" "pubsub_editor" {
  project = data.google_project.current_project.id
  role    = "roles/pubsub.editor"
  members = [
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email), # CI for data ingestion pipeline
  ]
}
