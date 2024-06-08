# Particularities of container cluster configuration

- [Particularities of container cluster configuration](#particularities-of-container-cluster-configuration)
  - [Image build arguments](#image-build-arguments)
  - [Environment variables](#environment-variables)
  - [Resource limitation](#resource-limitation)
  - [Access to the graphics processor](#access-to-the-graphics-processor)
  - [Checking the container state](#checking-the-container-state)
  - [Bibliography](#bibliography)

## Image build arguments

As already mentioned in the Dockerfile description, when building an image, arguments can be passed. This allows you to control the image building process, for example, pass the application version or other parameters. In Docker Compose, arguments can be set in the `docker-compose.yml` file using the `build.args` key:

```yaml
version: '3.9'

services:
  web:
    build:
      context: .
      args:
        - APP_VERSION=1.0.0
```

## Environment variables

When starting a service in a container, environment variables can be passed. This allows you to control the behavior of the container, for example, pass database connection parameters or other parameters.

In Docker Compose, environment variables can be passed in the `docker-compose.yml` file using the `environment` key:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      - DB_HOST=db
      - DB_PORT=5432
```

Environment variables can also be set as a dictionary:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      DB_HOST: db
      DB_PORT: 5432
```

Not always it is convenient to store environment variables in the `docker-compose.yml` file. Therefore, they are often placed in a separate file. If environment variables are declared in the `.env` file, Docker Compose will automatically substitute them in the `docker-compose.yml` file.

Example of the `.env` file:

```env
DB_HOST=db
DB_PORT=5432
```

Now in the `docker-compose.yml` file you can use environment variables:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      - DB_HOST=${DB_HOST}
      - DB_PORT=${DB_PORT}
```

You can also specify a file with environment variables in the `docker-compose.yml` file using the `env_file` key, and you can list several files with environment variables:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    env_file:
      - .env
      - runtime.env
```

It should be remembered that environment variables passed in the `docker-compose.yml` file override environment variables passed in the `.env` file.

It is also not recommended to store passwords and other secret data in the `.env` file. For storing secret data, it is recommended to use Docker Secrets or other tools for managing secrets.

## Resource limitation

By default, containers in Docker Compose have access to all host resources. Such unlimited access to resources can lead to a lack of resources for other containers and, consequently, competition for resources. Setting explicit resource limitations allows you to avoid these problems.

For a container, you can limit access to memory and processor. In Docker Compose, this can be done using the `deploy.resources` key:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 1G
        reservations:
          cpus: '0.1'
          memory: 0.5G
```

In this example, the `web` container has access to no more than 0.5 processor and 1 GB of memory. In addition, when starting, the container reserves at least 0.1 processor and 0.5 GB of memory.

## Access to the graphics processor

For a container, you can define access to the graphics processor (GPU). In Docker Compose, this can be done using the `deploy.resources` key:

```yaml
version: '3.9'

services:
  neural_network:
    image: neuwrl:latest
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
              count: 1
              driver: nvidia
```

This example indicates that the `neural_network` container requires access to the graphics processor to work. The container reserves 1 graphics processor. The `nvidia` driver is used to work with the graphics processor.

At the moment, the following parameters are supported for `capabilities`:

- `gpu` - access to the graphics processor;
- `tpu` - access to the tensor processor.

Other parameters for `capabilities` can also be used, depending on the specific graphics processor driver. For example, to use the CUDA accelerator, the `nvidia` driver can use the `nvidia-compute` parameter.

## Checking the container state

You can also check the container state after it starts. For example, you can check that the container has started successfully and is ready to work. In Docker Compose, this can be done using the `healthcheck` key:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
```

After starting this container cluster, Docker Compose will check the state of the `web` service using the `curl -f http://localhost` command every 30 seconds. If the container does not respond to the request within 10 seconds, Docker Compose will repeat the request 3 times. If the container does not respond to the request after 3 attempts, Docker Compose will restart it.

Sometimes services in containers try to use more resources than they have available. In this case, an `OOME` (Out Of Memory Error) error may occur. To prevent this error, you can use container restart rules:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    deploy:
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
```

In this example, the container will be restarted in case of an `OOME` error no more than 3 times with an interval of 5 seconds. If the container does not start after 3 attempts, Docker Compose will stop the container and issue an error message. The conditions for restarting the container can be as follows:

- `none` - the container will not be restarted;
- `on-failure` - the container will be restarted in case of an error;
- `any` - the container will be restarted in any case.

## Bibliography

1. [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
