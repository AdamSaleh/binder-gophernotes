FROM quay.io/fedora/fedora:38
RUN dnf install -y python3-jupyter-notebook golang-bin git

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --uid ${NB_UID} \
    ${NB_USER}
RUN chmod -R 777 /
WORKDIR ${HOME}
USER ${USER}

# Install Jupyter and gophernotes.
RUN mkdir -p /go/src/github.com/gopherdata/gophernotes/
RUN git clone https://github.com/gopherdata/gophernotes  /go/src/github.com/gopherdata/gophernotes/

RUN cd /go/src/github.com/gopherdata/gophernotes \
    && export GOPATH=/go \
    && export GO111MODULE=on \
    && go install . \
    && cp /go/bin/gophernotes /usr/local/bin/ \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r ./kernel/* ~/.local/share/jupyter/kernels/gophernotes \
    && cd  /go/src/github.com/gopherdata/gophernotes/ \
    ## get the relevant Go packages
    && go get github.com/bitfield/script \
    && go get go-hep.org/x/hep/csvutil/... \
    && go get github.com/patrickmn/go-cache \
    && go get github.com/pkg/errors    
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
RUN curl -L https://github.com/kudobuilder/kuttl/releases/download/v0.15.0/kubectl-kuttl_0.15.0_linux_x86_64 -o /usr/local/bin/kubectl-kuttl
RUN curl -L https://github.com/redhat-developer/kam/releases/download/v0.0.50/kam_linux_amd64 -o /usr/local/bin/kam

RUN cd /go/src/github.com/gopherdata/gophernotes \
    && export GOPATH=/go \
    && export GO111MODULE=on \
    && cd  /go/src/github.com/gopherdata/gophernotes/ \
    ## get the relevant Go packages
    && go get github.com/andygrunwald/go-jira \
    && go get github.com/FreeLeh/GoFreeDB
RUN chmod +x /usr/local/bin/*

# Set GOPATH.
ENV GOPATH /go
