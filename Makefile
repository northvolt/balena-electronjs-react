# raw version string for github.com/northvolt/version
GIT_VERSION := $(shell git describe)
GIT_COMMIT  := $(shell git rev-parse HEAD)
GIT_CLEAN   := $(shell [ -z "git status --porcelain" ] && echo true || echo false)
BUILD_DATE  := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
V := git_version:$(GIT_VERSION),git_commit:$(GIT_COMMIT),git_clean:$(GIT_CLEAN),build_date:$(BUILD_DATE)


DOCKER_IMAGE := gcr.io/northvolt-shared/balena-electronjs-react
DOCKER_TAG   := latest
ifneq ($(GIT_VERSION),)
	DOCKER_TAG = $(GIT_VERSION)
endif

export CGO_ENABLED=0

.PHONY: build

docker:
	docker build --build-arg version=$(V) --tag $(DOCKER_IMAGE):$(DOCKER_TAG) -f Dockerfile .

docker-push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

clean:
	rm -rf build
