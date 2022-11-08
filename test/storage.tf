module "bucket_dataflow_temp" {
  source = "../modules/bucket"


  name        = "dataflow-temp"
  gcp_project = data.google_project.current_project.id

  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}
