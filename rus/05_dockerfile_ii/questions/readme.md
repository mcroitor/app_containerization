# Вопросы по теме "Дополнительные директивы Dockerfile"

1. Чтобы задать переменную окружения в образе контейнера, используется директива
    - [x] `ENV`
    - [ ] `ARG`
    - [ ] `VAR`
    - [ ] `VARIABLE`
2. Для задания аргумента сборки, который можно использовать во время сборки образа, используется директива
    - [x] `ARG`
    - [ ] `ENV`
    - [ ] `BUILD_ARG`
    - [ ] `VAR`
3. Чтобы открыть порт контейнера, используется директива
    - [x] `EXPOSE`
    - [ ] `PORT`
    - [ ] `OPEN`
    - [ ] `PUBLISH`
4. Для указания точки монтирования тома в контейнере используется директива
    - [x] `VOLUME`
    - [ ] `MOUNT`
    - [ ] `MOUNTPOINT`
    - [ ] `MOUNTVOLUME`
5. Метаданные образа можно задать с помощью директивы
    - [x] `LABEL`
    - [ ] `META`
    - [ ] `METADATA`
    - [ ] `COMMENT`
6. Сменить командную оболочку по умолчанию в образе можно с помощью директивы
    - [x] `SHELL`
    - [ ] `CMD`
    - [ ] `SH`
    - [ ] `BASH`
7. Проверить работу образа можно с помощью директивы
    - [x] `HEALTHCHECK`
    - [ ] `CHECK`
    - [ ] `TEST`
    - [ ] `VERIFY`
8. Задать аргумент `DEBIAN_VERSION` сборки в Dockerfile можно следующим образом:
    - [x] `ARG DEBIAN_VERSION`
    - [ ] `ENV DEBIAN_VERSION`
    - [ ] `VAR DEBIAN_VERSION`
    - [ ] `SET DEBIAN_VERSION`
9. Задать переменную окружения `DEBIAN_VERSION` в Dockerfile можно следующим образом:
    - [x] `ENV DEBIAN_VERSION`
    - [ ] `ARG DEBIAN_VERSION`
    - [ ] `VAR DEBIAN_VERSION`
    - [ ] `SET DEBIAN_VERSION`
10. Определить аргумент сборки `DEBIAN_VERSION` со значением `10` при сборке образа `myimage`, нужно использовать команду:
    - [x] `docker build --build-arg DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build -e DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build --arg DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build --build-env DEBIAN_VERSION=10 -t myimage .`

Вопросы типа _"короткий ответ"_:

1. Чтобы задать аргумент сборки `UBUNTU_VERSION` со значением `20.04`, нужно добавить в Dockerfile следующую строку:
    - `ARG UBUNTU_VERSION=20.04`
2. Чтобы задать аргумент сборки `APP_DIR` со значением `/usr/src/app`, нужно добавить в Dockerfile следующую строку:
    - `ARG APP_DIR=/usr/src/app`
3. Чтобы задать переменную окружения `APP_DIR` со значением `/usr/src/app`, нужно добавить в Dockerfile следующую строку:
    - `ENV APP_DIR=/usr/src/app`
4. Чтобы задать переменную окружения `UBUNTU_VERSION` со значением `20.04`, нужно добавить в Dockerfile следующую строку:
    - `ENV UBUNTU_VERSION=20.04`
5. Чтобы определить аргумент сборки `UBUNTU_VERSION` со значением `20.04` при сборке образа `myimage`, нужно использовать команду:
    - `docker build --build-arg UBUNTU_VERSION=20.04 -t myimage .`
    - `docker build -t myimage --build-arg UBUNTU_VERSION=20.04 .`
6. Чтобы определить аргумент сборки `APP_DIR` со значением `/usr/src/app` при сборке образа `myimage`, нужно использовать команду:
    - `docker build --build-arg APP_DIR=/usr/src/app -t myimage .`
    - `docker build -t myimage --build-arg APP_DIR=/usr/src/app .`
7. В Dockerfile определена переменная окружения `UBUNTU_VERSION`. Напишите директиву, которая выведет значение этой переменной во время сборки образа в файл `/version.txt`.
    - `RUN echo $UBUNTU_VERSION > /version.txt`
    - `RUN echo "$UBUNTU_VERSION" > /version.txt`
    - `RUN echo ${UBUNTU_VERSION} > /version.txt`
8. В Dockerfile определён аргумент сборки `UBUNTU_VERSION`. Напишите директиву, которая определит переменную окружения `UBUNTU_VERSION` со значением аргумента сборки.
    - `ENV UBUNTU_VERSION=$UBUNTU_VERSION`
    - `ENV UBUNTU_VERSION=${UBUNTU_VERSION}`
    - `ENV UBUNTU_VERSION="$UBUNTU_VERSION"`
9. В Dockerfile определён аргумент сборки `UBUNTU_VERSION`. Напишите директиву, которая определяет создание образа на базе образа `ubuntu` с использованием аргумента сборки `UBUNTU_VERSION`.
    - `FROM ubuntu:$UBUNTU_VERSION`
    - `FROM ubuntu:${UBUNTU_VERSION}`
10. Чтобы открыть порт `80` в контейнере, нужно добавить в Dockerfile следующую строку:
    - `EXPOSE 80`
11. Чтобы открыть порт `8080` в контейнере, нужно добавить в Dockerfile следующую строку:
    - `EXPOSE 8080`
12. Чтобы пробросить порт `80` контейнера на порт `8080` хоста при создании и запуске контейнера с образом `myimage`, нужно использовать команду:
    - `docker run -p 8080:80 myimage`
13. Чтобы определить точку монтирования тома к каталогу `/data` в контейнере, нужно добавить в Dockerfile следующую строку:
    - `VOLUME /data`
14. Чтобы определить точку монтирования тома к каталогу `/var/lib/mysql` в контейнере, нужно добавить в Dockerfile следующую строку:
    - `VOLUME /var/lib/mysql`
15. Чтобы задать метаданные образа `maintainer` со значением `Gicu Stirbu`, нужно добавить в Dockerfile следующую строку:
    - `LABEL maintainer="Gicu Stirbu"`
    - `LABEL maintainer=Gicu Stirbu`
16. Чтобы задать метаданные образа `version` со значением `1.0`, нужно добавить в Dockerfile следующую строку:
    - `LABEL version="1.0"`
    - `LABEL version=1.0`
