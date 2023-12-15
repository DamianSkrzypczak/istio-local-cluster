FROM debian:bullseye-slim@sha256:9bec46ecd98ce4bf8305840b021dda9b3e1f8494a0768c407e2b233180fa1466 as os-base
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee /etc/apt/apt.conf.d/keep-cache


FROM golang:1.21.3-bullseye@sha256:26c7537d6ac3827eb4638034d16edc64de57bb011c8cc8fe301ac13a6568f6f4 as golang-base
