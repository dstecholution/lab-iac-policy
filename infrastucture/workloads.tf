//letsencrypt+traefik
resource "helm_release" "proxy" {
  name       = "traefik"
  namespace  = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.24.0"
}

//vault
resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "hashicorp/vault"
  namespace  = "vault"
  version    = "0.20.1"

  set {
    name  = "ui.enabled"
    value = "true"
  }

  set {
    name  = "ui.ServiceType"
    value = "LoadBalancer"
  }

  set {
    name  = "csi.enabled"
    value = true
  }

  set {
    name  = "server.ha.enabled"
    value = true
  }

  set {
    name  = "server.ha.replicas"
    value = 5
  }

}

// gitlab
resource "helm_release" "gitlab" {
  namespace  = "default"
  name       = "gitlab"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab"
  version    = "v6.1.2"

  set {
    name  = "global.hosts.domain"
    value = "example.com"
  }

  set {
    name  = "certmanager-issuer.email"
    value = "dwight.spencer@techolution.com"
  }

  set {
    name  = "postgresql.image.tag"
    value = "13.6.0"
  }

  set {
    name  = "global.edition"
    value = "ce"
  }
}

// gitlab runner
resource "helm_release" "gitlab_runner" {
  namespace  = "cicd"
  name       = "gitlab-runner"
  repository = "https://charts.gitlab.io/"
  chart      = "gitlab-runner"
  version    = "v6.1.2"
}

// gitlab runner
//resource "helm_release" "example" {
//  namespace  = "cicd"
//  name       = "example"
//  repository = "https://haked.me"
//  chart      = "gitlab-runner"
//  version    = "v6.1.2"
//}
