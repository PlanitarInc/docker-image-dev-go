FROM planitar/dev-base

RUN sudo apt-get install -y golang && sudo apt-get clean

RUN echo 'export GOPATH="${HOME}/go-dev"' >> ${HOME}/.profile && \
    echo 'export PATH="${PATH}:${GOPATH}/bin"' >> ${HOME}/.profile
