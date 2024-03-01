# Лабораторная работа №4: Запуск сайта в контейнере

## Цель работы

Выполнив данную работу студент сможет подготовить образ контейнера для запуска веб-сайта на базе Apache HTTP Server + PHP (mod_php) + MariaDB.

## Задание

Создать Dockerfile для сборки образа контейнера, который будет содержать веб-сайт на базе Apache HTTP Server + PHP (mod_php) + MariaDB. База данных MariaDB должна храниться в монтруемом томе. Сервер должен быть доступен по порту 8000.

Установить сайт WordPress. Проверить работоспособность сайта.

## Подготовка

Для выполнения данной работы необходимо иметь установленный на компьютере [Docker](https://www.docker.com/).

Для выполняния работы необходимо иметь опыт выполнения лабораторной работы №3.

## Выполнение

Создайте репозиторий `containers04` и склонируйте его себе на компьютер.

### извлечение конфигурационных файлов apache2, php, mariadb из контейнера

Создайте в папке `containers04` папку `files`, а также

- папку `files/apache2` - для файлов конфигурации apache2;
- папку `files/php` - для файлов конфигурации php;
- папку `files/mariadb` - для файлов конфигурации mariadb.

Создайте в папке `containers04` файл `Dockerfile` со следующим содержимым:

```Dockerfile
# create from debian image
FROM debian:latest

# install apache2, php, mod_php for apache2, php-mysql and mariadb
RUN apt-get update && \
    apt-get install -y apache2 php libapache2-mod-php php-mysql mariadb-server && \
    apt-get clean
```

Постройте образ контейнера с именем `apache2-php-mariadb`.

Создайте контейнер `apache2-php-mariadb` из образа `apache2-php-mariadb` и запустите его в фоновом режиме с командой запуска `bash`.

Скопируйте из контейнера файлы конфигурации apache2, php, mariadb в папку `containers04/files/` на компьютере. Для этого, в контексте проекта, выполните команды:

```bash
docker cp apache2-php-mysql:/etc/apache2/sites-available/000-default.conf files/apache2/
docker cp apache2-php-mysql:/etc/php/8.2/apache2/php.ini files/php/
docker cp apache2-php-mysql:/etc/mysql/mariadb.conf.d/50-server.cnf files/mariadb/
```

После выполнения команд в папке `containers04/files/` должны появиться файлы конфигурации apache2, php, mariadb. Проверьте их наличие. Остановите и удалите контейнер `apache2-php-mariadb`.

### Настройка конфигурационных файлов

#### Конфигурационный файл apache2

Откройте файл `files/apache2/000-default.conf`, найдите строку `#ServerName www.example.com` и замените её на `ServerName localhost`.

Найдите строку `ServerAdmin webmaster@localhost` и замените в ней почтовый адрес на свой.

Сохраните файл и закройте.

#### Конфигурационный файл php

Откройте файл `files/php/php.ini`, найдите строку `;error_log = php_errors.log` и замените её на `error_log = /var/log/php_errors.log`.

Настройте параметры `memory_limit`, `upload_max_filesize`, `post_max_size` и `max_execution_time` следующим образом:

```ini
memory_limit = 128M
upload_max_filesize = 128M
post_max_size = 128M
max_execution_time = 120
```

Сохраните файл и закройте.

#### Конфигурационный файл mariadb

Откройте файл `files/mariadb/50-server.cnf`, найдите строку `#log_error = /var/log/mysql/error.log` и раскомментируйте её.

Сохраните файл и закройте.

### Создание Dockerfile

Откройте файл `Dockerfile` и добавьте в него следующие строки:

### Создание отчета

Создайте в папке `containers04` файл `README.md` который содержать пошаговое выполнение проекта. Описание проекта должно содержать:

1. Название лабораторной работы.
2. Цель работы.
3. Задание.
4. Описание выполнения работы с ответами на вопросы.
5. Выводы.

Для каждой команды объясните её назначение, результат выполнения и вывод в консоли. Желательно привести скриншоты.

Выложите проект на GitHub.

## Запуск и тестирование

## Представление

При представлении ответа прикрепите к заданию ссылку на репозиторий.

## Оценивание
