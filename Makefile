# XXX no versioning of the docker image
IMAGE_NAME=planitar/dev-go

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build:
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
ifneq (${IMAGE_TAG},)
	docker tag ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
	docker push ${IMAGE_NAME}:${IMAGE_TAG}
else
	docker push ${IMAGE_NAME}
endif

clean:
	docker rmi -f ${IMAGE_NAME} || true

test:
	docker run -d --name test-dev-go ${IMAGE_NAME} /bin/bash -lc ' \
	  set -xe; \
	  go version; \
	  test ! -e $$GOPATH/bin/plntr-go-test; \
	  go get github.com/PlanitarInc/docker-image-dev-go/test/plntr-go-test; \
	  test -e $$GOPATH/bin/plntr-go-test; \
	  diff `which plntr-go-test` $$GOPATH/bin/plntr-go-test; \
	'
	if ! docker wait test-dev-go | grep 0; then \
	  docker logs test-dev-go >&2; \
	  docker rm -f test-dev-go; \
	  false; \
	fi
	docker rm -f test-dev-go
	@# Test godep
	docker run -d --name test-dev-go ${IMAGE_NAME} /bin/bash -lc ' \
	  set -xe; \
	  PKG=github.com/PlanitarInc/docker-image-dev-go/test/plntr-godep-test; \
	  go get $$PKG; \
	  cd $$GOPATH/src/$$PKG; \
	  godep go build; \
	'
	if ! docker wait test-dev-go | grep 0; then \
	  docker logs test-dev-go >&2; \
	  docker rm -f test-dev-go; \
	  false; \
	fi
	docker rm -f test-dev-go
	@# Test go-tools
	docker run -d --name test-dev-go ${IMAGE_NAME} /bin/bash -lc ' \
	  set -xe; \
	  pkg="github.com/PlanitarInc/docker-image-dev-go/test/plntr-go-test"; \
	  bd=`gobld $$pkg`; \
	  test $$bd == $$GOPATH/bin; \
	  gobldcp $$pkg plntr-go-test /tmp; \
	  diff $$bd/plntr-go-test /tmp/plntr-go-test; \
	  pkg="github.com/PlanitarInc/docker-image-dev-go/test/plntr-godep-test"; \
	  bd=`gobld $$pkg`; \
	  test $$bd == $$GOPATH/src/$$pkg; \
	  gobldcp $$pkg plntr-godep-test /tmp; \
	  diff $$bd/plntr-godep-test /tmp/plntr-godep-test; \
	'
	if ! docker wait test-dev-go | grep 0; then \
	  docker logs test-dev-go >&2; \
	  docker rm -f test-dev-go; \
	  false; \
	fi
	docker rm -f test-dev-go
