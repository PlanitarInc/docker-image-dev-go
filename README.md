[[This]] repository contains directives to build the planitar `go` dev image,
based on [base dev image](https://github.com/korya/docker-image-dev-base).

The image has installed `golang`, `$GOPATH` is defined to be `/home/planitar/go-dev`.

# Instructions

Build:

```shell
make build
```

Push new image to registry:

```shell
make push
```

Clean:

```shell
make clean
```

# Usage example

Build a go binary, and copy it to a local dir:

```shell
mkdir -p out
docker run -v `pwd`/out:/out planitar/dev-go /bin/bash -lc \
    'go get "github.com/skynetservices/skydns" && cp $GOPATH/bin/skydns /out'
./out/skydns -addr 127.0.0.1:1053
```
