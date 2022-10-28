# github-runner-linux

A simple, self-hosted GithubActions runner.

## Build docker image

Run the following command, optionally specifying the desired github runner version that will be installed (if ommited, will default to 2.292.2):

```
docker build --build-arg RUNNER_VERSION=2.292.2 --tag your-preffered-image-name .
```

## Start docker container

```
docker run -e GH_TOKEN='yourPatToken' -e GH_OWNER='yourOrganizationOrUserName' -e GH_REPOSITORY='yourRepoName' -d your-preffered-image-name-from-previous-step
```

You need to create a personal access token for the runner, with the minimum permission scopes "repo" and "read:org".
