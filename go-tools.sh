# vim: ft=sh sw=2 et :

gocd() {
  local pkg="$1"

  cd "${GOPATH}/src/${pkg}"
}

gobld() {
  local pkg="$1"

  (
    set -ex
    go get "${pkg}"
    if [ -d "${GOPATH}/src/${pkg}/Godeps" ]; then
      cd "${GOPATH}/src/${pkg}"
      godep go build
      echo `pwd`
    else
      echo "${GOPATH}/bin"
    fi
  )
}

gobldcp() {
  local pkg="$1"
  local binary="$2"
  local out="$3"

  cp `gobld "$pkg"`/"$binary" "$out"
}
