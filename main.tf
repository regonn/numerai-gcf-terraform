provider "google" {
  credentials = file("./gcp-json-keyfile.json")
  project     = var.project_id
  region      = var.region
}

resource "google_cloudfunctions2_function" "ml_training_function" {
  name        = "ml-training-function"
  location = var.region
  description = "Numerai Submit"

  service_config {
    max_instance_count  = 1
    available_memory    = "32Gi"
    timeout_seconds     = 60 * 60 # 1 hour
    available_cpu = "8"
    environment_variables = {
      DISCORD_WEBHOOK_URL = var.discord_webhook_url
      NUMERAI_PUBLIC_ID = var.numerai_public_id
      NUMERAI_SECRET_KEY = var.numerai_secret_key
      NUMERAI_MODEL_ID = var.numerai_model_id
    }
  }

  build_config {
    runtime = "python310"
    entry_point = "numerai_submit" 
    source {
      storage_source {
        bucket = google_storage_bucket.ml_function_bucket.name
        object = google_storage_bucket_object.ml_function_zip.name
      }
    }
  }

  
}

resource "google_storage_bucket" "ml_function_bucket" {
  name = "ml-function-bucket-${random_id.ml_function_bucket_id.hex}"
  location = var.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "ml_function_zip" {
  name   = "ml_function.zip"
  bucket = google_storage_bucket.ml_function_bucket.name
  source = "ml_function.zip"
}

resource "random_id" "ml_function_bucket_id" {
  byte_length = 4
}

output "function_uri" {
  value = google_cloudfunctions2_function.ml_training_function.service_config[0].uri
}

resource "google_cloudfunctions2_function_iam_member" "member" {
  project = google_cloudfunctions2_function.ml_training_function.project
  location = google_cloudfunctions2_function.ml_training_function.location
  cloud_function = google_cloudfunctions2_function.ml_training_function.name
  role = "roles/viewer"
  member = "allUsers"
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloudfunctions2_function.ml_training_function.location
  service = google_cloudfunctions2_function.ml_training_function.name
  role = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}