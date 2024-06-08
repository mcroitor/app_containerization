# Recommendations for developing containers

- [Recommendations for developing containers](#recommendations-for-developing-containers)
  - [Privilege escalation](#privilege-escalation)
    - [Application execution from a minimal privilege user](#application-execution-from-a-minimal-privilege-user)
    - [Deny changes of executable files](#deny-changes-of-executable-files)
  - [Dependencies](#dependencies)
    - [Multistage builds usage](#multistage-builds-usage)
    - [Known base images](#known-base-images)
    - [Timely updating of images](#timely-updating-of-images)
    - [Open ports](#open-ports)
  - [Data protection](#data-protection)
    - [Sensitive data](#sensitive-data)
    - [ADD and COPY](#add-and-copy)
    - [Build context](#build-context)
    - [Logs](#logs)
  - [Miscellaneous](#miscellaneous)
    - [Layer order](#layer-order)
    - [Metadata](#metadata)
    - [Checking images for vulnerabilities](#checking-images-for-vulnerabilities)
  - [Conclusions](#conclusions)
  - [Bibliography](#bibliography)

Good defined `Dockerfile` eliminates the need to use privileged containers, open unnecessary ports, include extra packages, and avoid sensitive data leaks. These issues should be addressed immediately to reduce the effort of maintaining the applications being developed.

## Privilege escalation

### Application execution from a minimal privilege user

__Run applications from a minimal privilege user.__

According to the [Sysdig 2021 container security and usage report](https://sysdig.com/blog/sysdig-2021-container-security-usage-report/), 58% of all containers run as the `root` user. Running as `root` in containers can lead to serious security vulnerabilities. Therefore, it is recommended to run applications as a minimal privilege user using the `USER` directive in the Dockerfile.

To configure a non-privileged user, you need to perform several additional steps:

- ensure that the user exists in the image (create it);
- set the necessary permissions on files and directories that the application works with.

Example Dockerfile:

```Dockerfile
FROM ubuntu:20.04

# Create a user and set permissions
RUN adduser --no-create-home --disabled-login myuser && \
    chown -R myuser:myuser /app-data

# Copy the application
COPY app /app

# Set the working user
USER myuser

ENTRYPOINT ["/app"]
```

### Deny changes of executable files

__Prohibit changes to executable files.__

In Docker containers, files marked with the `+x` attribute can be changed during execution. This can lead to changes in executable files and, as a result, security vulnerabilities. To prevent changes to executable files, it is recommended to use the `COPY` directive instead of `ADD` and set file attributes after copying.

The best idea is to assign `root` as the owner of executable files, in this case, they will not be writable to other users. In this case, the container will be immutable and secure, avoiding the situation where the running application is changed accidentally or maliciously.

User of the container only needs to have read and execute permissions on files.

```Dockerfile
FROM ubuntu:20.04

# Create a user and set permissions
RUN adduser --no-create-home --disabled-login myuser && \
    chown -R myuser:myuser /app-data

# Copy the application
COPY app /app

RUN chmod +x-w /app

# Set the working user
USER myuser

ENTRYPOINT ["/app"]
```

## Dependencies

__Minimize the size of the image.__

Avoid installing unnecessary packages or opening unnecessary ports - this can increase the attack surface. The more components you include in the container, the more vulnerable your system will be and the more difficult it will be to maintain, especially for components that are not under your control.

### Multistage builds usage

__Use multistage builds.__

An effective way to reduce the size of the image is to use multistage builds. This allows you to split the build and run of the application into several stages, each of which uses its own image. For example, you can use one image for building the application and another for running it.

This approach creates an intermediate container that contains all the necessary dependencies for building the application (tools, packages, temporary files). Only executable files and libraries necessary for the application to run remain in the final image. Using multistage builds not only reduces the size of the image but also improves security, as an attacker will not be able to access the build tools and temporary files.

### Known base images

__Carefully choose base images.__

Base images are the foundation of your container. Your containers based on unverified and unsupported images inherit all the problems and vulnerabilities from these base images.

The best option is to create an image from scratch (`scratch`), but this is only suitable for static binary files.

A good option is to use `Distroless` images, which contain only the minimal set of libraries and tools needed to run the application. This reduces the image size and reduces the attack surface.

Some popular repositories with secure images:

- [Google Distroless Container Tools](https://github.com/GoogleContainerTools/distroless) - based on Debian, contains builds for statically compiled languages (C / C++, Go, Rust), as well as for Java, Python, Node.js.
- [Chainguard Images](https://github.com/chainguard-images) - collects small and secure container images built on Alpine Linux. There are images for .NET, php, Ruby, and other languages.

It is also recommended to use official images, as they are regularly updated and checked for security.

### Timely updating of images

__Use base images that are regularly updated, and update your images based on them.__

The process of detecting vulnerabilities is continuous, so the correct approach is to regularly update with the latest security fixes.

At the same time, there is no need to always try to use the latest version, which may contain critical vulnerabilities, but you should follow the versioning strategy:

- Stick to stable or long-term support versions that quickly and frequently provide security fixes;
- Be prepared to abandon old versions and migrate before the end of support for the current version of your base image, and it stops receiving updates;
- Also, periodically rebuild your own images using a similar strategy to get the latest packages from the base distribution, Node, Golang, Python, etc. Most package or dependency managers, such as `composer`, `npm`, or `go mod`, `pip` or `poetry`, offer ways to specify version ranges to keep up with the latest security updates.

### Open ports

__Only open the necessary ports.__

Each open port in your container is an open door to your system. Leave open only the ports that your applications really need and avoid ports like `SSH (22)`.

Note that although the `Dockerfile` contains the `EXPOSE` command, this command is more informative. Opening ports does not allow you to automatically connect to them when starting a container (unless you run the `docker run --publish-all` command), as you still need to specify the published ports when starting the container.

Use the `EXPOSE` command in the `Dockerfile` only to indicate and document the required ports, then use the specified ports in the container startup process.

## Data protection

When working with containers, you need to be careful to avoid accidental data leaks.

### Sensitive data

__Never place sensitive data (passwords, keys, certificates) in the Dockerfile.__

The `Dockerfile` is a text file that is stored in the repository and can be accessed by anyone. Any sensitive data placed in the `Dockerfile` will be visible to everyone who has access to the repository.

In addition, be careful when copying files into the container. Even if an important file has been deleted from the image in subsequent layers, it can still be accessed in previous layers.

When creating an image, follow these recommendations:

- If the application supports working with environment variables, use them to pass confidential data to the container or use Docker secrets to work with confidential data.
- Use configuration files and mount them into the container when starting.

Also, your images should not contain confidential information or configuration parameters related to a specific environment (e.g., `dev`, `qa`, `prod`, etc.).

### ADD and COPY

__Prefer the `COPY` command over `ADD`.__

The `ADD` and `COPY` instructions provide similar functions - they copy files from the build context to the image. However, using `COPY` is preferred because the data copying process is predictable and less error-prone.

The `ADD` instruction has additional features, such as automatic unpacking of archives and loading files from URLs. These features can be dangerous as they can lead to data leaks or security vulnerabilities.

In the case of copying a package by URL, it is preferable to use `RUN` with the `wget` or `curl` command instead of `ADD`, extract it, and delete the archive, which will reduce the number of image layers.

Multistage builds also solve this problem and help follow best practices by allowing you to copy files from an archive unpacked in a previous step.

### Build context

__Avoid copying the entire build context into the image.__

A bad practice is copying the entire build context into the image, as this can lead to a leak of confidential data.

According to best practices, you should create a folder for all files that need to be copied into the image and use this folder as the build context. This will prevent accidental copying of confidential data and reduce the size of the build context.

Also, use the `.dockerignore` file to exclude unnecessary files and directories from the build context.

### Logs

__Check logs for confidential data.__

Logs may contain confidential data such as passwords, keys, or personal information. Therefore, you should be careful when writing logs in the container.

Use environment variables to configure the logging level and mount directories to write logs outside the container.

## Miscellaneous

### Layer order

__Place instructions in the Dockerfile in descending order of change frequency.__

The order of instructions in the `Dockerfile` affects the caching of image layers. When an instruction changes, all subsequent instructions will be rebuilt, which can increase the build time.

Therefore, it is recommended to place instructions in the `Dockerfile` in descending order of change frequency. For example, instructions that change infrequently (installing dependencies, copying files) should be placed at the beginning of the `Dockerfile`, and instructions that change frequently (compiling code, installing packages) should be placed at the end of the `Dockerfile`.

Bad order of instructions:

```Dockerfile
FROM ubuntu:20.04

COPY . /app

RUN apt-get update && apt-get install -y python3

CMD ["python3", "/app/app.py"]
```

It is better to swap the `COPY` and `RUN` instructions:

```Dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3

COPY . /app

CMD ["python3", "/app/app.py"]
```

### Metadata

__Include metadata in the image.__

It is strongly recommended to include metadata when creating an image. Metadata helps identify the image, contains information about the version, author, license, and other important attributes.

### Checking images for vulnerabilities

__Regularly check images for vulnerabilities.__

It is necessary to regularly test images for errors and vulnerabilities. There are many tools that help automate this process:

- [Docker Scout](https://docs.docker.com/scout/)
- [Trivy](https://trivy.dev)
- [Clair](https://www.redhat.com/en/topics/containers/what-is-clair)

## Conclusions

Compliance with recommendations when developing a `Dockerfile` will help improve the security and reliability of your containers. This will help avoid many problems related to data leaks, security vulnerabilities, and maintenance complexity.

There are many recommendations (e.g., signing images, using `HEALTHCHECK`) that we have not considered, so it is strongly recommended to familiarize yourself with the literature listed in the bibliography.

## Bibliography

1. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
2. [Docker Security](https://docs.docker.com/engine/security/)
3. [Newcomb Aaron, Sysdig 2021 container security and usage report: Shifting left is not enough, 2021](https://sysdig.com/blog/sysdig-2021-container-security-usage-report/)
4. [Iradier Álvaro, Top 20 Dockerfile best practices, 2021](https://sysdig.com/blog/dockerfile-best-practices/)
5. [antonkh, Distroless контейнеры, habr.com, 2023](https://habr.com/ru/articles/710968/)
