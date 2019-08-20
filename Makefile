VERSION := $(shell git describe)

DOCKER_IMAGE := 112243728910.dkr.ecr.eu-west-1.amazonaws.com/automation/spider/hmi

docker:
	docker build --build-arg version=$(VERSION) --tag $(DOCKER_IMAGE):$(VERSION) -f Dockerfile .

docker-push:
	eval $$(aws ecr get-login --region eu-west-1 --no-include-email --registry-ids 112243728910) && docker push $(DOCKER_IMAGE):$(VERSION)

clean:
	rm -rf build
