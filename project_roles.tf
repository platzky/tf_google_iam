locals {
  service_account_roles = toset(["roles/appengine.deployer", "roles/appengine.serviceAdmin",
    "roles/storage.objectViewer", "roles/iam.serviceAccountUser", "roles/cloudbuild.builds.editor"
  ])

  admin_roles = toset(["roles/owner", "roles/storage.objectAdmin"])
}

resource "google_project_iam_binding" "service_account_bindings" {
  for_each = local.service_account_roles
  project  = var.project_id
  role     = each.value

  members = [
    "serviceAccount:${google_service_account.default.email}"
  ]
}

resource "google_project_iam_binding" "admin_bindings" {
  for_each = local.admin_roles
  project  = var.project_id
  role     = "roles/storage.objectAdmin"

  members = [for user in var.project_admins : "user:${user}"]
}


resource "google_service_account_iam_member" "default" {
  for_each = toset(["roles/iam.workloadIdentityUser", "roles/iam.serviceAccountTokenCreator",
  "roles/iam.serviceAccountUser"])
  service_account_id = google_service_account.default.id
  role               = each.value
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/attribute.repository/${var.repo}"
}
