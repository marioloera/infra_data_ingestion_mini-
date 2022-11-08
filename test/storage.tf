module "bucket_dataflow_temp" {
  source = "../modules/bucket"

  name = "dataflow-temp"

  object_admin = [
    format("serviceAccount:%s", google_service_account.svc_dataflow_worker.email),
    format("serviceAccount:%s", google_service_account.svc_github_action_application_deployment.email),
  ]
}
