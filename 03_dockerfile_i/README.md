# Dockerfile syntax

- [Dockerfile syntax](#dockerfile-syntax)
  - [Docker](#docker)
  - [Dockerfile](#dockerfile)
  - [Dockerfile instructions](#dockerfile-instructions)
    - [FROM](#from)
    - [COPY](#copy)
    - [ADD](#add)
    - [RUN](#run)
    - [CMD](#cmd)
    - [ENTRYPOINT](#entrypoint)
    - [WORKDIR](#workdir)
    - [USER](#user)
  - [Bibliography](#bibliography)

## Docker

**Docker** is a software for automating the deployment and management of applications in an operating system-level virtualization environment. Docker allows you to "package" an application with all its environment and dependencies into a container that can be moved to any Linux system with `cgroups` support in the kernel, and also provides an environment for managing containers.

For working with Docker in Unix / Linux OS, you need to install [Docker Engine](https://docs.docker.com/engine/install).

For working with Docker in Windows OS, you need to install [Docker Desktop](https://www.docker.com/products/docker-desktop).

## Dockerfile

Docker images are created based on the `Dockerfile`. This file describes what commands need to be executed to build an image. Executing each command creates an intermediate image, called a *layer*, which is used to create the next image. Creating intermediate images allows you to reuse them when building other images, which significantly reduces the time to build an image.

Example of a `Dockerfile`:


```dockerfile
# based on ubuntu:18.04 image
FROM ubuntu:18.04

# update package list and packages themselves
RUN apt-get update && apt-get -y upgrade
# install nginx package
RUN apt-get install -y nginx
# create index.html
RUN echo "Hello, world!" > /var/www/html/index.html

# start nginx
CMD ["nginx", "-g", "daemon off;"]
```

After the image is built, it can be run and get a container.

## Dockerfile instructions

The following table contains a list of commands that can be used in the `Dockerfile`.

| Command | Description |
| --- | --- |
| `FROM` | Specifies the base image on which the new image will be created. |
| `COPY` | Copies files and directories from the build context to the image file system. |
| `ADD` | Copies files and directories from the build context to the image file system. It also allows you to download files from the Internet and unpack archives. |
| `RUN` | Executes a command in the container. The result of the command execution is saved in the image. |
| `CMD` | Specifies the command that will be executed when the container is started. |
| `ENTRYPOINT` | Specifies the command that will be executed when the container is started. The command specified in `ENTRYPOINT` cannot be overridden when the container is started. |
| `WORKDIR` | Specifies the working directory for `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands. |
| `USER` | Specifies the user on behalf of which the `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands will be executed. |
| `ENV` | Specifies environment variables. |
| `ARG` | Specifies arguments that can be passed when building an image. |
| `EXPOSE` | Opens ports for interacting with the container. |
| `VOLUME` | Creates mount points for interacting with the container. |
| `SHELL` | Specifies the shell that will be used to execute `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands. |
| `MAINTAINER` | Specifies the name and email address of the image author. |
| `LABEL` | Specifies image metadata. |
| `ONBUILD` | Specifies commands that will be executed when an image is built on the basis of which a new image will be created. |
| `HEALTHCHECK` | Specifies a command that will be executed to check the container's status. |
| `STOPSIGNAL` | Specifies the signal that will be sent to the container to stop. |

In the `Dockerfile`, you can also use comments that start with the `#` character.

### FROM

Each new image is created based on the base image. The base image is specified in the `FROM` command. For example, the following command will create an image based on the base image `ubuntu:18.04`.

```dockerfile
FROM ubuntu:18.04
```

The base image in this case will include the minimum set of files needed to run the Ubuntu 18.04 operating system.

The base image must be specified on the first line of the `Dockerfile`. If the base image is not specified, the `scratch` base image will be used, which does not contain any files, which is equivalent to the `FROM scratch` record.

For the base image, you can specify a tag that corresponds to a specific version of the base image. A **tag** is a special text label that indicates, for example, the version of the image or its characteristics. If the tag is not specified, the `latest` tag will be used, which always points to the latest built image.

### COPY

The `COPY` command copies files and directories from the build context to the image file system. The **build context** is the directory in which the `Dockerfile` file is located. The `COPY` command has the following syntax:

```dockerfile
СOPY <src> <dest>
```

where `<src>` is the path to the file or directory in the build context, `<dest>` is the path to the file or directory in the image file system.

### ADD

The `ADD` command copies files and directories from the build context to the image file system. It also allows you to download files from the Internet and unpack archives. The `ADD` command has the following syntax:

```dockerfile
ADD <src> <dest>
```

where `<src>` is the path to the file or directory in the build context, `<dest>` is the path to the file or directory in the image file system. If `<src>` is a URL, the file will be downloaded from the Internet. If `<src>` is an archive, it will be unpacked into the image file system.

The command `ADD` works according to the following algorithm:

- The path `<src>` works in the build context directory, that is, it cannot contain `..` and cannot be absolute.
- If `<src>` is a URL, the file will be downloaded from the Internet.
- If `<src>` is a local `tar` archive in one of the recognized compressed formats (gzip, bz2, xz, identity), it will be unpacked into the image file system.
- If `<src>` is a directory, it will be copied entirely to the image file system, including metadata (owner, permissions, modification date).
- If `<src>` is a file, it will be copied to the image file system. If `<dest>` is a directory, the file will be copied to this directory. If `<dest>` is a file, the file will be copied to this file.
- If the path `<dest>` does not exist, it will be created.

The `ADD` command has more capabilities than the `COPY` command, but for security reasons, it is recommended to use the `COPY` command instead of the `ADD` command.

### RUN

The `RUN` command executes a command in the container. The result of the command execution is saved in the image. The `RUN` command has the following syntax:

```dockerfile
RUN <command>
```

where `<command>` is the command that will be executed in the container.

Sample update of the package list and the packages themselves in the Ubuntu image:

```dockerfile
FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade
```

### CMD

The `CMD` command specifies the command that will be executed when the container is started. The `CMD` command has the following syntax:

```dockerfile
CMD <command>
```

where `<command>` is the command that will be executed when the container is started, or as an array:

```dockerfile
CMD ["<command>", "<arg1>", "<arg2>", ...]
```

The difference between executing a command as a string and as an array is that when executing a command as a string, the command will be executed inside the shell (shell, sh, bash), and when executing a command as an array, the command will be executed directly, without a shell.

Example of running a container with the `echo` command:

```dockerfile
FROM ubuntu:18.04

CMD echo "Hello, world!"
```

or as an array:

```dockerfile
FROM ubuntu:18.04

CMD ["echo", "Hello, world!"]
```

### ENTRYPOINT

The `ENTRYPOINT` command specifies the command that will be executed when the container is started. The command specified in `ENTRYPOINT` cannot be overridden when the container is started. The `ENTRYPOINT` command has the following syntax:

```dockerfile
ENTRYPOINT <command>
```

where `<command>` is the command that will be executed when the container is started, or as an array:

```dockerfile
ENTRYPOINT ["<command>", "<arg1>", "<arg2>", ...]
```

Example of running a container with the `echo` command:

```dockerfile
FROM ubuntu:18.04

ENTRYPOINT echo "Hello, world!"
```

Difference between `CMD` and `ENTRYPOINT` commands:

- The `CMD` command specifies the command that will be executed when the container is started. The command specified in `CMD` can be overridden when the container is started.
- The `ENTRYPOINT` command specifies the command that will be executed when the container is started. The command specified in `ENTRYPOINT` cannot be overridden when the container is started.
- The `CMD` command can be used in the `Dockerfile` multiple times, and the command specified in the last `CMD` command will be executed when the container is started.

### WORKDIR

The `WORKDIR` command sets the working directory for the `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands. The `WORKDIR` command has the following syntax:

```dockerfile
WORKDIR <path>
```

where `<path>` is the path to the working directory. If the working directory does not exist, it will be created.

Example of setting the working directory:

```dockerfile
FROM ubuntu:18.04

WORKDIR /var
CMD ["ls", "-l"]
```

### USER

The `USER` command sets the user on behalf of which the `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, and `ADD` commands will be executed. The `USER` command has the following syntax:

```dockerfile
USER <user>
```

where `<user>` is the username. The user must exist in the image. By default, commands are executed on behalf of the `root` user.

Example of setting the user:

```dockerfile
FROM ubuntu:18.04

USER root
RUN apt-get update && apt-get -y upgrade
USER user
```

In the scope of security, it is recommended to execute `CMD`, `ENTRYPOINT` commands on behalf of a user other than `root`.

## Bibliography

1. [Dockerfile reference, docker.com](https://docs.docker.com/engine/reference/builder/)
2. [olemskoi, ENTRYPOINT vs CMD: назад к основам, Слёрм, Habr.com, 2017](https://habr.com/ru/companies/slurm/articles/329138/)
3. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
