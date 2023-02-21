# Container Docker CLI

A container with preconfigured environment. It included SSH enabled and Docker CLI pre-installed for connect to mounted Docker daemon (/var/run/docker.sock). The setup enables sharing Docker with external remote via SSH and compatible with secondary-docker setup ([view](../../server/secdocker.sh)).

## Environment

- `PASSWORD` The password for container's root user SSH login.
- `SETUP_SCRIPT` The path of mounted script file to run when the container is created at the first-time, maybe an environment setup script.
- `STARTUP_SCRIPT` The path of mounted script file to run every time container has started, maybe an entrypoint for the servince.

## Build

To build the Dockerfile into Docker Image, just clone the source and run:

```shell
docker build -t local/container-vm .
```

This will build into image named `local/container-vm`.
