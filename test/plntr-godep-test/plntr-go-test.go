package main

import (
	plntrdep "github.com/PlanitarInc/docker-image-dev-go/test/plntr-dep"
	"github.com/coreos/go-etcd/etcd"
)

func main() {
	_ = &etcd.Client{}
	plntrdep.PlntrDepTest()
}
