FROM planitar/dev-base

RUN sudo apt-get install -y golang && sudo apt-get clean

ENV GOPATH=${HOME}/go-dev
ENV PATH=${PATH}:${GOPATH}/bin

ADD go-tools.sh ${HOME}/.go-tools.sh

RUN go get github.com/tools/godep && \
    echo '. ${HOME}/.go-tools.sh' >> ${HOME}/.profile
