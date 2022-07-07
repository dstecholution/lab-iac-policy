data "google_container_cluster" "primary" {
  name     = "opa-poc"
  location = "us-central1"
}

data "google_client_config" "current" {}

variable "helm_version" {
  default = "v2.9.1"
}

variable "project_id" {
  type    = string
  default = "labcluster"
}

variable "region" {
  description = "Google Cloud region"
  default     = "us-central1"
  type        = string
}

variable "bucket_name" {
  default = "tf-backend-bGFiLXRmLWJhY2tlbmQK"
  type    = string
}

variable "bucket_location" {
  type    = string
  default = "US"
}

variable "project_firewall" {
  type    = list(any)
  default = ["labcluster"]
}

variable "network_name" {
  type    = list(any)
  default = ["lab"]
}

variable "service_account" {
  type = map(any)
  default = {
    id   = "terraform"
    name = "terraform runner"
  }
}

variable "service_port" {
  default = "80"
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}
