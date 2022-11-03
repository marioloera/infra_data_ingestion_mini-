/*
    Definition of policy tags to control access in BigQuery. We use one taxonomy,
    defined in the top of this file. Each policy tag has a section of its own
    starting with the definition of the tag and then iam bindings.

    (The Data Services team has access to all data as we are
    datacatalog.categoryFineGrainedReader on the project resource.)
*/

resource "google_data_catalog_taxonomy" "basic_taxonomy" {
  provider               = google-beta
  region                 = "eu"
  display_name           = "trustly-test-basic"
  description            = "A collection of policy tags to control column level access in BigQuery"
  activated_policy_types = ["FINE_GRAINED_ACCESS_CONTROL"]
}

# ****************************************************************************
# PII
resource "google_data_catalog_policy_tag" "policy_tag_pii" {
  provider     = google-beta
  taxonomy     = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name = "pii"
  description  = "Personally Identifiable Information"
}

resource "google_data_catalog_policy_tag_iam_binding" "binding_pii" {
  provider   = google-beta
  policy_tag = google_data_catalog_policy_tag.policy_tag_pii.name
  role       = "roles/datacatalog.categoryFineGrainedReader"
  members = [
    "group:bigquery.pii@trustly.com",
    "group:team.businessintelligence@trustly.com",
  ]
}

resource "google_data_catalog_policy_tag" "policy_tag_mpi" {
  provider          = google-beta
  taxonomy          = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name      = "mpi"
  description       = "Merchant Provided Identifier"
  parent_policy_tag = google_data_catalog_policy_tag.policy_tag_pii.id
}

resource "google_data_catalog_policy_tag_iam_binding" "binding_mpi" {
  provider   = google-beta
  policy_tag = google_data_catalog_policy_tag.policy_tag_mpi.name
  role       = "roles/datacatalog.categoryFineGrainedReader"
  members = [
  ]
}

# ****************************************************************************
# Financial data
resource "google_data_catalog_policy_tag" "policy_tag_financial" {
  provider     = google-beta
  taxonomy     = google_data_catalog_taxonomy.basic_taxonomy.id
  display_name = "financial"
  description  = "Corporate financial data"
}

resource "google_data_catalog_policy_tag_iam_binding" "binding_financial" {
  provider   = google-beta
  policy_tag = google_data_catalog_policy_tag.policy_tag_financial.name
  role       = "roles/datacatalog.categoryFineGrainedReader"
  members = [
    "group:team.businesscontrol@trustly.com",
    "group:team.businessintelligence@trustly.com",
    "group:bigquery.powerusers@trustly.com",
  ]
}
