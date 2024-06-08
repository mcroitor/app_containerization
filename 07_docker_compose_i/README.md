# Creating a cluster of containers using Docker Compose

- [Creating a cluster of containers using Docker Compose](#creating-a-cluster-of-containers-using-docker-compose)
  - [The purpose of Docker Compose](#the-purpose-of-docker-compose)
  - [Syntax of docker-compose.yml](#syntax-of-docker-composeyml)
    - [Description of the service](#description-of-the-service)
    - [Description of the volume](#description-of-the-volume)
    - [Description of the network](#description-of-the-network)
    - [Description of the configuration](#description-of-the-configuration)
    - [Description of the secret](#description-of-the-secret)
  - [Example of a cluster of containers](#example-of-a-cluster-of-containers)
  - [Managing a cluster of containers](#managing-a-cluster-of-containers)
  - [Bibliography](#bibliography)

## The purpose of Docker Compose

Docker Compose is an instrumental tool that is part of Docker and is designed to manage a cluster of containers. It allows you to describe the configuration of a cluster of containers in the `docker-compose.yml` file and manage this cluster from the command line.

Usually, when creating a composite application, it is difficult to do without just one container for several reasons. If we consider a Web application, it consists of several independent but interacting components: a web server, a database, a cache, a message queue, etc. Including all these components in one container is inefficient because it leads to the following problems:

- Development of each component cannot be carried out by different teams;
- Each component cannot be scaled independently of the others;
- Each component cannot be updated independently of the others;
- Each component cannot be replaced independently of the others.

Each of these components (web server, database, cache, message queue, etc.) can be represented by a separate container, which allows you to work with each part of the application independently. Docker Compose allows you to describe the configuration of all these containers in one file `docker-compose.yml` and manage them from the command line.

## Syntax of docker-compose.yml

The `docker-compose.yml` file is a YAML file that describes the configuration of a cluster of containers. The general structure of `docker-compose.yml` is as follows:

```yaml
# The docker compose file must start with a version. In this case, it is version 3 - the latest at the time of writing the article.
version: '3'

# Next is the list of services that will be launched in the container cluster.
# Each service represents a separate container.
# A service can be a web server, a database, a cache, a message queue, etc.
# The section describing services starts with the keyword services:
services:
    # The description of each service starts with its name, which can be arbitrary.
    <service1-name>:
        # description of the service
        # ...
    <service2-name>:
        # description of the service
        # ...
    # ...

# Next is the list of volumes that will be used in the container cluster.
volumes:
    # The description of each volume starts with its name, which can be arbitrary.
    <volume1-name>:
        # description of the volume
        # ...
    <volume2-name>:
        # description of the volume
        # ...
    # ...

# Next is the list of networks that will be used in the container cluster.
networks:
    # The description of each network starts with its name, which can be arbitrary.
    <network1-name>:
        # description of the network
        # ...
    <network2-name>:
        # description of the network
        # ...
    # ...

# Next is the list of configurations that will be used in the container cluster.
configs:
    # The description of each configuration starts with its name, which can be arbitrary.
    <config1-name>:
        # description of the configuration
        # ...
    <config2-name>:
        # description of the configuration
        # ...
    # ...

# Next is the list of secrets that will be used in the container cluster.
secrets:
    # The description of each secret starts with its name, which can be arbitrary.
    <secret1-name>:
        # description of the secret
        # ...
    <secret2-name>:
        # description of the secret
        # ...
    # ...
```

In the standard description of a container cluster in the `docker-compose.yml` file, the `services` section must be present, which describes services that are containers. The other sections (`volumes`, `networks`, `configs`, `secrets`) are optional and are used to describe volumes, networks, configurations, and secrets, respectively.

### Description of the service

The `services` section contains a list of services, each of which represents a separate container. The description of the service contains the following keys:

- `image` - the name of the container image that will be used to create the service;
- `build` - the path to the directory containing the Dockerfile that will be used to create the container image that will be used to create the service;
- `ports` - a list of ports that will be forwarded from the container to the host;
- `volumes` - a list of volumes that will be used in the container;
- `networks` - a list of networks that will be used in the container;
- `configs` - a list of configurations that will be used in the container;
- `secrets` - a list of secrets that will be used in the container;
- `environment` - a list of environment variables that will be set in the container;
- `command` - the command that will be executed when the container is started;
- `entrypoint` - the command that will be executed when the container is started;
- `depends_on` - a list of services that this service depends on.

Example of a service description:

```yaml
services:
    nginx:
        image: nginx:alpine
        ports:
            - "8080:80"
        volumes:
            - /path/to/web:/usr/share/nginx/html
        networks:
            - frontend
        environment:
            - NGINX_PORT=80
        depends_on:
            - mariadb
    mariadb:
        image: mariadb:latest
        volumes:
            - /path/to/db:/var/lib/mysql
        networks:
            - backend
        environment:
            - MYSQL_ROOT_PASSWORD=secret
```

### Description of the volume

The `volumes` section contains a list of volumes that will be used in the container cluster. The description of the volume contains the following keys:

- `driver` - the driver that will be used to create the volume;
- `driver_opts` - the driver options that will be used to create the volume;
- `external` - the name of the external volume that will be used in the container cluster;
- `labels` - a list of labels that will be set for the volume;
- `name` - the name of the volume.

Example of a volume description:

```yaml
volumes:
    web:
        driver: local
        driver_opts:
            type: none
            device: /path/to/web
            o: bind
    db:
        driver: local
        driver_opts:
            type: none
            device: /path/to/db
            o: bind
```

### Description of the network

The `networks` section contains a list of networks that will be used in the container cluster. The description of the network contains the following keys:

- `driver` - the driver that will be used to create the network;
- `driver_opts` - the driver options that will be used to create the network;
- `external` - the name of the external network that will be used in the container cluster;
- `attachable` - a flag that indicates that containers can attach to the network;
- `internal` - a flag that indicates that the network is an internal network;
- `labels` - a list of labels that will be set for the network;
- `name` - the name of the network;
- `enable_ipv6` - a flag that indicates that the network supports IPv6;
- `ipam` - IPAM parameters for the network.

Example of a network description:

```yaml
networks:
    frontend:
        driver: bridge
        driver_opts:
            com.docker.network.bridge.name: frontend
    backend:
        driver: bridge
        driver_opts:
            com.docker.network.bridge.name: backend
```

### Description of the configuration

The `configs` section contains a list of configurations that will be used in the container cluster. The description of the configuration contains the following keys:

- `file` - the path to the file that will be used to create the configuration;
- `environment` - a list of environment variables that will be set for the configuration;
- `external` - the name of the external configuration that will be used in the container cluster;
- `name` - the name of the configuration;
- `content` - the configuration is created based on the content.

Example of a configuration description:

```yaml
configs:
    nginx.conf:
        file: /path/to/nginx.conf
    php.ini:
        file: /path/to/php.ini
```

### Description of the secret

The `secrets` section contains a list of secrets (passwords, private keys, certificates) that will be used in the container cluster. The description of the secret contains:

- `file` - the path to the file that will be used to create the secret;
- `environment` - the secret is created based on the environment variable.

Example of a secret description:

```yaml
secrets:
    db_password:
        environment: DB_PASSWORD
    db_user:
        environment: DB_USER
    certificate:
        file: ./certificate.pem
```

## Example of a cluster of containers

The following example shows the description of a service application consisting of services:

- `nginx` - a web server that serves static files and redirects requests to the application;
- `php-fpm` - a PHP interpreter that processes dynamic requests;
- `mariadb` - a database server that stores application data.

The site is located in the mounted to the containers `nginx` and `php-fpm` directories `./files/app`, and the database is located in the mounted to the `mariadb` container directory `./mounts/db`.

The `nginx` container forwards port 8080 to port 80 of the container, and the `php-fpm` container uses port 9000. The `nginx` container is connected to the `frontend` and `backend` networks, and the `mariadb` and `php-fpm` containers are connected to the `backend` network.

```yaml
version: '3'

services:
    nginx:
        image: nginx:1.23.3
        ports:
            - "8080:80"
        volumes:
            - ./files/app:/usr/share/nginx/html
        networks:
            - frontend
            - backend
        environment:
            - NGINX_PORT=80
        depends_on:
            - mariadb
    php-fpm:
        image: php:7.4-fpm
        volumes:
            - ./files/app:/var/www/html
        networks:
            - backend
        environment:
            - PHP_PORT=9000
        depends_on:
            - mariadb
    mariadb:
        image: mariadb:10.5
        volumes:
            - ./mounts/db:/var/lib/mysql
        networks:
            - backend
        environment:
            - MYSQL_ROOT_PASSWORD=secret
            - MYSQL_DATABASE=app
            - MYSQL_USER=user
            - MYSQL_PASSWORD=password

networks:
    frontend: {}
    backend: {}
```

## Managing a cluster of containers

The `docker-compose` utility is used to manage a cluster of containers. It is a command-line utility that allows you to build, run, and stop containers, as well as view logs and execute commands inside containers.

The `docker-compose.yaml` file describes the services of the application and the interactions between them. To build the containers of the services, define the infrastructure, you need to execute the command

```bash
docker-compose build
```

To start the service containers, you need to execute the command

```bash
docker-compose up -d
```

The `-d` key means that the service containers will be started in the background.

To stop the service containers, you need to execute the command

```bash
docker-compose down
```

Sometimes there is a need to completely rebuild the service containers. To do this, you need to execute the command

```bash
docker-compose build --no-cache
```

An important property is to view the logs of the service containers. To do this, you need to execute the command

```bash
docker-compose logs -f <service-name>
```

Finally, to execute a command `command` inside the service container, you need to execute the command

```bash
docker-compose exec <service-name> <command>
```

## Bibliography

1. [YAML Ain’t Markup Language (YAML™) version 1.2, yaml.org, 2021-10-01](https://yaml.org/spec/1.2.2/)
2. [Шпаргалка по YAML](../additional/yaml.md)
3. [Docker Compose overview, docs.docker.com](https://docs.docker.com/compose/)
4. [Gaël Thomas, A beginner’s guide to Docker — how to create a client/server side with docker-compose, https://www.freecodecamp.org](https://www.freecodecamp.org/news/a-beginners-guide-to-docker-how-to-create-a-client-server-side-with-docker-compose-12c8cf0ae0aa)
5. [Gaël Thomas, Руководство по Docker Compose для начинающих, перевод статьи https://www.freecodecamp.org, habr.com](https://habr.com/ru/companies/ruvds/articles/450312/)
