# base image
FROM debian:bullseye-slim
LABEL BaseImage="debian:bullseye-slim"
LABEL RunnerVersion=${RUNNER_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# update the base packages
RUN apt-get update -y \
  && apt-get upgrade -y 

# install the packages and dependencies
RUN apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release unzip git jq sudo

# Docker client only
RUN  mkdir -p /etc/apt/keyrings \ 
  && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update -y \
  && apt-get install -y docker-ce-cli docker-compose-plugin

# create a user (and the docker group)
ARG DOCKER_GID=1001
RUN groupadd -g ${DOCKER_GID} docker && \
  useradd -m ghrunner && \
  usermod -a -G docker ghrunner

# GitHub runner version/platform/architecture arguments, with default values
ARG RUNNER_VERSION=2.308.0
ARG RUNNER_PLATFORM=linux
ARG RUNNER_ARCH=x64

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/ghrunner && mkdir actions-runner && cd actions-runner \
  && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-${RUNNER_PLATFORM}-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# install github actions' specific additional dependencies
RUN chown -R ghrunner ~ghrunner && /home/ghrunner/actions-runner/bin/installdependencies.sh

# add start.sh script and make it executable
ADD scripts/start.sh start.sh
RUN chmod +x start.sh

# set the user to "ghrunner" from now on
ENTRYPOINT chgrp docker /var/run/docker.sock && chmod 0775 /var/run/docker.sock && runuser -u ghrunner ./start.sh
