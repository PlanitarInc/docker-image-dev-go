package main

import (
	plntrdep "github.com/PlanitarInc/docker-image-dev-go/test/plntr-dep"
	"github.com/lib/pq"
)

func main() {
	_ = &pq.Error{}
	plntrdep.PlntrDepTest()
}
