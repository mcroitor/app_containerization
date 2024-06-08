# Image Optimization

- [Image Optimization](#image-optimization)
  - [Getting information about the image size](#getting-information-about-the-image-size)
  - [Minimal base image](#minimal-base-image)
  - [Multi-stage build](#multi-stage-build)
    - [Deprecated approach to build processes](#deprecated-approach-to-build-processes)
      - [Example](#example)
    - [Basic principles of multi-stage build](#basic-principles-of-multi-stage-build)
      - [Example of multi-stage build](#example-of-multi-stage-build)
    - [General view of multi-stage build](#general-view-of-multi-stage-build)
  - [Removing unused dependencies and temporary files](#removing-unused-dependencies-and-temporary-files)
  - [Reducing the number of layers](#reducing-the-number-of-layers)
  - [Image repacking](#image-repacking)
  - [.dockerignore](#dockerignore)
  - [Storing data outside the image](#storing-data-outside-the-image)
  - [Image layer caching](#image-layer-caching)
  - [Bibliography](#bibliography)

The simplicity of defining container images allows them to be quickly created and used, which in turn leads to errors and the creation of redundant images. It is common to create an image of several gigabytes in size, which is clearly a mistake. Most likely, this image contains data that can be moved to external volumes or is not needed at all; unnecessary dependencies that can be removed; temporary files and cache that can be cleared; etc.

A large image has the following disadvantages:

- long time to load the image from the repository;
- takes up more disk space;
- takes up more memory.

That is, a large image requires more resources to load, store, and run. Therefore, optimizing the container image is an important step in the development and use of containers.

## Getting information about the image size

To view the list of images, you can use the `docker images` (or `docker image ls`) command. Running this command will show a list of images, including their sizes. For example:

```shell
$ docker images
docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
lab07        latest    4e96acf7022c   5 days ago   468MB
<none>       <none>    3de1890f5bde   5 days ago   468MB
myphp        latest    ec1fdb037c54   8 days ago   162MB
```

To get information about the layers of the image, you can use the `docker history` command. For example:

```shell
$ docker history myphp
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
ec1fdb037c54   8 days ago   CMD ["/app/php" "-v"]                           0B        buildkit.dockerfile.v0
<missing>      8 days ago   WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicui18n.so…   3.31MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicudata.so…   31.3MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicuuc.so.7…   2.08MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libsqlite3.so…   1.44MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libgmp.so.10 …   529kB     buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libpspell.so.…   14kB      buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libmariadb.so…   337kB     buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libxml2.so.2 …   1.75MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /app/php/sapi/cli/php /app/php # buildk…   40.7MB    buildkit.dockerfile.v0
<missing>      9 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago   /bin/sh -c #(nop) ADD file:5d6b639e8b6bcc011…   80.6MB
```

## Minimal base image

Creating your own container image starts with choosing a base image. The smaller the size of the base image, the smaller the size of the final image. For example, you can use the `alpine` image, which is about 7 MB in size, instead of `ubuntu`, which is about 80 MB in size.

You can also use the `scratch` image, which contains nothing, and add only the necessary files and dependencies to it. However, developers often stop at the `alpine` image as a minimal base image.

You can choose specialized images for specific tasks, which often offer optimized versions. For example, for Python you can use the `python:alpine` image, which contains a minimal set of packages for working with Python.

## Multi-stage build

Multi-stage build allows you to reduce the size of the container image, as only the necessary files and dependencies remain in the final image. For example, you can use an image with a compiler to build the application, and then copy only the executable file to the final image.

To create a truly effective, small, and secure image, it is recommended to perform the build process in several stages. Each build stage is performed in a separate container, and the result of its work is saved in the image. As a result, instead of one large image, several intermediate images are created, storing the results of each stage. The final image will contain only the files necessary for the application to work.

### Deprecated approach to build processes

The process of developing a software product includes the following steps:

- Setting up the environment
- Writing code
- Compilation and build
- Testing
- Deployment

Similarly, building a Docker image includes the following steps:

- Setting up the environment
- Installing dependencies
- Building the application
- Testing
- Deploying the container

In the past, each step of the build process was performed in a separate container. For example, to install dependencies, a container with a compiler and libraries was used, to build the application - a container with a compiler and libraries, to test - a container with a test framework, etc. At the end, the results of each container were combined into one image.

Accordingly, for each stage, its own `Dockerfile` was created, which performed its task, as well as a script to combine the results of the work of the containers into one image.

#### Example

Let's say we have a CPP application (file `helloworld.cpp`) that we want to run in a container.

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

To build the image, we create the following files:

- `helloworld.cpp` - application file
- `Dockerfile.build` - to build the application
- `Dockerfile.run` - to run the application
- `build.sh` - script to build the image

`Dockefile.build`:

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld -static
```

`Dockerfile.run`:

```Dockerfile
FROM debian:latest

WORKDIR /app

COPY app/helloworld .

CMD ["./helloworld"]
```

`build.sh`:

```bash
#!/bin/bash
echo "Building helloworld-build image..."
docker build -t helloworld-build -f Dockerfile.build .

echo "Extracting helloworld binary..."
mkdir -p app
docker create --name extract helloworld-build
docker cp extract:/app/helloworld app/helloworld
docker rm -f extract

echo "Building helloworld-run image..."
docker build -t helloworld-run -f Dockerfile.run .
rm -f app/helloworld
```

When running the `build.sh` script:

- an image `helloworld-build` is created, which builds the application;
- a container `extract` is started, in which the built application is copied to the host machine;
- the `extract` container is deleted;
- an image `helloworld-run` is created, which runs the application.

Multi-stage build allows you to simplify the image build process and reduce its size.

### Basic principles of multi-stage build

Multi-stage build allows you to create images that contain only the files necessary for the application to work, using only one `Dockerfile`. The following principles are used:

- Each instruction uses a base image and sets a build stage;
- Each build stage is performed in a separate container;
- The result of each stage is saved in the image;
- Files can be copied from one stage to another.

#### Example of multi-stage build

In this case, our example can be simplified to one `Dockerfile`:

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld -static

FROM debian:latest

WORKDIR /app

COPY --from=0 app/helloworld .

CMD ["./helloworld"]
```

Building the image in this case is reduced to one command:

```bash
docker build -t helloworld-run .
```

This is possible because the `COPY` instruction can copy files from one stage to another, specifying the stage number from which to copy the files.

In addition, you can give names to the build stages to refer to them by name:

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld

FROM debian:latest AS run

WORKDIR /app

COPY --from=build app/helloworld .

CMD ["./helloworld"]
```

### General view of multi-stage build

Multi-stage build allows you not only to build applications, but also to perform other tasks: testing, code analysis, documentation generation, etc.

In general, a multi-stage build can look like this:

```Dockerfile
# Base image creation
FROM debian:latest AS base

# ...

# Dependencies installation
FROM base AS dependencies

# ...

# Application build
FROM dependencies AS build

# ...

# Application testing
FROM build AS test

# ...

# Application deployment
FROM debian

# copying files from other stages
COPY --from=build /app/app /app/app

# application launch
CMD ["./app"]
```

## Removing unused dependencies and temporary files

Removing unused dependencies allows you to reduce the size of the container image. For example, after installing packages, you can remove temporary files and cache to reduce the size of the image.

This procedure makes sense when combining image layers or repacking the image. Otherwise, removing temporary files and cache will not reduce the size of the image.

## Reducing the number of layers

Each command in the `Dockerfile` creates a new layer in the image. Each layer contains the changes made by the command. The image stores information about each layer, which increases its size. In addition, each layer of the image is represented by an intermediate image, the storage of which requires additional disk space.

Combining commands into one layer reduces the number of intermediate images, as well as reduces the size of the image by reducing the amount of metadata. In addition, it is impossible to create a smaller image if the intermediate images are larger.

Instead of creating a temporary layer to install packages and remove cache, you can execute all commands in one layer.

For example, an image built on the basis of a `Dockefile`:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y php-cli
```

will have approximately the same size as the image built on the basis of the `Dockerfile`:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y php-cli
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

However, combining commands into one layer reduces the size of the image:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y php-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

## Image repacking

Repacking the image allows you to merge all layers of the image into one layer, reducing the size of the image.

> __Note:__ repacking the image leads to the loss of the advantage of sharing image layers between different images. In addition, all image metadata, as well as exposed ports, environment variables, etc., are lost. This method can only be used if you are trying to optimize someone else's image.

To repack the image, you can use the fact that when creating a container, all layers of the image are merged into one layer. For example, you can create a container from an image and then create an image from the container.

If the image is named `myphp`, then repacking the image will look like this:

```shell
# Creating a container from an image
$ docker create --name myphp myphp
# Creating an image from a container
$ docker export myphp | docker import - myphp:optimized
```

## .dockerignore

Using the `.dockerignore` file allows you to exclude files and directories that are not needed to build the image. A common practice is to copy the entire build context, which leads to unnecessary files and directories being included in the image. Therefore, it is recommended to use the `.dockerignore` file to exclude unnecessary files and directories.

The `.dockerignore` file uses the same syntax as the `.gitignore` file. You can use wildcards and regular expressions to exclude files and directories.

Example of the `.dockerignore` file:

```dockerfile
# .dockerignore
.git
.vscode
__pycache__
*.pyc
```

## Storing data outside the image

Storing data outside the image allows you to reduce the size of the container image. For example, you can use external volumes to store web applications. However, it should be remembered that external volumes can be network drives, which can increase the application's response time due to network latency.

## Image layer caching

Docker actively uses image layer caching, which speeds up the image build process. However, image layer caching consumes disk space. To effectively use caching, you need to consider the order of commands in the `Dockerfile` and use multi-stage build.

When changing the `RUN` command, all subsequent commands will be rebuilt, which will increase the image build time. Therefore, it is necessary to first execute commands that are less likely to change (e.g., environment setup), and then execute commands that change more frequently (e.g., copying the application).

In the example given, the image will be completely rebuilt each time the application changes:

```dockerfile
FROM nginx

COPY . /usr/share/nginx/html
RUN apt-get update && apt-get install -y php-cli
```

However, if you swap the `RUN` and `COPY` commands, then when the application changes, the image will be partially rebuilt, which will speed up the image build:

```dockerfile
FROM nginx

RUN apt-get update && apt-get install -y php-cli

COPY . /usr/share/nginx/html
```

## Bibliography

1. [Predrag Rakić, Docker Image Size – Does It Matter?, semaphoreci.com, 2021-03-30](https://semaphoreci.com/blog/2018/03/14/docker-image-size.html)
2. [Rafael Benevides, Keep it small: a closer look at Docker image sizing, RedHat, 2016-03-09](https://developers.redhat.com/blog/2016/03/09/more-about-docker-images-size)
3. [Bibin Wilson, Shishir Khandelwal, How to Reduce Docker Image Size: 6 Optimization Methods, devopscube.com, 2023-08-22](https://devopscube.com/reduce-docker-image-size/)
4. [Jeff Hale, Slimming Down Your Docker Images, towardsdatascience.com, 2019-01-31](https://towardsdatascience.com/slimming-down-your-docker-images-275f0ca9337e)
5. [pxeno, Полное руководство по созданию Docker-образа для обслуживания системы машинного обучения в продакшене, habr.com](https://habr.com/ru/companies/vk/articles/548480/)
6. [BOOTLOADER, Многоэтапные (multi-stage builds) сборки в Docker, habr.com](https://habr.com/ru/articles/349802/)
7. [Использование многоэтапных (multi-stage) сборок в Docker, cloud.croc.ru](https://cloud.croc.ru/blog/about-technologies/multi-stage-v-docker/)
8. [Docker, Multi-stage builds, docs.docker.com](https://docs.docker.com/build/building/multi-stage/)
