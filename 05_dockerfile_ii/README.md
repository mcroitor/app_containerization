# Additional Dockerfile Directives

- [Additional Dockerfile Directives](#additional-dockerfile-directives)
  - [Variables usage in image building](#variables-usage-in-image-building)
    - [ARG](#arg)
    - [ENV](#env)
  - [Interaction with the container](#interaction-with-the-container)
    - [EXPOSE](#expose)
    - [VOLUME](#volume)
  - [Image metadata](#image-metadata)
    - [LABEL](#label)
  - [Additional commands](#additional-commands)
    - [SHELL](#shell)
    - [ONBUILD](#onbuild)
    - [HEALTHCHECK](#healthcheck)
    - [STOPSIGNAL](#stopsignal)
  - [Bibliography](#bibliography)

In this chapter, additional `Dockerfile` directives are considered, which allow you to define variables when building an image, interact with a container, image metadata, and additional commands.

## Variables usage in image building

When building a container image, you often need to pass some parameters to the image. For example, you can have a common `Dockerfile` for several projects, where only some parameters differ. In addition, you can pass some confidential data, such as passwords, tokens, etc., to the image.

You can use variables (building arguments) in the `Dockerfile` to pass parameters when building an image. Variables can be defined using the `ARG` directive, and you can use environment variables during the image build.

### ARG

The `ARG` directive defines arguments that can be passed when building an image. Arguments can be used in the `FROM`, `RUN`, `CMD`, `LABEL`, and `MAINTAINER` commands. Arguments can be passed when building an image using the `--build-arg` flag.

```dockerfile
ARG <name>[=<default value>]
```

where `<name>` is the argument name, `<default value>` is the argument default value.

The sample of arguments usage:

```dockerfile
ARG VERSION=latest

FROM ubuntu:$VERSION
```

The arguments values can be passed when building an image:

```bash
docker build --build-arg VERSION=18.04 -t myimage .
```

### ENV

The `ENV` directive defines environment variables. Environment variables will be available during the container execution. Environment variables can be used in the `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD`, and `WORKDIR` commands.

```dockerfile
ENV <key> <value>
```

where `<key>` is the environment variable name, `<value>` is the environment variable value.

The sample of environment variables usage:

```dockerfile
FROM ubuntu:18.04
ENV MY_NAME="John Doe"

RUN echo "Hello, $MY_NAME"
```

The difference between `ARG` and `ENV` is that `ARG` is used only during the image build, and `ENV` is used during the container execution. If you need to pass information for use during the container execution, you can use the `ENV` definition through `ARG`:

```dockerfile
ARG MY_NAME="John Doe"
FROM ubuntu:18.04
ENV MY_NAME=$MY_NAME

RUN echo "Hello, $MY_NAME"
```

Environment variables can be overridden when running a container using the `-e` flag of the `docker run` command:

```bash
docker run -e MY_NAME="Jane Doe" myimage
```

## Interaction with the container

The container is an isolated entity, so to interact with external systems, you need to define some container parameters. For example, you can define ports that the container will use to interact with external systems, as well as define volumes that the container will use to store data.

### EXPOSE

The `EXPOSE` directive defines the ports that the container will use to interact with external systems. The `EXPOSE` directive has the following syntax:

```dockerfile
EXPOSE <port> [<port>...]
```

where `<port>` is the port number opened for access to the container.

The sample of `EXPOSE` usage:

```dockerfile
FROM ubuntu:18.04

EXPOSE 80
```

The ports defined by the `EXPOSE` command are available to other containers but are not available to the host. You can redirect container ports to host ports using the `-p` (or `--publish`) flag of the `docker run` command, for example:

```bash
docker run -p 80 myimage
```

In this case, the port 80 of the container will be associated with an arbitrary host port. To associate the container port with a specific host port, you need to specify the host port before the colon, for example:

```bash
docker run -p 8080:80 myimage
```

In this case, the port 80 of the container will be associated with the port 8080 of the host.

> __Note:__ The `EXPOSE` directive does not publish the port to the host. It is used as a hint for the user, which ports the container will use to interact with external systems.

### VOLUME

The `VOLUME` directive defines the volumes that the container will use to store data. The volume provides access to the host file system and saves the data written by the container after the container is finished. Usually, they are stored in the `/var/lib/docker/volumes` directory on the host, but can be redirected to other locations.

The `VOLUME` directive has the following syntax:

```dockerfile
VOLUME <path> [<path>...]
```

where `<path>` is the path to the volume that will be used by the container. This volume will be available for writing during the container execution, is located on the host file system, and after the container is finished, the data written by the container is saved.

The sample of `VOLUME` usage:

```dockerfile
FROM ubuntu:18.04

VOLUME /var/www
```

You can also define volumes during the container execution using the `-v` flag of the `docker run` command:

```bash
docker run -v /var/www myimage
```

You can also mount host folders into the container using the `-v` flag of the `docker run` command:

```bash
docker run -v /path/to/host:/path/to/container myimage
```

## Image metadata

Image metadata is information about the image creator, image description, contact information, etc. Image metadata can be used to search for images, automate the image building process, automate the image deployment process.

### LABEL

The `LABEL` directive defines image metadata (labels). The `LABEL` directive has the following syntax:

```dockerfile
LABEL <key> = <value> <key> = <value>...
```

where `<key>` is the label key, `<value>` is the label value. Metadata can be used to search for images, automate the image building process, automate the image deployment process.

The sample of `LABEL` usage:

```dockerfile
FROM ubuntu:18.04

LABEL version="1.0"

RUN echo "Hello, world"
```

You can view the image metadata using the `docker inspect` command:

```bash
docker inspect myimage
```

When defining image metadata, the following recommendations should be followed:

- authors of third-party packages should use a prefix for the key that represents the inverted domain record, for example, `com.example-vendor=ACME Incorporated`. This prefix represents a namespace;
- use key prefixes (namespaces) only with the permission of the domain owner;
- prefixes `com.docker.*`, `io.docker.*`, and `org.dockerproject.*` are reserved for internal use by Docker;
- the label key should start with a lowercase letter and end with it, should contain only lowercase letters, numbers, or `.` and `-` characters. Sequential use of special characters is not allowed;
- the `.` character separates nested namespaces. Label keys without namespaces are used in console (CLI) mode to tag Docker objects using short, human-readable strings.

## Additional commands

### SHELL

The `SHELL` directive defines the shell that will be used to execute the `RUN`, `CMD`, `ENTRYPOINT` commands. The `SHELL` directive has the following syntax:

```dockerfile
SHELL ["executable", "parameters"]
```

where `executable` is the shell executable, `parameters` are the shell parameters.

The sample of `SHELL` usage:

```dockerfile
FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

RUN echo "Hello, world"
```

In the image description, the shell can be overridden several times, and this will affect all subsequent `RUN`, `CMD`, and `ENTRYPOINT` commands until the next `SHELL` command definition:

```dockerfile
FROM microsoft/windowsservercore

# check the default shell
RUN echo default shell is %COMSPEC%

# override the shell
SHELL ["powershell", "-Command"]

# check the shell
RUN Write-Host default shell is %COMSPEC%
```

### ONBUILD

The `ONBUILD` directive defines the commands that will be executed when building an image on which a new image will be created. The `ONBUILD` directive has the following syntax:

```dockerfile
ONBUILD <command>
```

where `<command>` is the command that will be executed when building an image on which a new image will be created.

Sample of `ONBUILD` usage:

```dockerfile
FROM ubuntu:18.04

ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
```

### HEALTHCHECK

The `HEALTHCHECK` directive defines the command that will be executed to check the container status. The `HEALTHCHECK` command has the following syntax:

```dockerfile
HEALTHCHECK [OPTIONS] CMD command
```

where `OPTIONS` is the command options, `CMD` is the command that will be executed to check the container status.

You can also disable the container status check using the `HEALTHCHECK` command:

```dockerfile
HEALTHCHECK NONE
```

Properties that can be defined before `CMD`:

- `--interval=DURATION` - the interval between container status checks. By default, the interval is 30 seconds;
- `--timeout=DURATION` - the time to wait for the container status check command to complete. By default, the waiting time is 30 seconds;
- `--start-period=DURATION` - the time to wait before starting the container status check command. By default, the waiting time is 0 seconds;
- `--start-interval=DURATION` - the interval between attempts to execute the container status check command when starting. By default, the interval is 5 seconds. To use this property, you must have Docker Engine version 25.0 or higher;
- `--retries=N` - the number of attempts to execute the container status check command. By default, the number of attempts is 3.

The `CMD` command specified after `HEALTHCHECK` must return the status code:

- `0` - the container is ready to work;
- `1` - the container is working with errors;
- `2` - reserved for future use, do not use at this time.

Sample of `HEALTHCHECK` usage:

```dockerfile
FROM ubuntu:18.04

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

### STOPSIGNAL

The `STOPSIGNAL` command defines the signal that will be sent to the container to stop. The `STOPSIGNAL` command has the following syntax:

```dockerfile
STOPSIGNAL signal
```

where `signal` is the signal that will be sent to the container to stop. The signal can be specified as a number or as a signal name. The most commonly used signals are:

- `SIGTERM` - termination signal, has a numeric value of `15`, is used by default;
- `SIGKILL` - immediate termination signal, has a numeric value of `9`.
- `SIGINT` - interrupt signal, has a numeric value of `2`;
- `SIGQUIT` - termination signal, has a numeric value of `3`.

The value of the `STOPSIGNAL` command can be overridden when starting the container using the `--stop-signal` flag of the `docker run` command:

```bash
docker run --stop-signal=SIGKILL myimage
```

## Bibliography

1. [Dockerfile reference, docker.com](https://docs.docker.com/engine/reference/builder/)
2. [vsupalov, __Docker ARG vs ENV__, vsupalov.com](https://vsupalov.com/docker-arg-vs-env/)
3. [Docker object labels, docker.com](https://docs.docker.com/config/labels-custom-metadata/)
4. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
