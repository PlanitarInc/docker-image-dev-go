# XXX no versioning of the docker image

.PHONY: build push clean test

build:
	docker build -t planitar/dev-go .

push:
	docker push planitar/dev-go

clean:
	docker rmi -f planitar/dev-go || true

test:
	docker run -d --name test-dev-go planitar/dev-go /bin/bash -lc ' \
	  set -xe; \
	  go version || exit 1; \
	  test ! -e $$GOPATH/bin/plntr-go-test || exit 1; \
	  go get github.com/PlanitarInc/docker-image-dev-go/test/plntr-go-test || exit 1; \
	  test -e $$GOPATH/bin/plntr-go-test || exit 1; \
	  diff `which plntr-go-test` $$GOPATH/bin/plntr-go-test || exit 1; \
	'
	if ! docker wait test-dev-go | grep 0; then \
	  docker logs test-dev-go >&2; \
	  docker rm -f test-dev-go; \
	  false; \
	fi
	docker rm -f test-dev-go
