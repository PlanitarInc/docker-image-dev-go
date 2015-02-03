# XXX no versioning of the docker image
IMAGE_NAME=planitar/dev-go

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build:
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
	docker push ${IMAGE_NAME}

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
	  gob github.com/PlanitarInc/docker-image-dev-go/test/plntr-go-test; \
	  gob github.com/PlanitarInc/docker-image-dev-go/test/plntr-godep-test; \
	'
	if ! docker wait test-dev-go | grep 0; then \
	  docker logs test-dev-go >&2; \
	  docker rm -f test-dev-go; \
	  false; \
	fi
	docker rm -f test-dev-go
