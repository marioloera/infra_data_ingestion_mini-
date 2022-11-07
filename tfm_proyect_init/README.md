# Terraform Initialize Project
 This can be run locally to create the main artifacts:
 1. service account: **svc-terraform-admin**
 1. storage bucket: **terraform-infra**

So the rest of the infra can be deployed by github actions

## Apply

```
terraform apply
```

## make a link in the variables file to re-use
```
ln tfm_proyect_init/variables.tf test/variables.tf
```

## get the iam policy in json format
```
gcloud projects get-iam-policy turing-app-367309 --format json > turing-app-367309_policy.json
```

## after terraform apply
download a json key for the svc-terrafrom-admin

```
gcloud auth activate-service-account --key-file=/Users/Mario.Loera/code/gcp_keys/svc-terraform-admin@turing-app-367309.json
```

## Github key
add the conttent of the json key in a **secret.TF_ADMIN_KEY_TEST**
