ASSET		:= terraform.tfplan.json
OPA_FLAGS	:= --format pretty --data ../policy/ --input $(ASSET)
OPA_FLAGS	+= --explain=notes
PLANFILE	:= terraform.tfplan
OUTPUT		:= ./.terraform ./.terraform.lock.hcl ./terraform.tfplan.json ./terraform.tfplan

.PHONY: all distclean test plan benchmark cost drift authorize deploy
all: plan authorize

distclean:
	@rm -rf $(OUTPUT)

test: $(ASSET) benchmark cost
	terraform fmt -recursive -check -diff
	terraform validate

terraform.tfstate plan:
	terraform init -upgrade
	terraform plan -out=$(PLANFILE)

$(ASSET): terraform.tfstate
	terraform show -json $(PLANFILE) 2>&1 > ${ASSET}

benchmark: $(ASSET)
	snyk iac test $(ASSET)

cost: $(ASSET)
	infracost breakdown $(ASSET)

drift:
	driftctl scan --from tfstate://terraform.tfstate

authorize: $(ASSET)
	opa eval $(OPA_FLAGS) 'authorized = data.terraform.analysis.authz; violations = data.terraform.analysis.violation';

deploy: authorize terraform.tfstate
	terraform apply $(PLANFILE)
