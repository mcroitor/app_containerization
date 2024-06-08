# The interaction of containers

- [The interaction of containers](#the-interaction-of-containers)
  - [File system](#file-system)
    - [Working with volumes](#working-with-volumes)
    - [Attaching a volume to a container](#attaching-a-volume-to-a-container)
    - [Example](#example)
  - [Network](#network)
    - [Managing networks in Docker](#managing-networks-in-docker)
    - [Running containers in a network](#running-containers-in-a-network)
  - [Bibliography](#bibliography)

The interaction of containers is a key aspect of the development of complex information systems. Complex information systems are usually multi-component. Each component can be developed and maintained by a separate team. In such cases, it is important to ensure interaction between components.

Containers can interact with each other through the network or file system.

## File system

Two containers can interact through the file system if they mount the same volume. For example, container `A` can write a file to the volume, and container `B` can read this file. In this case, containers can interact with each other even if they are running on different networks.

### Working with volumes

Volumes in Docker are a mechanism for storing data that can be used by multiple containers. Volumes can be created, viewed, deleted, and attached to a container.

To work with volumes, the following commands are used:

- `docker volume create <VOLUME>` - create a volume with the name `<VOLUME>`;
- `docker volume ls` - view the list of volumes;
- `docker volume rm <VOLUME>` - delete the volume with the name `<VOLUME>`;
- `docker volume inspect <VOLUME>` - view information about the volume with the name `<VOLUME>`;
- `docker volume prune` - delete all unused volumes.

### Attaching a volume to a container

To attach a volume to a container, the `-v` option of the `docker run` command is used. For example, to attach a volume named `opt` to the container `mycontainer`, the following command is used:

```bash
docker run -v opt:/opt --name mycontainer myimage
```

In this case, the volume `opt` will be available in the container `mycontainer` at the path `/opt`.

### Example

Consider an example in which one container writes a random number to a file every 5 seconds, and another container reads this file and outputs its contents to the console. For the writing container `dockerfile.write` looks as follows:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do shuf -i1-10 -n1 > /opt/data.txt; sleep ${TIMEOUT}; done"]
```

For the reading container `dockerfile.read` looks as follows:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do cat opt/data.txt; sleep ${TIMEOUT}; done"]
```

First, create a common volume `opt`:

```bash
docker volume create opt
```

Now let's build both images:

```bash
docker build -t read -f dockerfile.read .
docker build -t write -f dockerfile.write .
```

Up the containers:

```bash
docker run -d -v opt:/opt --name write write
docker run -d -v opt:/opt --name read read
```

After a while, the reading container will start displaying random numbers written by the writing container.

## Network

Two containers can interact through the network. In Docker, a network is a mechanism for connecting containers to each other. Networks can be created, viewed, deleted, and containers can be connected to a network.

### Managing networks in Docker

The following commands are used to work with networks:

- `docker network create <NETWORK>` - create a network with the name `<NETWORK>`;
- `docker network ls` - view the list of networks;
- `docker network rm <NETWORK>` - delete the network with the name `<NETWORK>`;
- `docker network inspect <NETWORK>` - view information about the network with the name `<NETWORK>`;
- `docker network connect <NETWORK> <CONTAINER>` - connect the container with the name `<CONTAINER>` to the network with the name `<NETWORK>`;
- `docker network disconnect <NETWORK> <CONTAINER>` - disconnect the container with the name `<CONTAINER>` from the network with the name `<NETWORK>`;
- `docker network prune` - delete all unused networks.

### Running containers in a network

There are two ways to run containers in a network:

- connecting a container to a network after it has started;
- connecting a container to a network when it starts.

In the first case, the `docker network connect` command is used, in the second case, the `--network` option of the `docker run` command is used.

Consider an example. Let there be two containers `frontend` and `backend`. To make them work in the same network `local`, you need to:

- create a network `local`;
- run the `backend` container in the `local` network;
- run the `frontend` container in the `local` network.

```bash
docker network create local
docker run -d --name backend --network local backend
docker run -d --name frontend --network local frontend
```

## Bibliography

1. [Швалов А., Хранение данных в Docker, Слерм](https://slurm.io/blog/tpost/i5ikrm9fj1-hranenie-dannih-v-docker)
2. [Docker Networking, Docker](https://docs.docker.com/network/)
3. [Docker Volumes, Docker](https://docs.docker.com/storage/volumes/)
