resource "google_secret_manager_secret" "secret-source-token" {
  secret_id = "secret-source-token"

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "secret-source-token-1" {
  secret      = google_secret_manager_secret.secret-source-token.id
  secret_data = "MTY1NzA4Njk4OQo="
}
resource "google_secret_manager_secret" "secret-relay-token" {
  secret_id = "secret-relay-token"

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "secret-relay-token-1" {
  secret      = google_secret_manager_secret.secret-relay-token.id
  secret_data = "MTY1NzA4NzAxNQo="
}
resource "google_secret_manager_secret" "secrets-admin-user" {
  secret_id = "secrets-admin-user"

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "secrets-admin-user-1" {
  secret      = google_secret_manager_secret.secrets-admin-user.id
  secret_data = "admin_labs"
}
resource "google_secret_manager_secret" "secret-admin-token" {
  secret_id = "secret-admin-token"

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "secret-admin-token-1" {
  secret      = google_secret_manager_secret.secret-admin-token.id
  secret_data = "MTY1NzA4Njk0Ngo="
}
