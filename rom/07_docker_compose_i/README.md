# Crearea unui cluster de containere cu ajutorul Docker Compose

- [Crearea unui cluster de containere cu ajutorul Docker Compose](#crearea-unui-cluster-de-containere-cu-ajutorul-docker-compose)
  - [Scopul Docker Compose](#scopul-docker-compose)
  - [Sintaxa docker-compose.yml](#sintaxa-docker-composeyml)
    - [Descrierea serviciului](#descrierea-serviciului)
    - [Descrierea volumului](#descrierea-volumului)
    - [Descrierea rețelei](#descrierea-rețelei)
    - [Descrierea configurației](#descrierea-configurației)
    - [Descrierea secretului](#descrierea-secretului)
  - [Un exemplu de cluster](#un-exemplu-de-cluster)
  - [Gestionarea clusterului de containere](#gestionarea-clusterului-de-containere)
  - [Bibliografie](#bibliografie)

## Scopul Docker Compose

Docker Compose este un instrument care face parte din Docker și este destinat gestionării unui cluster de containere. Acesta permite să descrieți configurația clusterului de containere în fișierul `docker-compose.yml` și să-l gestionați prin intermediul liniei de comandă.

De obicei este dificil să creați o aplicație compusă dintr-un singur container din mai multe motive. Dacă luăm în considerare o aplicație Web, aceasta constă din mai multe componente independente, dar care interacționează între ele: serverul Web, baza de date, cache-ul, coada de mesaje etc. Includerea tuturor acestor componente într-un singur container este ineficientă, deoarece aceasta duce la următoarele probleme:

- Dezvoltarea fiecărei componente nu poate fi realizată de echipe diferite.
- Fiecare componentă nu poate fi scalată independent de celelalte.
- Fiecare componentă nu poate fi actualizată independent de celelalte.
- Fiecare componentă nu poate fi înlocuită independent de celelalte.
- 
- Разработка каждой компоненты не может вестись разными командами.
- Каждый компонент не может быть масштабирован независимо от других.
- Каждый компонент не может быть обновлен независимо от других.
- Каждый компонент не может быть заменен независимо от других.

## Sintaxa docker-compose.yml

Fișierul `docker-compose.yml` este un fișier YAML care descrie configurația clusterului de containere. Structura generală a `docker-compose.yml` este următoarea:

```yaml
# docker compose fișierul trebuie să înceapă cu versiunea. În acest caz este versiunea 3 - cea mai recentă la momentul scrierii articolului.
version: '3'

# Următoarea secțiune descrie serviciile care vor fi pornite în clusterul de containere.
# Fiecare serviciu reprezintă un container separat.
# Serviciul poate fi un server web, o bază de date, un cache, o coadă de mesaje etc.
# Serviciile sunt descrise în secțiunea services.
services:
    # descrierea fiecărui serviciu începe cu numele său, care poate fi orice.
    <service1-name>:
        # descrierea serviciului
        # ...
    <service2-name>:
        # descrierea serviciului
        # ...
    # ...

# Urmează lista volumelor care vor fi utilizate în clusterul de containere.
volumes:
    #fiecare volum începe cu numele său, care poate fi orice.
    <volume1-name>:
        # descrierea volumului
        # ...
    <volume2-name>:
        # descrierea volumului
        # ...
    # ...

# Urmează lista rețelelor care vor fi utilizate în clusterul de containere.
networks:
    # descrierea fiecărei rețele începe cu numele său, care poate fi orice.
    <network1-name>:
        # descrierea rețelei
        # ...
    <network2-name>:
        # descrierea rețelei
        # ...
    # ...

# Urmează lista configurațiilor care vor fi utilizate în clusterul de containere.
configs:
    # descrierea fiecărei configurații începe cu numele său, care poate fi orice.
    <config1-name>:
        # descrierea configurației
        # ...
    <config2-name>:
        # descrierea configurației
        # ...
    # ...

# Urmează lista secretelor care vor fi utilizate în clusterul de containere.
secrets:
    # descrierea fiecărui secret începe cu numele său, care poate fi orice.
    <secret1-name>:
        # descrierea secretului
        # ...
    <secret2-name>:
        # descrierea secretului
        # ...
    # ...
```

În descrierea standard a clusterului de containere din fișierul `docker-compose.yml` trebuie să existe secțiunea `services`, în care sunt descrise serviciile, care sunt containere separate. Celelalte secțiuni (`volumes`, `networks`, `configs`, `secrets`) sunt opționale și sunt utilizate pentru descrierea volumelor, rețelelor, configurațiilor și secretelor, respectiv.

### Descrierea serviciului

Secțiunea `services` conține lista serviciilor, fiecare dintre ele reprezintă un container separat. Descrierea serviciului conține următoarele chei:

- `image` - numele imaginii containerului care va fi utilizată pentru crearea serviciului.
- `build` - calea către directorul care conține Dockerfile, care va fi utilizat pentru crearea imaginii containerului care va fi utilizată pentru crearea serviciului.
- `ports` - lista porturilor care vor fi expuse din container pe gazdă.
- `volumes` - lista volumelor care vor fi utilizate în container.
- `networks` - lista rețelelor care vor fi utilizate în container.
- `configs` - lista configurațiilor care vor fi utilizate în container.
- `secrets` - lista secretelor care vor fi utilizate în container.
- `environment` - lista variabilelor de mediu care vor fi setate în container.
- `command` - comanda care va fi executată la pornirea containerului.
- `entrypoint` - comanda care va fi executată la pornirea containerului.
- `depends_on` - lista serviciilor de care depinde serviciul respectiv.

Exemplu de descriere a serviciului:

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
        build:
            context: ./mariadb
            dockerfile: Dockerfile.mariadb
        volumes:
            - /path/to/db:/var/lib/mysql
        networks:
            - backend
        environment:
            - MYSQL_ROOT_PASSWORD=secret
```

### Descrierea volumului

Secțiunea `volumes` conține lista volumelor care vor fi utilizate în clusterul de containere. Descrierea volumului conține următoarele chei:

- `driver` - driverul care va fi utilizat pentru crearea volumului.
- `driver_opts` - opțiunile driverului care vor fi utilizate pentru crearea volumului.
- `external` - numele volumului extern care va fi utilizat în clusterul de containere.
- `labels` - lista etichetelor care vor fi setate pentru volum.
- `name` - numele volumului.

Exemplu de descriere a volumului:

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

### Descrierea rețelei

Secțiunea `networks` conține lista rețelelor care vor fi utilizate în clusterul de containere. Descrierea rețelei conține următoarele chei:

- `driver` - driverul care va fi utilizat pentru crearea rețelei.
- `driver_opts` - opțiunile driverului care vor fi utilizate pentru crearea rețelei.
- `external` - numele rețelei externe care va fi utilizată în clusterul de containere.
- `attachable` - un indicator care indică faptul că containerele pot fi atașate la rețea.
- `internal` - un indicator care indică faptul că rețeaua este o rețea internă.
- `labels` - lista etichetelor care vor fi setate pentru rețea.
- `name` - numele rețelei.
- `enable_ipv6` - un indicator care indică faptul că rețeaua suportă IPv6.
- `ipam` - parametrii IPAM pentru rețea.

Exemplu de descriere a rețelei:

```yaml
networks:
    frontend:
        driver: bridge
        driver_opts:
            com.docker.network.bridge.name: frontend
    backend: {}
```

### Descrierea configurației

Secțiunea `configs` conține lista configurațiilor care vor fi utilizate în clusterul de containere. Descrierea configurației conține următoarele chei:

- `file` - calea către fișierul care va fi utilizat pentru crearea configurației.
- `environment` - lista variabilelor de mediu care vor fi setate pentru configurație.
- `external` - numele configurației externe care va fi utilizată în clusterul de containere.
- `name` - numele configurației.
- `content` - configurația este creată pe baza conținutului.

Exemplu de descriere a configurației:

```yaml
configs:
    nginx.conf:
        file: /path/to/nginx.conf
    php.ini:
        file: /path/to/php.ini
```

### Descrierea secretului

Secțiunea `secrets` conține lista secretelor care vor fi utilizate în clusterul de containere. Descrierea secretului conține următoarele chei:

- `file` - calea către fișierul care va fi utilizat pentru crearea secretului.
- `environment` - secretul este creat pe baza variabilei de mediu.

Exemplu de descriere a secretului:

```yaml
secrets:
    db_password:
        environment: DB_PASSWORD
    db_user:
        environment: DB_USER
    certificate:
        file: ./certificate.pem
```

## Un exemplu de cluster

Următorul exemplu arată descrierea unui cluster de servicii, care constă din servicii:

- `nginx` - serverul Web care servește fișiere statice și redirecționează cererile către aplicație.
- `php-fpm` - interpretorul PHP care procesează cererile dinamice.
- `mariadb` - serverul bazei de date care stochează datele aplicației.

Site-ul este situat în directorul montat la containerele `nginx` și `php-fpm` `/path/to/web`, iar baza de date în directorul montat la containerul `mariadb` `/path/to/db`.

```yaml
version: '3'

services:
    nginx:
        image: nginx:1.23.3
        ports:
            - "8080:80"
        volumes:
            - /path/to/web:/usr/share/nginx/html
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
            - /path/to/web:/usr/share/nginx/html
        networks:
            - backend
        environment:
            - PHP_PORT=9000
        depends_on:
            - mariadb
    mariadb:
        image: mariadb:10.5
        volumes:
            - /path/to/db:/var/lib/mysql
        networks:
            - backend
        environment:
            - MYSQL_ROOT_PASSWORD=secret
            - MYSQL_DATABASE=app
            - MYSQL_USER=user
            - MYSQL_PASSWORD=password

networks:
    frontend:
    backend:
```

## Gestionarea clusterului de containere

Fișierul `docker-compose.yaml` descrie serviciile aplicației și interacțiunile dintre ele. Pentru a construi containerele serviciilor, a defini infrastructura, trebuie să executați comanda

```bash
docker-compose build
```

Pentru a porni containerele serviciilor, trebuie să executați comanda

```bash
docker-compose up -d
```

Cheia `-d` înseamnă că containerele vor fi pornite în modul daemon.

Pentru a opri containerele serviciilor, trebuie să executați comanda

```bash
docker-compose down
```

Uneori este necesar să reconstruiți complet containerele serviciilor. Pentru aceasta trebuie să executați comanda

```bash
docker-compose build --no-cache
```

O opțiune importantă este citirea jurnalelor serviciilor. Pentru a face acest lucru, trebuie să executați comanda

```bash
docker-compose logs -f <service-name>
```

Pentru executarea unei comenzi în interiorul containerului serviciului, trebuie să executați comanda

```bash
docker-compose exec <service-name> <command>
```

## Bibliografie

1. [YAML Ain’t Markup Language (YAML™) version 1.2, yaml.org, 2021-10-01](https://yaml.org/spec/1.2.2/)
2. [Шпаргалка по YAML](../additional/yaml.md)
3. [Docker Compose overview, docs.docker.com](https://docs.docker.com/compose/)
4. [Gaël Thomas, A beginner’s guide to Docker — how to create a client/server side with docker-compose, https://www.freecodecamp.org](https://www.freecodecamp.org/news/a-beginners-guide-to-docker-how-to-create-a-client-server-side-with-docker-compose-12c8cf0ae0aa)
5. [Gaël Thomas, Руководство по Docker Compose для начинающих, перевод статьи https://www.freecodecamp.org, habr.com](https://habr.com/ru/companies/ruvds/articles/450312/)
