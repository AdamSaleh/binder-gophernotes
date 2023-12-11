# Gophernotes Dockerfile for Binder

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/binder-examples/minimal-dockerfile/master)

[Binder](https://mybinder.org) needs only one thing for images to work:

- to be able to launch `jupyter notebook` with jupyterlab as a specified user (passed via docker build args as NB_UID/NB_USER)

The particular notebook has gophernotes installed and has few additional libraries and tools pre-installed namely:
* https://github.com/bitfield/script
* kubectl kuttl