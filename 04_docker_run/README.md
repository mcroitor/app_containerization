# Run containerized applications

- [Run containerized applications](#run-containerized-applications)
  - [Build an image](#build-an-image)
  - [Viewing existing images](#viewing-existing-images)
  - [Removing an image](#removing-an-image)
  - [Container creation](#container-creation)
  - [Starting a container](#starting-a-container)
  - [Interaction with the container](#interaction-with-the-container)
  - [Restarting a container](#restarting-a-container)
  - [Copying files](#copying-files)
  - [Viewing container logs](#viewing-container-logs)
  - [Listing containers](#listing-containers)
  - [Stopping a container](#stopping-a-container)
  - [Removing a container](#removing-a-container)
  - [Bibliography](#bibliography)

The container is an instance of an image. Containers can be started, stopped, moved, and removed. In this section, we will look at the commands for working with containers.

## Build an image

After the `Dockerfile` is created, you can start building the image. The image is usually built from the command line using the `docker build` command. The `docker build` command has the following syntax:

```bash
docker build [OPTIONS] PATH | URL | -
```

where `PATH` is the path to the directory containing the `Dockerfile`, `URL` is the URL of the Git repository containing the `Dockerfile`, `-` is standard input.

If the `Dockerfile` is in the current directory, then to build the image, it is enough to execute the command:

```bash
docker build .
```

In this case, the current directory will be used as the build context, and an image with an arbitrary name and tag `latest` will be created. If you need to specify the name and tag of the image, you can do this using the `-t` option:

```bash
docker build -t myimage:1.0 .
```

In this case, the image will be created with the name `myimage` and the tag `1.0`.

To get a detailed description of the `docker build` command options, you can execute the command:

```bash
docker build --help
```

## Viewing existing images

For viewing existing images, the `docker images` command is used:

```bash
docker images
```

The output of the command will contain the following columns:

- `REPOSITORIES` - the name of the image, including the repository name
- `TAG` - the image tag
- `IMAGE ID` - the image identifier
- `CREATED` - the image creation date
- `SIZE` - the image size

## Removing an image

An image can be removed using the `docker rmi` command:

```bash
docker rmi <image_name>
```

where `<image_name>` is the identifier or name of the image.

One command can remove several images at once, for this it is necessary to list their names separated by a space:

```bash
docker rmi <image_name_1> <image_name_2> <image_name_3>
```

## Container creation

A container can be created based on an existing image using the `docker create` command:

```bash
docker create <image_name>
```

In this case, a container with an arbitrary name will be created based on the `<image_name>` image. If the image is not found locally, it will be downloaded from the repository. If you need to create a container with a specific name, then the `--name` flag is used:

```bash
docker create --name <container_name> <image_name>
```

A number of options can be specified when creating a container, such as mounting volumes, port forwarding, passing environment variables, etc. To get a detailed description of the `docker create` command options, you can execute the command:

```bash
docker create --help
```

## Starting a container

After the container is created, it can be started using the `docker start` command:

```bash
docker start <container_name>
```

Developers often create and start a container in one command. For this, the `docker run` command is used:

```bash
docker run <image_name>
```

In this case, a container with an arbitrary name will be created and started based on the `<image_name>` image. If the image is not found locally, it will be downloaded from the repository.

Containers can be started in the background using the `-d` flag:

```bash
docker run -d <image_name>
```

If you need to create and start a container with a specific name, then the `--name` flag is used:

```bash
docker run -d --name <container_name> <image_name>
```

In this case, a container with a specific name `<container_name>` will be created and started based on the `<image_name>` image.

## Interaction with the container

Interaction is possible only with a running container. To do this, you need to know its name or identifier. The container name can be set when creating the container using the `--name` flag, and the container identifier can be obtained using the `docker ps` command.

A command can be executed inside the container using the `docker exec` command:

```bash
docker exec <container_name> <command>
```

When the container is started, the command specified in the `Dockerfile` by one of the `CMD` or `ENTRYPOINT` directives is executed. If you need to execute another command, it is specified after the image name:

```bash
docker run <image_name> <command>
```

Sometimes it is necessary to run a container in interactive mode, for example, for debugging. Interaction with the container allows you to view its contents, execute commands in it (for example, install a package).

In order to run a container in interactive mode, the `-it` flag is used, which combines two flags `-i` (interactive) and `-t` (pseudo-TTY):

```bash
docker run -it <image_name> <command>
```

For example, to run a container with the `ubuntu` image in interactive mode, the command is used:

```bash
docker run -it ubuntu /bin/bash
```

## Restarting a container

For restarting a container, the `docker restart` command is used. For example, to restart a container with the name `my_container`, the following command is used:

```bash
docker restart my_container
```

## Copying files

For copying files, the `docker cp` command is used. The general syntax of the `docker cp` command is as follows:

```bash
docker cp <source> <destination>
```
  
where `<source>` is the source file or directory, and `<destination>` is the destination file or directory. The source or destination can be a path to a file or directory on the host or in the container. If the path is not specified, then the current directory is used.

For example, to copy the `file.txt` file from the container with the name `my_container` to the current directory, the following command is used:

```bash
docker cp my_container:/path/to/file.txt .
```

When it is necessary to copy `file.txt` from the host to the container with the name `my_container` from the current directory, the following command is used:

```bash
docker cp file.txt my_container:/path/to/file.txt
```

## Viewing container logs

The logs of a container can be read using the `docker logs` command. For example, to read the logs of a container with the name `my_container`, the following command is used:

```bash
docker logs my_container
```

If you need to view logs in real time, then the `-f` flag is used:

```bash
docker logs -f my_container
```

## Listing containers

A list of running containers can be viewed using the `docker ps` command:

```bash
docker ps
```

The output of the command will contain the following columns:

- `CONTAINER ID` - container identifier
- `IMAGE` - image name
- `COMMAND` - command running in the container
- `CREATED` - container creation date
- `STATUS` - container status
- `PORTS` - bound ports
- `NAMES` - container name

When it is necessary to view all containers, including stopped ones, the `-a` flag is used:

```bash
docker ps -a
```

## Stopping a container

A container can be stopped using the `docker stop` command:

```bash
docker stop <container_name>
```

When it is necessary to stop several containers at once, it is necessary to list their names separated by a space:

```bash
docker stop <container_name_1> <container_name_2> <container_name_3>
```

## Removing a container

A container can be removed using the `docker rm` command:

```bash
docker rm <container_name>
```

When it is necessary to remove several containers at once, it is necessary to list their names separated by a space:

```bash
docker rm <container_name_1> <container_name_2> <container_name_3>
```

## Bibliography

1. [How do I run a container?, docker.com](https://docs.docker.com/guides/walkthroughs/run-a-container/)
2. [Getting started guide, docker.com](https://docs.docker.com/get-started/)
3. [Запуск контейнера Docker, losst.pro, 2020](https://losst.pro/zapusk-kontejnera-docker)
