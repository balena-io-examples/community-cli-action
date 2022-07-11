FROM debian:bullseye-slim

ARG BALENA_CLI_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV PATH /app/balena-cli:$PATH

WORKDIR /app

RUN apt-get update && \
  apt-get install -y \
  unzip \
  wget

RUN echo "Using Balena CLI version: v${BALENA_CLI_VERSION}"

RUN wget -q -O balena-cli.zip "https://github.com/balena-io/balena-cli/releases/download/v${BALENA_CLI_VERSION}/balena-cli-v${BALENA_CLI_VERSION}-linux-x64-standalone.zip" && \
  unzip balena-cli.zip && \
  rm balena-cli.zip

COPY entrypoint.sh .

ENTRYPOINT [ "/app/entrypoint.sh" ]
