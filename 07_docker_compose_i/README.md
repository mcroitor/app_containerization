# Создание кластера контейнеров при помощи Docker Compose

- [Создание кластера контейнеров при помощи Docker Compose](#создание-кластера-контейнеров-при-помощи-docker-compose)
  - [Цель Docker Compose](#цель-docker-compose)
  - [Синтаксис docker-compose.yml](#синтаксис-docker-composeyml)
    - [Описание сервиса](#описание-сервиса)
    - [Описание тома](#описание-тома)
    - [Описание сети](#описание-сети)
    - [Описание конфигурации](#описание-конфигурации)
    - [Описание секрета](#описание-секрета)
  - [Пример кластера](#пример-кластера)
  - [Управление кластером контейнеров](#управление-кластером-контейнеров)
  - [Библиография](#библиография)

## Цель Docker Compose

Docker Compose это инструментальное средство, входящее в состав Docker и предназначенное для управления кластером контейнеров. Оно позволяет описать конфигурацию кластера контейнеров в файле `docker-compose.yml` и управлять этим кластером при помощи командной строки.

Обычно, при создании составного приложения, сложно обойтись одним только контейнером по ряду причин. Если рассматривать приложение Web, то оно состоит из нескольких независимых, но взаимодействующих между собой компонентов: веб-сервер, база данных, кэш, очередь сообщений и т.д. Включение всех этих компонент в один контейнер является неэффективным, потому что это приводит к следующим проблемам:

- Разработка каждой компоненты не может вестись разными командами.
- Каждый компонент не может быть масштабирован независимо от других.
- Каждый компонент не может быть обновлен независимо от других.
- Каждый компонент не может быть заменен независимо от других.

Каждый из этих компонентов (веб-сервер, база данных, кэш, очередь сообщений и т.д) может быть представлен отдельным контейнером, что позволяет работать с каждой частью приложения независимо. Docker Compose позволяет описать конфигурацию всех этих контейнеров в одном файле `docker-compose.yml` и управлять ими при помощи командной строки.

## Синтаксис docker-compose.yml

Файл `docker-compose.yml` представляет собой YAML-файл, в котором описывается конфигурация кластера контейнеров. Общая структура `docker-compose.yml` является следующей:

```yaml
# docker compose файл должен начинаться с версии. В данном случае это версия 3 - самая свежая на момент написания статьи.
version: '3'

# Далее идет список сервисов, которые будут запущены в кластере контейнеров.
# Каждый сервис представляет собой отдельный контейнер.
# Сервисом может быть веб-сервер, база данных, кэш, очередь сообщений и т.д.
# Раздел, описывающий сервисы, начинается с ключевого слова services:
services:
    # описание каждого сервиса начинается с его имени, которое может быть произвольным.
    <service1-name>:
        # описание сервиса
        # ...
    <service2-name>:
        # описание сервиса
        # ...
    # ...

# Далее идет список томов, которые будут использованы в кластере контейнеров.
volumes:
    # описание каждого тома начинается с его имени, которое может быть произвольным.
    <volume1-name>:
        # описание тома
        # ...
    <volume2-name>:
        # описание тома
        # ...
    # ...

# Далее идет список сетей, которые будут использованы в кластере контейнеров.
networks:
    # описание каждой сети начинается с ее имени, которое может быть произвольным.
    <network1-name>:
        # описание сети
        # ...
    <network2-name>:
        # описание сети
        # ...
    # ...

# Далее идет список конфигураций, которые будут использованы в кластере контейнеров.
configs:
    # описание каждой конфигурации начинается с ее имени, которое может быть произвольным.
    <config1-name>:
        # описание конфигурации
        # ...
    <config2-name>:
        # описание конфигурации
        # ...
    # ...

# Далее идет список секретов, которые будут использованы в кластере контейнеров.
secrets:
    # описание каждого секрета начинается с его имени, которое может быть произвольным.
    <secret1-name>:
        # описание секрета
        # ...
    <secret2-name>:
        # описание секрета
        # ...
    # ...
```

В стандартном описании кластера контейнеров в файле `docker-compose.yml` обязательно должен присутствовать раздел `services`, в котором описываются сервисы, представляющие собой контейнеры. Остальные разделы (`volumes`, `networks`, `configs`, `secrets`) являются опциональными и используются для описания томов, сетей, конфигураций и секретов соответственно.

### Описание сервиса

Раздел `services` содержит список сервисов, каждый из которых представляет собой отдельный контейнер. Описание сервиса содержит следующие ключи:

- `image` - имя образа контейнера, который будет использован для создания сервиса.
- `build` - путь к каталогу, содержащему Dockerfile, который будет использован для создания образа контейнера, который будет использован для создания сервиса.
- `ports` - список портов, которые будут проброшены из контейнера на хост.
- `volumes` - список томов, которые будут использованы в контейнере.
- `networks` - список сетей, которые будут использованы в контейнере.
- `configs` - список конфигураций, которые будут использованы в контейнере.
- `secrets` - список секретов, которые будут использованы в контейнере.
- `environment` - список переменных окружения, которые будут установлены в контейнере.
- `command` - команда, которая будет выполнена при запуске контейнера.
- `entrypoint` - команда, которая будет выполнена при запуске контейнера.
- `depends_on` - список сервисов, от которых зависит данный сервис.

Пример описания сервиса:

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

### Описание тома

Раздел `volumes` содержит список томов, которые будут использованы в кластере контейнеров. Описание тома содержит следующие ключи:

- `driver` - драйвер, который будет использован для создания тома.
- `driver_opts` - опции драйвера, которые будут использованы для создания тома.
- `external` - имя внешнего тома, который будет использован в кластере контейнеров.
- `labels` - список меток, которые будут установлены для тома.
- `name` - имя тома.

Пример описания тома:

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

### Описание сети

Раздел `networks` содержит список сетей, которые будут использованы в кластере контейнеров. Описание сети содержит следующие ключи:

- `driver` - драйвер, который будет использован для создания сети.
- `driver_opts` - опции драйвера, которые будут использованы для создания сети.
- `external` - имя внешней сети, которая будет использована в кластере контейнеров.
- `attachable` - флаг, который указывает, что контейнеры могут присоединяться к сети.
- `internal` - флаг, который указывает, что сеть является внутренней сетью.
- `labels` - список меток, которые будут установлены для сети.
- `name` - имя сети.
- `enable_ipv6` - флаг, который указывает, что сеть поддерживает IPv6.
- `ipam` - параметры IPAM для сети.

Пример описания сети:

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

### Описание конфигурации

Раздел `configs` содержит список конфигураций, которые будут использованы в кластере контейнеров. Описание конфигурации содержит следующие ключи:

- `file` - путь к файлу, который будет использован для создания конфигурации.
- `environment` - список переменных окружения, которые будут установлены для конфигурации.
- `external` - имя внешней конфигурации, которая будет использована в кластере контейнеров.
- `name` - имя конфигурации.
- `content` - конфигурация создается на базе содержимого.

Пример описания конфигурации:

```yaml
configs:
    nginx.conf:
        file: /path/to/nginx.conf
    php.ini:
        file: /path/to/php.ini
```

### Описание секрета

Раздел `secrets` содержит список секретов (паролей, приватных ключей, сертификатов), которые будут использованы в кластере контейнеров. Описание секрета содержит следующие ключи:

- `file` - путь к файлу, который будет использован для создания секрета.
- `environment` - секрет создаётся на базе переменной окружения.

Пример описания секрета:

```yaml
secrets:
    db_password:
        environment: DB_PASSWORD
    db_user:
        environment: DB_USER
    certificate:
        file: ./certificate.pem
```

## Пример кластера

Следующий пример показывает описание сервисного приложения, состоящего из сервисов:

- `nginx` - веб-сервер, который обслуживает статические файлы и перенаправляет запросы к приложению.
- `php-fpm` - интерпретатор PHP, который обрабатывает динамические запросы.
- `mariadb` - сервер базы данных, который хранит данные приложения.

Сайт располагается в монтируемой к контейнерам `nginx` и `php-fpm` директории `./files/app`, а база данных в монтируемой к контейнеру `mariadb` директории `./mounts/db`.

Контейнер `nginx` пробрасывает порт 8080 на порт 80 контейнера, а контейнер `php-fpm` использует порт 9000. Контейнер `nginx` подключен к сетям `frontend` и `backend`, а контейнеры `mariadb` и `php-fpm` к сети `backend`.

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

## Управление кластером контейнеров

Файл `docker-compose.yaml` описывает сервисы приложения и взаимодействия между ними. Чтобы построить контейнеры сервисов, определить инфраструктуру, необходимо выполнить команду

```bash
docker-compose build
```

Чтобы запустить контейнеры сервисов, необходимо выполнить команду

```bash
docker-compose up -d
```

Ключ `-d` означает, что контейнеры будут запущены в фоновом режиме.

Чтобы остановить контейнеры сервисов, необходимо выполнить команду

```bash
docker-compose down
```

Иногда возникает необходимость перестроить полностью контейнеры сервисов. Для этого необходимо выполнить команду

```bash
docker-compose build --no-cache
```

Немаловажным свойством является просмотр журналов контейнеров сервисов. Для этого необходимо выполнить команду

```bash
docker-compose logs -f <service-name>
```

Наконец, для выполнения некоторой команды `command` внутри контейнера сервиса необходимо выполнить команду

```bash
docker-compose exec <service-name> <command>
```

## Библиография

1. [YAML Ain’t Markup Language (YAML™) version 1.2, yaml.org, 2021-10-01](https://yaml.org/spec/1.2.2/)
2. [Шпаргалка по YAML](../additional/yaml.md)
3. [Docker Compose overview, docs.docker.com](https://docs.docker.com/compose/)
4. [Gaël Thomas, A beginner’s guide to Docker — how to create a client/server side with docker-compose, https://www.freecodecamp.org](https://www.freecodecamp.org/news/a-beginners-guide-to-docker-how-to-create-a-client-server-side-with-docker-compose-12c8cf0ae0aa)
5. [Gaël Thomas, Руководство по Docker Compose для начинающих, перевод статьи https://www.freecodecamp.org, habr.com](https://habr.com/ru/companies/ruvds/articles/450312/)