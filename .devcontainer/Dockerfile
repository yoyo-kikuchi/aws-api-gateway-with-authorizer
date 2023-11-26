FROM ruby:3.2.2-bullseye

ARG UID=1000
ARG GID=1000

WORKDIR /workspace

RUN apt-get update \
    && apt-get -y install sudo \
    && groupadd -g $GID vscode \
    && adduser -uid $UID -gid $GID vscode \
    && usermod -aG sudo vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


