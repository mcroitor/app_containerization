# Взаимодействие контейнеров

- [Взаимодействие контейнеров](#взаимодействие-контейнеров)
  - [Файловая система](#файловая-система)
    - [Работа с томами](#работа-с-томами)
    - [Прикрепление тома к контейнеру](#прикрепление-тома-к-контейнеру)
    - [Пример](#пример)
  - [Сеть](#сеть)
    - [Управление сетями в Docker](#управление-сетями-в-docker)
    - [Запуск контейнеров в сети](#запуск-контейнеров-в-сети)
  - [Библиография](#библиография)

Сложные информационные системы являются обычно многокомпонентными. Каждый компонент может быть разработан и поддерживаться отдельной командой. В таких случаях важно обеспечить взаимодействие между компонентами.

Взаимодействие контейнеров может быть реализовано через сеть или файловую систему.

## Файловая система

Два контейнера могут взаимодействовать через файловую систему, если они монтируют один и тот же том. Например, контейнер `A` может записать файл в том, а контейнер `B` может прочитать этот файл. В этом случае контейнеры могут взаимодействовать между собой, даже если они запущены на разных сетях.

### Работа с томами

Томы в Docker представляют собой механизм для хранения данных, который может быть использован несколькими контейнерами. Томы могут быть созданы, просмотрены, удалены и прикреплены к контейнеру.

Для работы с томами используются следующие команды:

- `docker volume create <VOLUME>` - создание тома с именем `<VOLUME>`
- `docker volume ls` - просмотр списка томов
- `docker volume rm <VOLUME>` - удаление тома с именем `<VOLUME>`
- `docker volume inspect <VOLUME>` - просмотр информации о томе с именем `<VOLUME>`
- `docker volume prune` - удаление всех неиспользуемых томов

### Прикрепление тома к контейнеру

Для прикрепления тома к контейнеру используется опция `-v` команды `docker run`. Например, чтобы прикрепить том с именем `opt` к контейнеру `mycontainer`, используется следующая команда:

```bash
docker run -v opt:/opt --name mycontainer myimage
```

В этом случае том `opt` будет доступен в контейнере `mycontainer` по пути `/opt`.

### Пример

Рассмотрим пример, в котором один контейнер пишет каждые 5 секунд случайное число в файл, а другой контейнер читает этот файл и выводит его содержимое в консоль. Для пишущего контейнера `dockerfile.write` выглядит следующим образом:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do shuf -i1-10 -n1 > /opt/data.txt; sleep ${TIMEOUT}; done"]
```

Для читающего контейнера `dockerfile.read` выглядит следующим образом:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do cat opt/data.txt; sleep ${TIMEOUT}; done"]
```

Сначала создадим общий том `opt`:

```bash
docker volume create opt
```

Теперь соберем оба образа:

```bash
docker build -t read -f dockerfile.read .
docker build -t write -f dockerfile.write .
```

Запустим контейнеры:

```bash
docker run -d -v opt:/opt --name write write
docker run -d -v opt:/opt --name read read
```

## Сеть

Два контейнера могут взаимодействовать через сеть. В Docker сеть представляет собой механизм для связи контейнеров между собой. Сети могут быть созданы, просмотрены, удалены и контейнеры могут быть подключены к сети.

### Управление сетями в Docker

Для работы с сетями используются следующие команды:

- `docker network create <NETWORK>` - создание сети с именем `<NETWORK>`
- `docker network ls` - просмотр списка сетей
- `docker network rm <NETWORK>` - удаление сети с именем `<NETWORK>`
- `docker network inspect <NETWORK>` - просмотр информации о сети с именем `<NETWORK>`
- `docker network connect <NETWORK> <CONTAINER>` - подключение контейнера с именем `<CONTAINER>` к сети с именем `<NETWORK>`
- `docker network disconnect <NETWORK> <CONTAINER>` - отключение контейнера с именем `<CONTAINER>` от сети с именем `<NETWORK>`
- `docker network prune` - удаление всех неиспользуемых сетей

### Запуск контейнеров в сети

Существует две возможности запуска контейнеров в сети:

- подключение контейнера к сети после его запуска;
- подключение контейнера к сети при его запуске.

В первом случае используется команда `docker network connect`, во втором - опция `--network` команды `docker run`.

Пусть существует два контейнера `frontend` и `backend`, для того чтобы они работали в одной сети `local`, необходимо:

- создать сеть `local`;
- запустить контейнер `backend` в сети `local`;
- запустить контейнер `frontend` в сети `local`.

```bash
docker network create local
docker run -d --name backend --network local backend
docker run -d --name frontend --network local frontend
```

## Библиография

1. [Швалов А., Хранение данных в Docker, Слерм](https://slurm.io/blog/tpost/i5ikrm9fj1-hranenie-dannih-v-docker)
2. [Docker Networking, Docker](https://docs.docker.com/network/)
3. [Docker Volumes, Docker](https://docs.docker.com/storage/volumes/)