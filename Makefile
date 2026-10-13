# Deploy and test one example on LocalStack, for example:
#   make install deploy test EXAMPLE=s3-static-website
EXAMPLE ?=
STACK ?= localstack

# Keep Pulumi state on disk and skip pulumilocal's prompt to overwrite the stack config
export PULUMI_BACKEND_URL ?= file://$(CURDIR)/.pulumi-state
export PULUMI_CONFIG_PASSPHRASE ?= localstack
export NON_INTERACTIVE ?= 1
export AWS_REGION ?= us-east-1

EXAMPLES := $(patsubst %/Pulumi.yaml,%,$(wildcard */Pulumi.yaml))

usage:
	@echo "Usage: make install|deploy|test|destroy EXAMPLE=<example>"
	@echo "Examples: $(EXAMPLES)"

check:
	@test -n "$(EXAMPLE)" -a -f "$(EXAMPLE)/Pulumi.yaml" || { echo "Set EXAMPLE to one of: $(EXAMPLES)"; exit 1; }

install: check
	cd $(EXAMPLE) && pulumi install

deploy: check
	mkdir -p .pulumi-state
	cd $(EXAMPLE) && pulumi stack select --create $(STACK)
	cd $(EXAMPLE) && pulumi config set aws:region $(AWS_REGION)
	cd $(EXAMPLE) && pulumilocal up --yes --skip-preview

test: check
	cd $(EXAMPLE) && STACK=$(STACK) ./test.sh

destroy: check
	cd $(EXAMPLE) && pulumilocal destroy --yes --skip-preview
	cd $(EXAMPLE) && pulumi stack rm --yes --preserve-config $(STACK)

.PHONY: usage check install deploy test destroy
