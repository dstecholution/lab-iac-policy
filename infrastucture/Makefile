ASSET		:= terraform.tfplan.json
OPA_FLAGS	:= --format pretty --data ../policy/ --input $(ASSET)
OPA_FLAGS	+= --explain=notes

all: plan authorize

test: $(ASSET) benchmark cost
	terraform fmt -recursive -check -diff
	terraform validate

terraform.tfstate plan:
	terraform init -upgrade
	terraform plan

$(ASSET): terraform.tfstate
	terraform show -json 2>&1 > ${ASSET}

benchmark: $(ASSET)
	snyk iac test $(ASSET)

cost: $(ASSET)
	infracost breakdown $(ASSET)

authorize: $(ASSET)
	opa eval $(OPA_FLAGS) 'authorized = data.terraform.analysis.authz; violations = data.terraform.analysis.violation';

deploy: authorize terraform.tfstate
	terraform apply
