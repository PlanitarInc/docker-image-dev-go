# vim: ft=bash sw=2 et :

gob() {
  local pkg="$1"

  (
    go get "${pkg}" && cd "${GOPATH}/src/${pkg}" && 
      { godep go build || ! test -d Godeps; }
  )
}
