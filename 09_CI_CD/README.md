# Continuous Integration and Continuous Delivery (CI / CD)

- [Continuous Integration and Continuous Delivery (CI / CD)](#continuous-integration-and-continuous-delivery-ci--cd)
  - [Continuous Integration](#continuous-integration)
    - [Organizing Continuous Integration](#organizing-continuous-integration)
    - [Advantages and disadvantages of continuous integration](#advantages-and-disadvantages-of-continuous-integration)
  - [Continuous Delivery](#continuous-delivery)
  - [Example of CI / CD process](#example-of-ci--cd-process)
    - [Code organization](#code-organization)
    - [Sample model](#sample-model)
    - [Tools](#tools)
    - [Infrastructure for CI / CD](#infrastructure-for-ci--cd)
  - [Containers in CI / CD processes](#containers-in-ci--cd-processes)
  - [Bibliography](#bibliography)

Modern software development is similar to organizing an assembly line. Each stage of software development must be automated and integrated into the overall process. Specialized tools and technologies such as _Continuous Integration_ (CI) and _Continuous Delivery_ (CD) are used for this purpose.

## Continuous Integration

__Continuous Integration__ (CI) is a software development practice in which developers' code changes are integrated into a common code base several times a day. Each integration is verified by automated builds and tests, which helps to identify and fix errors faster.

Usually, several developers work independently on a project, each of whom can make changes to the code several times a day. To avoid conflicts and errors during the integration of changes, the practice of continuous integration is used. This practice assumes that each time the code changes, the software is automatically built and tested.

### Organizing Continuous Integration

To organize the continuous integration process, the following requirements must be met:

- use a version control system to store the source code;
- set up automatic build and testing of the code with each change.

In the case of continuous integration on a dedicated server, a specialized service is launched that performs the following steps when an event occurs:

1. Getting the source code from the version control system;
2. Building the software;
3. Deploying the software in a test environment;
4. Running automated tests;
5. Sending a test report to the developers.

Software builds can be triggered by various events, such as:

- a new commit to the version control system;
- a new pull request;
- a new tag.

Scheduled builds (_daily build_ or _nightly build_) can also exist. This reduces the load on the continuous integration server and speeds up the development process.

### Advantages and disadvantages of continuous integration

Continuous integration has the following advantages:

- fast identification and correction of errors;
- immediate and regular testing;
- constant availability of the current stable version of the software;
- immediate effect of incomplete code encourages developers to work in an iterative mode.

Disadvantages of continuous integration:

- additional costs to support continuous integration;
- the need for additional resources to ensure continuous integration.

## Continuous Delivery

__Continuous Delivery__ (CD) is a software development practice in which each code change undergoes automated tests for quality and security compliance and is ready for release. This allows developers to deliver changes to users faster and more reliably.

Continuous delivery is an extension of continuous integration. In addition to continuous integration, continuous delivery includes automated testing, deployment, and monitoring of software.

In practice, continuous delivery can be combined with __continuous deployment__, in which each code change is automatically deployed to production without developer intervention. This reduces the time between writing code and releasing it, as well as simplifies the release process. However, continuous deployment requires more careful control of the quality and security of the code.

The difference between continuous delivery and continuous deployment is that in the first case, developers decide when to release changes to production, while in the second case, this happens automatically.

In practice, the organization of CI / CD processes imposes additional requirements on infrastructure and development processes.

## Example of CI / CD process

### Code organization

One way to organize code work can be as follows:

1. There is a main development branch (for example, `main` or `master`);
2. When developing a new feature, a separate branch is created based on the main branch (for example, `feature-branch`);
3. After completing the development of the functionality, a pull request is created to merge into the main branch;
4. After checking the code and successfully passing the tests, the pull request is merged into the main branch;
5. After merging into the main branch, the software build and testing process is launched;
6. If the tests pass successfully, a release branch of the software is created (or the release is tagged);
7. Creating a release branch launches the process of deploying the software to the production environment.

### Sample model

CI / CD process organization can be represented by the following environments:

- __local__ - local development environment installed on each developer's computer;
- __qa__ - environment for integrating new functionality;
- __staging__ - environment for testing new functionality;
- __production__ - environment for deploying new functionality.

Developers work in a local environment, where they create new functionality and perform testing.

After completing the development of new functionality, a pull request is created to merge into the `main` branch. After completing the development of new functionality, a pull request is created to merge into the `main` branch. Creating a pull request launches the build and testing process in the `qa` environment. Automated tests are run in the `qa` environment to verify the functionality.

If the tests pass successfully in the `qa` environment, the branches are merged. After merging the branches, the code from the `main` branch is deployed in the `staging` environment.

The `staging` environment is almost identical to the `production` environment, except that new functionality is deployed for testing. Testing in the `staging` environment is done manually.

If the tests pass successfully in the `staging` environment, a release branch is created. Creating a release branch launches the process of deploying the software to the `production` environment.

### Tools

Specialized tools are used to organize CI / CD processes, which allow automating the processes of building, testing, and deploying software:

- __Jenkins__ — is a popular tool for organizing CI / CD processes;
- __GitLab CI__ — is a tool for organizing CI / CD processes integrated with the GitLab version control system. GitLab CI allows you to configure build, test, and deployment chains of software and manage them through the GitLab web interface;
- __TeamCity__ — is a tool for organizing CI / CD processes developed by JetBrains;
- __CircleCI__ — is a tool for organizing CI / CD processes integrated with the GitHub version control system;
- __Github Actions__ — is a tool for organizing CI / CD processes integrated with the GitHub version control system. Github Actions allows you to configure build, test, and deployment chains of software and manage them through the Github Actions web interface;
- __AWS CodeBuild__, __AWS CodePipeline__ — are tools for organizing CI / CD processes integrated with the Amazon Web Services (AWS) cloud platform;
- __Azure DevOps__ — is a tool for organizing CI / CD processes integrated with the Microsoft Azure cloud platform;
- __Atlassian Bamboo__ — is a tool for organizing CI / CD processes developed by Atlassian.

### Infrastructure for CI / CD

To organize CI / CD processes, specialized infrastructure is required that allows automating the processes of building, testing, and deploying software:

- __Docker__ — is a popular platform for developing, delivering, and running applications in containers. Docker allows you to package applications and their dependencies in containers, making it easier to deploy and scale applications;
- __Kubernetes__ — is a platform for automating the deployment, scaling, and management of containerized applications. Kubernetes allows you to manage a cluster of servers running containers and provides high availability and scalability of applications;
- __Terraform__ — is a tool for managing infrastructure as code. Terraform allows you to describe infrastructure in configuration files and automate its deployment and management;
- __Ansible__ — is a tool for automating configuration management and software deployment. Based on the description of configurations (playbook), Ansible automatically deploys software on the target computer.

## Containers in CI / CD processes

Using containers in CI / CD processes simplifies the deployment and scaling of applications, as well as ensures their isolation and security.

Containers allow you to package applications and their dependencies in isolated environments, making it easier to deploy and manage them. In addition, containers allow you to run applications in any environment where Docker is installed, providing portability and scalability.

Most modern tools for organizing CI / CD processes support working with containers, moreover, they even implement CI / CD process steps in containers, that is:

- the CI / CD system itself runs in a container;
- each step of the CI / CD process is performed in a separate container;
- often the final application is also packaged in a container.

When using containers, it is easier to move the application from one environment to another, because when building the application in a container for the `qa` environment, after successfully passing the tests, this container can be used for the `staging` and `production` environments.

## Bibliography

1. [Continuous Integration, Wikipedia](https://en.wikipedia.org/wiki/Continuous_integration)
2. [Continuous Delivery, Wikipedia](https://en.wikipedia.org/wiki/Continuous_delivery)
3. [Jenkins](https://www.jenkins.io/)
4. [GitLab CI](https://docs.gitlab.com/ee/ci/)
5. [TeamCity](https://www.jetbrains.com/teamcity/)
6. [CircleCI](https://circleci.com/)
7. [Github Actions](https://docs.github.com/en/actions)
8. [Docker](https://www.docker.com/)
9. [Kubernetes](https://kubernetes.io/)
10. [Terraform](https://www.terraform.io/)
11. [Ansible](https://www.ansible.com/)
12. [Continuous integration with Docker, Docker](https://docs.docker.com/build/ci/)
13. [Introduction to GitHub Actions, Docker](https://docs.docker.com/build/ci/github-actions/)
14. [MaxRokatansky, Что такое CI/CD? Разбираемся с непрерывной интеграцией и непрерывной поставкой, Habr.com](https://habr.com/ru/companies/otus/articles/515078/)
15. [Что такое непрерывная поставка?, Microsoft](https://learn.microsoft.com/ru-ru/devops/deliver/what-is-continuous-delivery)
