# Container SSH

A Debian container with SSH enabled. It a pure image that start service based on script file which can customize first-time setting up script and startup script. The scripts and runtime resources can be put into the container using Docker volume mouting. It can run as a container for development/tesing purpose without needs to build into another a Docker image.

## Environment

- `PASSWORD` The password for container's root user SSH login.
- `SETUP_SCRIPT` The path of mounted script file to run when the container is created at the first-time, maybe an environment setup script.
- `STARTUP_SCRIPT` The path of mounted script file to run every time container has started, maybe an entrypoint for the servince.

## Build

To build the Dockerfile into Docker Image, just clone the source and run:

```shell
docker build -t local/container-ssh .
```

This will build into image named `local/container-ssh`.
