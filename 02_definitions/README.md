# Basic concepts

- [Basic concepts](#basic-concepts)
  - [Image](#image)
  - [Container](#container)
  - [Repository](#repository)
  - [Server](#server)
  - [Monolithic architecture](#monolithic-architecture)
  - [Multicomponent architecture](#multicomponent-architecture)
  - [Service](#service)
  - [Web service](#web-service)
  - [Scaling](#scaling)
  - [Cluster](#cluster)
  - [Orchestration](#orchestration)
  - [Cloud](#cloud)
  - [Bibliography](#bibliography)

For understanding any area, it is necessary to have a certain vocabulary of terms. In this section, we will try to define the basic concepts that will be used in the future.

## Image

An **image**  (**container image**) is a file that contains everything needed to run an application. It includes the application itself, dynamic libraries needed to run the application, configuration files, data. Images are created based on the `Dockerfile`, which describes what should be included in the image. Images are stored in a repository, remote or local.

## Container

A **container** is an instance of an image. Containers can be thought of as applications, they can be started, stopped, removed, restarted, etc. Containers can be linked to each other (exchange information) and also with external resources.

## Repository

A **repository** is a storage of some files, however, in the context of containerization, these storages contain images. Repositories can be public and private. Public repositories are available for download to everyone, private repositories are available only to certain users.

The most popular public repository is [Docker Hub](https://hub.docker.com/), which stores images created by the community.

## Server

The term **server** has different meanings depending on the context.

- **Server** as hardware represents a specialized computer on which server software is running. These computers have high performance, reliability, and availability, which allows the application to run for a long time.
- **Server** as software represents a program that provides certain services to clients. The server can be run on any computer, however, to ensure high availability and reliability, servers are run on specialized computers. Servers are run in the operating system in the background, in Linux they are called daemons, in Windows - services.

The main requirement for servers is **reliability**, as they must provide services to clients continuously, without interruptions. The server can also have a number of other properties, depending on the tasks it solves, for example:

- **Performance** - the ability of the server to process client requests in the shortest possible time.
- **Scalability** - the ability of the server to increase performance by increasing the resources allocated to it.
- **Manageability** - the ability of the server to be managed remotely, without the need for the physical presence of the administrator.

## Monolithic architecture

**Monolithic architecture** is an architecture of an application in which all the code of the application is in one component. All components of the application run in one process, in one container. This architecture is simple to implement, however, it has a number of drawbacks, namely, it complicates:

- **understanding** - all the code of the application is in one component, which makes it difficult to read and understand;
- **support** - a large code base complicates the search for what is needed to improve the code and add code for new functionality;
- **scalability** - scaling the application in the case of a monolithic architecture is vertical, which limits the possibilities of scaling;
- **updating** - in this case, it is necessary to update the entire component, even if only part of the functionality has changed.

## Multicomponent architecture

Modern applications are complex systems consisting of many components. Each component performs its function, and the interaction between the components allows the necessary functionality to be implemented. Components can be written in different programming languages, use different databases, and different communication protocols. All this makes the development and maintenance of such applications a complex task. In the case where the application consists of several components, it is said that the application has a **multicomponent** or **modular architecture**.

Developing applications with a multicomponent architecture is a complex task, however, it has a number of advantages, namely:

- **understanding** - each component performs its function, which simplifies the understanding of the application;
- **support** - there is no need to understand all the code of the application, it is enough to understand only the component that needs to be supported;
- **scalability** - scaling the application in the case of a multicomponent architecture is horizontal, which allows increasing the performance of the application by increasing the number of components;
- **updating** - in this case, it is necessary to update only those components that have changed.

A special case of a multicomponent architecture is the **microservices architecture**, where web services (microservices) play the role of modules.

For the simplification of the development and support of applications, containers are used. Each component of the application is run in a separate container, which allows developers to focus on the implementation of the functionality of the component, rather than on its integration with other components. To run the application, it is necessary to start each container containing the components of the application and configure the interaction between them.

## Service

A **service** is a program that is usually run on a server and provides specialized services to clients.

In the context of Web programming, a site can be represented as

- as a single service (monolith, only one entry point),
- as a set of unrelated (each page is completely independent) services, or
- as a set of related services (microservices architecture).

## Web service

**Web service** is a service that provides services via the HTTP protocol. Web services can be available both in a local network and in the global Internet. Applications with a microservices architecture are developed based on the interaction of services.

## Scaling

**Scaling** is the process of increasing the performance of an application by increasing the resources allocated to it. Scaling can be vertical and horizontal.

**Vertical scaling** is called increasing the performance of an application by increasing the resources allocated to it on one server. For example, increasing the amount of RAM, increasing the number of processor cores, increasing the amount of disk space.

**Horizontal scaling** is called increasing the performance of an application by increasing the number of servers on which the application is running. For example, increasing the number of servers on which the application is running.

## Cluster

A **cluster** in the general sense is a group of independent devices united to perform a common task.

In the context of containerization, a **cluster** is a group of computers on which an application deployed in containers is running.

In the context of containerization, a **cluster of containers** (or **pod**) is a set of containers running an application.

## Orchestration

**Orchestration** is the process of managing a cluster of containers. Orchestrators allow you to start, stop, restart containers, as well as manage interactions between them. Orchestrators allow you to manage a cluster of containers as a whole, not as a set of individual containers.

Orchestrators offer the following capabilities:

- Starting and stopping containers
- Scaling the application
- Load balancing between containers
- Detecting and recovering failed containers

## Cloud

A **cloud** is a group of computers connected to a single network, with specialized software installed, that provide services to users. Standard cloud services include: computing power, data storage, network resources, running various applications.

Many companies provide cloud services, for example,

- [Amazon Web Services](https://aws.amazon.com/ru/),
- [Microsoft Azure](https://azure.microsoft.com/ru-ru/),
- [Google Cloud](https://cloud.google.com/).

## Bibliography

1. [**В чем разница между образами Docker и контейнерами?**, AWS Amazon](https://aws.amazon.com/ru/compare/the-difference-between-docker-images-and-containers/)
2. [**Что такое контейнеризация?**, AWS Amazon](https://aws.amazon.com/ru/what-is/containerization/)
3. [**Микрослужбы .NET: Архитектура контейнерных приложений .NET**, learn.microsoft.com, 2022](https://learn.microsoft.com/ru-ru/dotnet/architecture/microservices/)
4. [simust, **Основы контейнеризации (обзор Docker и Podman)**, Habr.com, 2022](https://habr.com/ru/articles/659049/)
