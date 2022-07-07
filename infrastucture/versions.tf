terraform {
  #  backend "gcs" {
  #    bucket = "tf-backend-bGFiLXRmLWJhY2tlbmQK"
  #    prefix = "terraform/master/state"
  #  }

  backend "local" {
    path = "../terraform.tfstate"
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 4.27.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.7.0"
    }

  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "helm" {
#  kubernetes {
#    host                   = data.google_container_cluster.primary.endpoint
#    token                  = data.google_client_config.current.access_token
#    client_certificate     = base64decode(data.google_container_cluster.primary.master_auth.0.client_certificate)
#    client_key             = base64decode(data.google_container_cluster.primary.master_auth.0.client_key)
#    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
#  }
}

provider "vault" {}

provider "kubernetes" {
  load_config_file = "false"

  host     = google_container_cluster.primary.endpoint
  username = var.gke_username
  password = var.gke_password

  client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
  client_key             = google_container_cluster.primary.master_auth.0.client_key
  cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate

}
