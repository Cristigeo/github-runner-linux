# github-runner-linux

A simple, self-hosted Github Actions runner, as a Docker container.

## Build docker image

Run the following command, optionally specifying the desired github runner version / platform / architecture that will be installed (if ommited, will default to 2.308.0 / linux / x64):

```
docker build --build-arg RUNNER_VERSION=2.308.0 --build-arg RUNNER_PLATFORM=osx --build-arg RUNNER_ARCH=arm64 --tag my-gh-actions-runner-image .
```

## Start docker container

```
docker run -e GH_TOKEN='myPatToken' -e GH_OWNER='myOrganizationOrUserName' -e GH_REPOSITORY='myRepoName' -d my-gh-actions-runner-image
```

You need to create a personal access token for the runner, with the minimum permission scopes "repo" and "read:org".
