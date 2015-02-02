FROM planitar/dev-base

RUN sudo apt-get install -y golang && sudo apt-get clean

ENV GOPATH=${HOME}/go-dev
ENV PATH=${PATH}:${GOPATH}/bin

RUN go get github.com/tools/godep
