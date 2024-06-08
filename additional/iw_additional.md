# Individual Work: Server Maintenance

The goal of this work is to learn how to maintain Web servers running in containers.

> In production, creating backups is often done with specialized tools, but in this work, the task manager __cron__ is considered.

> To facilitate the collection of logs, the standard practice is to redirect logs to the standard streams __STDOUT__ and __STDERR__.

## Task

Create a cluster of containers that will host the CMS Wordpress. The cluster should include the following containers:

1. Apache HTTP Server with the ability to process PHP scripts.
2. PHP-FPM container.
3. MariaDB container.
4. Cron container.

The Apache HTTP Server container should be configured to redirect PHP requests to the PHP-FPM container. The PHP-FPM container should be configured to work with the MariaDB container.

The Cron container should be configured to perform the following tasks:

1. Every 24 hours, create a backup of the CMS database.
2. Every Monday, create a backup of the CMS directory.
3. Every 24 hours, delete backups that were created 30 days ago.
4. Every minute, write the message _alive, \<username\>_ to the log.

The cluster should be configured to store backups in the `./backups/` directory. The site should be stored in the `./site/wordpress/` directory.

## Preparation

Check that you have _Docker Desktop_ installed and running.

Create a folder `additional`. All work will be done in it. Create folders `database` - for the database, `files` - for storing configurations, and `site` - the site will be located in this folder.

