# Container DIND

A virtual machine like Ubuntu container. It included SSH enabled and Docker pre-installed for running as Docker-in-Docker using [sysbox-runc](https://github.com/nestybox/sysbox/). The setup virtualize a small VM that able to run Docker inside. Useful for testing/sandboxing containers, sharing VM with friends, or organizing workshop which required individual VM setup.

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
