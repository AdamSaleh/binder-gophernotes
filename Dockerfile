#FROM quay.io/fedora/fedora:38
FROM quay.io/devtools_gitops/test_image:v1.11.0 
#RUN curl -o go1.21.5.linux-amd64.tar.gz  https://dl.google.com/go/go1.21.5.linux-amd64.tar.gz
#RUN tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
#ENV PATH $PATH:/usr/local/go/bin
RUN pip install jupyter
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
RUN curl -L https://github.com/kudobuilder/kuttl/releases/download/v0.15.0/kubectl-kuttl_0.15.0_linux_x86_64 -o /usr/local/bin/kubectl-kuttl
RUN curl -L https://github.com/redhat-developer/kam/releases/download/v0.0.50/kam_linux_amd64 -o /usr/local/bin/kam

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}


# Install Jupyter and gophernotes.
RUN mkdir -p /usr/local/go/src/github.com/gopherdata/gophernotes/
RUN git clone https://github.com/gopherdata/gophernotes  /usr/local/go/src/github.com/gopherdata/gophernotes/

RUN cd /usr/local/go/src/github.com/gopherdata/gophernotes \
    && export GOPATH=/usr/local/go \
    && export GO111MODULE=on \
    && go install . \
    && cp /usr/local/go/bin/gophernotes /usr/local/bin/ \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r ./kernel/* ~/.local/share/jupyter/kernels/gophernotes \
    && cd  /usr/local/go/src/github.com/gopherdata/gophernotes/ \
    ## get the relevant Go packages
    && go get github.com/bitfield/script \
    && go get go-hep.org/x/hep/csvutil/... \
    && go get github.com/patrickmn/go-cache \
    && go get github.com/pkg/errors    

RUN cd /usr/local/go/src/github.com/gopherdata/gophernotes \
    && export GOPATH=/go \
    && export GO111MODULE=on \
    && cd  /usr/local/go/src/github.com/gopherdata/gophernotes/ \
    ## get the relevant Go packages
    && go get github.com/andygrunwald/go-jira \
    && go get github.com/FreeLeh/GoFreeDB
RUN chmod +x /usr/local/bin/*
RUN chown -R ${NB_USER}:${NB_USER} ${HOME}
RUN chown -R ${NB_USER}:${NB_USER} /usr/local/go
# Set GOPATH.
ENV GOPATH /usr/local/go

USER ${USER}
