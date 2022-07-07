package terraform.analysis

import input as tfplan

###
# helpers
#

# list of all resources of a given type
instance_names[resource_type] = all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        tfplan[name] = _
        startswith(name, resource_type)
    ]
}

# number of deletions of resources of a given type
num_deletes[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := instance_names[resource_type]
    deletions := [name | name := all[_]; tfplan[name]["destroy"] == true]
    num := count(deletions)
}

# number of creations of resources of a given type
num_creates[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := instance_names[resource_type]
    creates := [name | all[_] = name; tfplan[name]["id"] == ""]
    num := count(creates)
}

# number of modifications to resources of a given type
num_modifies[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := instance_names[resource_type]
    modifies := [name | name := all[_]; obj := tfplan[name]; obj["destroy"] == false; not obj["id"]]
    num := count(modifies)
}


###
# Start here
#

# acceptable score for automated authorization
blast_radius = 30

# acceptable terraform version
terraform_version = "1.1.9"

# weights assigned for each operation on each resource-type
weights = {
        "goolge_container_cluster": {"delete": 100, "create": 10, "modify": 1},
        "google_container_node_pool": {"delete": 100, "create": 10, "modify":1},
        "google_compute_network": {"delete": 100, "create": 10, "modify": 1},
        "google_compute_subnetwork": {"delete": 100, "create": 10, "modify": 1},
        "google_secret_manager_secret": {"delete": 30, "create": 10, "modify": 1},
        "google_secret_manager_secret_version": {"delete": 30, "create": 10, "modify":1},
        "google_service_account": {"delete": 30, "create":30, "modify": 1},
        "google_storage_bucket": {"delete": 10, "create": 10, "modify": 50},
        "helm_release": {"delete": 50, "create": 1, "modify": 10 }
}

# Resource types to consider for authorization
resource_types = {
    "google_compute_network",
    "google_compute_subnetwork",
    "google_container_cluster",
    "google_container_node_pool",
    "google_secret_manager_secret",
    "google_secret_manager_secret_version",
    "google_service_account",
    "google_storage_bucket",
    "google_organization_iam_policy",
    "helm_release"
}

# whitelist of helm charts
trusted_charts = [
    "https://helm.traefik.io/traefik",
    "https://helm.releases.hashicorp.com",
    "https://charts.gitlab.io/"
]

# Compute the score for a Terraform plan as the weighted sum of deletions, creations, modifications
score = s {
    all := [ x |
            some resource_type
            crud := weights[resource_type];
            del := crud["delete"] * num_deletes[resource_type];
            new := crud["create"] * num_creates[resource_type];
            mod := crud["modify"] * num_modifies[resource_type];
            x := del + new + mod
    ]
    s := sum(all)
}

# Check whether there is any change to IAM
default touches_iam = false
touches_iam {
    all := instance_names["google_organization_iam_policy"]
    count(all) > 0
}

# Check charts are in trusted zone
default whitelisted_charts = false
whitelisted_charts {
    all := instance_names["helm_release"]
    charts := [repo | repo := all[_].change.after.repository; trusted_charts[_] != repo ]
    count(charts) > 0
}

###
# Exports for eval
#

# Default policy
default authz = false
authz {
    score < blast_radius
    not touches_iam
    tfplan.terraform_version == terraform_version
    count(violation) == 0
}

violation["Too many changes discovered"] {
    score > blast_radius
}

violation["Unsupported terraform version used"] {
    tfplan.terraform_version != terraform_version
}

violation["Changes planned touch Cloud IAM"] {
    touches_iam
}

violation["Untrusted helm repo used"] {
    whitelisted_charts
}
