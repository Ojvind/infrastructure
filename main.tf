# locals {
  # project_id              = google_project.this.project_id
  # region                  = "europe-north1"
  # service_account_email   = "gcf-sa@circular-hybrid-999555-funas.iam.gserviceaccount.com"
  # service_account_roles   = [
    # "roles/datastore.owner",
    # "roles/logging.configWriter",
    # "roles/logging.logWriter",
    # "roles/serviceusage.serviceUsageAdmin",
    # # "roles/storage.admin",
    # # "roles/cloudkms.admin",
    # "roles/iam.serviceAccountAdmin",
    # "roles/compute.viewer",
    # "roles/iam.serviceAccountKeyAdmin",
    # "roles/iam.workloadIdentityPoolAdmin",
    # "roles/iam.roleAdmin",
    # "roles/pubsub.admin",
    # "roles/cloudfunctions.admin",
    # "roles/iam.serviceAccountUser",
    # "roles/cloudbuild.builds.builder",
    # "roles/pubsub.publisher",
    # "roles/eventarc.eventReceiver",
    # "roles/run.invoker"
#   ]
# }

# resource "google_project_iam_member" "runner-sa-roles" {
#   for_each = toset(local.service_account_roles)
 
#   role    = each.value
#   member  = "serviceAccount:${local.service_account_email}"
#   project = local.project_id
# }

# locals {
#   build_account_email   = "1036008638159-compute@developer.gserviceaccount.com"
#   build_account_roles   = [
#     "roles/logging.logWriter",
#     "roles/cloudbuild.builds.builder"
#   ]
# }

# resource "google_project_iam_member" "runner-build-roles" {
#   for_each = toset(local.build_account_roles)
 
#   role    = each.value
#   member  = "serviceAccount:${local.build_account_email}"
#   project = local.project_id
# }

# Google storage bucket that contains the code for the cloud function
# resource "google_storage_bucket" "cloud_function_source_bucket" {
#   name                       = "cloud-function-alert-${local.project_id}"
#   location                   = local.region
#   force_destroy              = true
#   uniform_bucket_level_access = true
# }
 
# # The input bucket that will trigger the cloud function 
# resource "google_storage_bucket" "input_bucket" {
#   name                       = "cloud-alert-input-${local.project_id}"
#   location                   = local.region
#   uniform_bucket_level_access = true
# }

# # Zip up the source code
# data "archive_file" "source" {
#   type        = "zip"
#   output_path = "${path.module}/src/alert_source.zip"
#   source_dir  = "src/"
# }

# # Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
# resource "google_storage_bucket_object" "zip" {
#   source       = data.archive_file.source.output_path
#   content_type = "application/zip"
#   name         = "alert_source.zip"
#   bucket       = google_storage_bucket.cloud_function_source_bucket.name
#   depends_on = [
#     google_storage_bucket.cloud_function_source_bucket,
#     data.archive_file.source
#   ]
# }
 
# google auto creates some service accounts for the event triggers with 
# cloud storage, here we get them and give them the pubsub role so that they
# can trigger the cloud function event
# data "google_storage_project_service_account" "gcs_account" {
#   project = local.project_id
# }

# Grant pubsub.publisher permission to storage project service account
# resource "google_project_iam_binding" "google_storage_project_service_account_is_pubsub_publisher" {
#   project = local.project_id
#   role    = "roles/pubsub.publisher"
#   members = [
#     "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
#   ]
# }

# resource "google_cloudfunctions2_function" "function" {
#   name        = "cloud-function-trigger-using-terraform-gen-2"
#   location    = local.region
#   project     = local.project_id
#   description = "Cloud function gen2 trigger using terraform"
 
#   build_config {
#     runtime     = "nodejs16"
#     entry_point = "fileStorageAlert"
 
#     source {
#       storage_source {
#         bucket = google_storage_bucket.cloud_function_source_bucket.name
#         object = google_storage_bucket_object.zip.name
#       }
#     }
#   }
 
#   service_config {
#     max_instance_count              = 1
#     min_instance_count              = 0
#     available_memory                = "256M"
#     timeout_seconds                 = 60
#     environment_variables           = {
#       SERVICE_CONFIG_TEST = "config_test"
#     }
#     ingress_settings                = "ALLOW_INTERNAL_ONLY"
#     all_traffic_on_latest_revision = true
#     service_account_email = local.service_account_email
#   }
 
#   event_trigger {
#     trigger_region = local.region
#     event_type     = "google.cloud.storage.object.v1.finalized"
#     retry_policy   = "RETRY_POLICY_DO_NOT_RETRY"
#     service_account_email = local.service_account_email
#     event_filters {
#       attribute = "bucket"
#       value     = google_storage_bucket.input_bucket.name
#     }
#   }
 
#   depends_on = [
#     google_storage_bucket.cloud_function_source_bucket,
#     google_storage_bucket_object.zip,
#     google_project_iam_binding.google_storage_project_service_account_is_pubsub_publisher
#   ]
# }
