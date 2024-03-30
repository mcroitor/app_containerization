# Lucrarea de laborator nr. 6: Crearea unei aplicații multi-container

## Scopul lucrării

Famialiarizarea cu gestiunea aplicației multi-container creat cu `docker-compose`.

## Sarcina

Creați o aplicație php pe baza a trei containere: nginx, php-fpm, mariadb, folosind `docker-compose`.

## Pregătire

Pentru a efectua această lucrare, trebuie să aveți instalat pe computer [Docker](https://www.docker.com/).

Lucrarea se efectuează pe baza laboratorului nr. 5.

## Execuție

Creați un repozitoriu `containers06` și copiați-l pe computerul dvs.

### Site-ul pe php

În directorul `containers06` creați directorul `mounts/site`. În acest director, rescrieți site-ul pe php, creat în cadrul disciplinei php.

### Fișiere de configurare

Creați fișierul `.gitignore` în rădăcina proiectului și adăugați următoarele linii:

```gitignore
# Ignore files and directories
mounts/site/*
```

Creați în directorul `containers06` fișierul `nginx/default.conf` cu următorul conținut:

```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        fastcgi_pass backend:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

Creați în directorul `containers06` fișierul `docker-compose.yml` cu următorul conținut:

```yaml
version: '3.9'

services:
  frontend:
    image: nginx:1.19
    volumes:
      - ./mounts/site:/var/www/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
    ports:
      - "80:80"
    networks:
      - internal
  backend:
    image: php:7.4-fpm
    volumes:
      - ./mounts/site:/var/www/html
    networks:
      - internal
    env_file:
      - mysql.env
  database:
    image: mysql:8.0
    env_file:
      - mysql.env
    networks:
      - internal
    volumes:
      - db_data:/var/lib/mysql

networks:
  internal: {}

volumes:
  db_data: {}
```

Creați файлul `mysql.env` în rădăcina proiectului și adăugați în el următoarele linii:

```env
MYSQL_ROOT_PASSWORD=secret
MYSQL_DATABASE=app
MYSQL_USER=user
MYSQL_PASSWORD=secret
```

## Pornire și testare

Porniți containerele cu comanda:

```bash
docker-compose up -d
```

Verificați funcționarea site-ului în browser, trecând la adresa `http://localhost`. Dacă este afișată pagina de bază `nginx`, atunci reîncărcați pagina.

## Pregăirea raportului

Creați în directorul `containers06` fișierul `README.md` care va conține descrierea pas cu pas a proiectului. Descrierea proiectului trebuie să conțină:

1. Numele lucrării de laborator.
2. Scopul lucrării.
3. Sarcina.
4. Descrierea efectuării lucrării cu răspunsuri la întrebări.
5. Concluzii.

Răspundeți la întrebările:

1. În ce ordine sunt pornite containerele?
2. Unde sunt stocate datele bazei de date?
3. Cum se numesc containerele proiectului?
4. Trebuie să adăugați încă un fișier `app.env` cu variabila de mediu `APP_VERSION` pentru serviciile `backend` și `frontend`. Cum se face acest lucru?

Plasați proiectul pe GitHub.

## Prezentare

Pentru prezentarea răspunsului atașați la sarcină un link către repozitoriul.

## Evaluare
