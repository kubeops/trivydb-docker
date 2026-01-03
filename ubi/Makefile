SHELL=/bin/bash -o pipefail

REGISTRY   ?= ghcr.io/appscode
BIN        ?= trivydb
IMAGE      := $(REGISTRY)/$(BIN)
TAG        ?= $(shell git describe --exact-match --abbrev=0 2>/dev/null || echo "")-ubi

DOCKER_PLATFORMS := linux/amd64,linux/arm64

.PHONY: release
release:
	@echo "container: $(IMAGE):$(TAG)"
	@docker buildx create --name container --driver=docker-container || true
	# ref: https://superuser.com/a/842705
	tar -czh . | docker build --builder container --platform $(DOCKER_PLATFORMS) --build-arg TAG=$(TAG) --push -t $(IMAGE):$(TAG) -f Dockerfile -
	@echo

.PHONY: container
container:
	@echo "container: $(IMAGE):$(TAG)"
	@docker buildx create --name container --driver=docker-container || true
	# ref: https://superuser.com/a/842705
	tar -czh . | docker build --builder container --platform $(DOCKER_PLATFORMS) --build-arg TAG=$(TAG) -t $(IMAGE):$(TAG) -f Dockerfile -
	@echo

.PHONY: fmt
fmt:
	@find ./.. -path ./vendor -prune -o -name '*.sh' -exec shfmt -l -w -ci -i 4 {} \;

.PHONY: verify
verify: fmt
	@if !(git diff --exit-code HEAD); then \
		echo "files are out of date, run make fmt"; exit 1; \
	fi

.PHONY: ci
ci: verify

.PHONY: docker-certify-redhat
docker-certify-redhat:
	@preflight check container $(IMAGE):$(TAG) \
		--submit \
		--certification-component-id=6957d24a8da5b1298784205e
