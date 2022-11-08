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
source /usr/local/bin/google-cloud-sdk/path.zsh.inc

PROJECT_ID=turing-app-367309
POLICY_FILE="${PROJECT_ID}_policy.json"
gcloud projects get-iam-policy $PROJECT_ID --format json > $POLICY_FILE
```

## after terraform apply
download a json key for the svc-terrafrom-admin

```
source /usr/local/bin/google-cloud-sdk/path.zsh.inc

PROJECT_ID=pa-cons-swe-de-2022-mll02
SVC_NAME=svc-terraform-admin
KEYS_DIR=/Users/Mario.Loera/code/gcp_keys

KEY_FILE="${KEYS_DIR}/${SVC_NAME}_${PROJECT_ID}.json"
SVC_FULL_NAME="${SVC_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo KEY_FILE $KEY_FILE
echo SVC_FULL_NAME $SVC_FULL_NAME

gcloud iam service-accounts keys create $KEY_FILE --iam-account=$SVC_FULL_NAME

gcloud auth activate-service-account --key-file=$KEY_FILE

gcloud auth list

```

## Github key
add the conttent of the json key in a **secret.TF_ADMIN_KEY_TEST**
