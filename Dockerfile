FROM planitar/dev-base

ENV GO_PACKAGE go1.6.3.linux-amd64

USER root
RUN mkdir /tmp/go-install && cd /tmp/go-install && \
    wget -nv https://storage.googleapis.com/golang/${GO_PACKAGE}.tar.gz && \
    tar xzf ${GO_PACKAGE}.tar.gz && \
    cp ./go/bin/go /usr/bin && \
    cp ./go/bin/gofmt /usr/bin && \
    cp -r ./go /usr/lib/go && \
    chown -R planitar:root /usr/lib/go/ && \
    cd /tmp && rm -rf ./go-install
USER planitar

ENV GOROOT=/usr/lib/go
ENV GOPATH=${HOME}/go-dev
ENV PATH=${PATH}:${GOPATH}/bin

ADD go-tools.sh ${HOME}/.go-tools.sh

RUN go get github.com/tools/godep && \
    echo '. ${HOME}/.go-tools.sh' >> ${HOME}/.profile
