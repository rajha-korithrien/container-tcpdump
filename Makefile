IMAGE = $(shell cat IMAGE)
BASE = $(shell cat BASE)
MANIFEST_EXISTS = $(shell podman manifest exists $(IMAGE); echo $?)

.PHONY: build
build:
ifeq ($(MANIFEST_EXISTS),1)
	podman manifest create $(IMAGE)
else
	podman manifest rm $(IMAGE)
	podman manifest create $(IMAGE)
endif
	podman build --platform linux/amd64,linux/arm64 --manifest $(IMAGE) --build-arg BASE=$(BASE) .

.PHONY: push
push: build
	podman manifest push $(IMAGE)