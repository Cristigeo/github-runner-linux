# base image
FROM debian:bullseye-slim
LABEL BaseImage="debian:bullseye-slim"
LABEL RunnerVersion=${RUNNER_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

# GitHub runner version argument, with default value
ARG RUNNER_VERSION=2.298.2

# update the base packages + add a non-sudo user
RUN apt-get update -y \
  && apt-get upgrade -y \
  && useradd -m docker

# install the packages and dependencies
RUN apt-get install -y --no-install-recommends ca-certificates curl unzip git jq

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
  && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
  && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install github actions' specific additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# add start.sh script and make it executable
ADD scripts/start.sh start.sh
RUN chmod +x start.sh

# set the user to "docker" from now on
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]