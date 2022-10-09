terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
  }
}

resource "google_iam_workload_identity_pool" "default" {
  provider                  = google-beta
  project                   = var.project_id
  workload_identity_pool_id = "default"
  disabled                  = false
}

resource "google_iam_workload_identity_pool_provider" "default" {
  provider                           = google-beta
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.default.workload_identity_pool_id
  workload_identity_pool_provider_id = "default"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "default" {
  account_id   = var.service_account.account_id
  display_name = var.service_account.display_name
  project      = var.project_id
}