The Individual Work is done with an Internet connection, as images are downloaded from the [Docker Hub](https://hub.docker.com).

## Execution

Download [CMS Wordpress](https://wordpress.org/) and unpack it into the `site` folder. You should have a folder `wordpress` with the source code of the site in the `site` folder.

### Apache HTTP Server Container

First, create a configuration file for the Apache HTTP Server. To do this, run the following commands in the console:

```shell
# download the httpd image and run a container named httpd
docker run -d --name httpd  httpd:2.4

# copy the configuration file from the container to the .\files\httpd folder
docker cp httpd:/usr/local/apache2/conf/httpd.conf .\files\httpd\httpd.conf

# stop the httpd container
docker stop httpd

# remove the container
docker rm httpd
```

In the created file `.\files\httpd\httpd.conf`, uncomment the lines containing the connection of the extensions `mod_proxy.so`, `mod_proxy_http.so`, `mod_proxy_fcgi.so`.

Find the declaration of the parameter `ServerName` in the configuration file. Under it, add the following lines:

```ini
# define the domain name of the site
ServerName wordpress.localhost:80
# redirect php requests to the php-fpm container
ProxyPassMatch ^/(.*\.php(/.*)?)$ fcgi://php-fpm:9000/var/www/html/$1
# index file
DirectoryIndex /index.php index.php
```

Also, find the definition of the `DocumentRoot` parameter and set its value to `/var/www/html`, as in the following line.

Create a file `Dockerfile.httpd` with the following content:

```dockerfile
FROM httpd:2.4

RUN apt update && apt upgrade -y

COPY ./files/httpd/httpd.conf /usr/local/apache2/conf/httpd.conf
```

Details of working with the _httpd_ container can be found here: [HTTPD Container](https://hub.docker.com/_/httpd).

### PHP-FPM Container

Create a file `Dockerfile.php-fpm` with the following content:

```dockerfile
FROM php:7.4-fpm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure pdo_mysql \
    && docker-php-ext-install -j$(nproc) gd mysqli
```

Details of working with the _php_ container can be found here: [PHP Container](https://hub.docker.com/_/php).

### MariaDB Container

Create a file `Dockerfile.mariadb` with the following content:

```dockerfile
FROM mariadb:10.8

RUN apt-get update && apt-get upgrade -y
```

Details of working with the _mariadb_ container can be found here: [MariaDB Container](https://hub.docker.com/_/mariadb).

### Solution assembly

Create a file `docker-compose.yml` with the following content:

```yaml
services:
  httpd:
    build:
      context: ./
      dockerfile: Dockerfile.httpd
    networks:
      - internal
    ports:
      - "80:80"
    volumes:
      - "./site/wordpress/:/var/www/html/"
  php-fpm:
    build:
      context: ./
      dockerfile: Dockerfile.php-fpm
    networks:
      - internal
    volumes:
      - "./site/wordpress/:/var/www/html/"
  mariadb:
    build: 
      context: ./
      dockerfile: Dockerfile.mariadb
    networks:
      - internal
    environment:
     MARIADB_DATABASE: sample
     MARIADB_USER: sampleuser
     MARIADB_PASSWORD: samplepassword
     MARIADB_ROOT_PASSWORD: rootpassword
    volumes:
      - "./database/:/var/lib/mysql"
networks:
  internal: {}
```

This file declares a structure of three containers: http as the entry point, php-fpm container, and database container. To interact between containers, a network `internal` is also declared with default settings.

### Cron service

For backup, we will use the _cron_ container, which:

1. every 24 hours creates a backup of the CMS database;
2. every Monday creates a backup of the CMS directory;
3. every 24 hours deletes backups that were created 30 days ago;
4. every minute writes the message _alive, \<username\>_ to the log.

To do this, create a folder `./files/cron`. In the `./files/cron/` folder, create a folder `scripts`. In the root directory, create a folder `backups`, and in it `mysql`, `site`.

#### Status message

In the `./files/cron/scripts/` folder, create a file `01_alive.sh` with the following content:

```shell
#!/bin/sh

echo "alive ${USERNAME}" > /proc/1/fd/1
```

This script outputs the message `alive ${USERNAME}`.

#### Site backup

In the `./files/cron/scripts/` folder, create a file `02_backupsite.sh` with the following content:

```shell
#!/bin/sh

echo "[backup] create site backup" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
tar czfv /var/backups/site/www_$(date +\%Y\%m\%d).tar.gz /var/www/html
echo "[backup] site backup done" \
    >/proc/1/fd/1 \
    2> /proc/1/fd/2
```

This script archives the `/var/www/html` folder and saves the archive to `/var/backups/site/`.

#### Database backup

In the `./files/cron/scripts/` folder, create a file `03_mysqldump.sh` with the following content:

```shell
#!/bin/sh

echo "[backup] create mysql dump of ${MARIADB_DATABASE} database" \
    > /proc/1/fd/1
mysqldump -u ${MARIADB_USER} --password=${MARIADB_PASSWORD} -v -h mariadb ${MARIADB_DATABASE} \
    | gzip -c > /var/backups/mysql/${MARIADB_DATABASE}_$(date +\%F_\%T).sql.gz 2> /proc/1/fd/1
echo "[backup] sql dump created" \
    > /proc/1/fd/1
```

#### Deleting old files

In the `./files/cron/scripts/` folder, create a file `04_clean.sh` with the following content:

```shell
#!/bin/sh

echo "[backup] remove old backups" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
find /var/backups/mysql -type f -mtime +30 -delete \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
find /var/backups/site -type f -mtime +30 -delete \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
echo "[backup] done" \
    > /proc/1/fd/1 \
    2> /proc/1/fd/2
```

#### Cron preparation

In the `./files/cron/scripts/` folder, create a file `environment.sh` with the following content:

```shell
#!/bin/sh

env >> /etc/environment

# execute CMD
echo "Start cron" >/proc/1/fd/1 2>/proc/1/fd/2
echo "$@"
exec "$@"
```

In the `./files/cron/` folder, create a file `crontab` with the following content:

```crontab
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed
  *  *  *  *  * /scripts/01_alive.sh > /dev/null
  *  *  *  *  * /scripts/02_backupsite.sh > /dev/null
  *  *  *  *  * /scripts/03_mysqldump.sh > /dev/null
  *  *  *  *  * /scripts/04_clean.sh > /dev/null
# Don't remove the empty line at the end of this file. It is required to run the cron job
```

#### Creating a cron container

Create a file `Dockerfile.cron` in the root directory with the following content:

```dockerfile
FROM debian:latest

RUN apt update && apt -y upgrade && apt install -y cron mariadb-client

COPY ./files/cron/crontab /etc/cron.d/crontab
COPY ./files/cron/scripts/ /scripts/

RUN crontab /etc/cron.d/crontab

ENTRYPOINT [ "/scripts/environment.sh" ]
CMD [ "cron", "-f" ]
```

Edit the `docker-compose.yml` file, adding the following lines after the definition of the `mariadb` service:

```yaml
  cron:
    build:
      context: ./
      dockerfile: Dockerfile.cron
    environment:
      USERNAME: <firstname lastname>
      MARIADB_DATABASE: sample
      MARIADB_USER: sampleuser
      MARIADB_PASSWORD: samplepassword
    volumes:
      - "./backups/:/var/backups/"
      - "./site/wordpress/:/var/www/html/"
    networks:
      - internal
```

Replace `<firstname lastname>` with your name and surname.

#### Log rotation

Please note that the container assembly based on containers outputs logs not to files, but to the standard output stream.

Check by analyzing the file `./files/httpd/httpd.conf` where the general-purpose log of the Apache HTTP Server is output? And the error log?

### Launch and testing

In the folder of the laboratory work, open the console and run the command:

```shell
docker-compose build
```

Based on the created definitions, Docker will build service images. _How many seconds did the project build?_

Run the command:

```shell
docker-compose up -d
```

Based on the images, containers will start. Open the page in the browser: http://wordpress.localhost and install the site. __Note that the containers see each other by name, so when installing the site, you need to specify the database server host name equal to the container name, that is, `mariadb`__. The database user name, its password, and the database name are taken from the `docker-compose.yml` file.

Check the logs of each container. To do this, run the command:

```shell
docker logs <container name>
```

For example, for the created _cron_ container, logs can be read with the following command:

```shell
docker logs additional-cron-1
```

Stop the containers and remove them:

```shell
# stop the containers
docker-compose down
# remove the containers
docker-compose rm
```

Check if the site is available at http://wordpress.localhost. Run the container cluster again:

```shell
docker-compose up -d
```

and check the site's operability.

Wait 2-3 minutes and check what is in the `./backups/mysql/` and `./backups/site/` folders.

Stop the containers and correct the `./files/cron/crontab` file so that

1. every day at 1:00 a backup of the CMS database is created;
2. every Monday a backup of the CMS directory is created;
3. every day at 2:00 backups created 30 days ago are deleted.

## Report

Provide a report on the work done.

Answer the questions:

1. Why is it necessary to create a system user for each site?
2. What is the purpose of the `chown` command?
3. What does the command `chmod -R 0755 /home/www/anydir` mean?
4. What does the command `find /var/backups/mysql -type f -mtime +30 -delete` do?
5. What does the command `echo "alive ${USERNAME}" > /proc/1/fd/1` do?
