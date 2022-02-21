# Alpine SSH

A pure Alpine container with SSH enabled. It allows any use cases based on script file which you can customize everything on it and leave it run as a container for development/tesing purpose without needs to build into another a Docker image.

## Environment

- `PASSWORD` The password for container's root user.
- `SCRIPT` The path of mounted script file to run as an entrypoint when container start.

## Build

To build the Dockerfile into Docker Image, just clone the source and run:

```shell
docker build -t local/alpine-ssh .
```

This will build into image named `local/alpine-ssh`.
