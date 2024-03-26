# Intrebari la tema "Sintaxa Dockerfile"

1. Ce este contextul de construire?
    - [ ] Este directorul în care se află fișierul `Dockerfile`.
    - [ ] Este directorul în care se află fișierul `docker-compose.yml`.
    - [ ] Este directorul din care se execută comanda `docker build`.
    - [ ] Este imaginea folosită pentru construirea altor imagini.
2. Prin care comandă se specifică imaginea de bază?
    - [ ] `FROM`
    - [ ] `BASE`
    - [ ] `BASE_IMAGE`
    - [ ] `BASE_IMAGE_NAME`
3. Eticheta text specială care indică, de exemplu, versiunea imaginii sau caracteristicile sale se numește
    - [ ] `tag`
    - [ ] `versiune`
    - [ ] `metadate`
    - [ ] `atribut`
4. La specificarea imaginii de bază se poate specifica eticheta care corespunde versiunii specifice a imaginii de bază. Dacă eticheta nu este specificată, atunci va fi utilizată eticheta
    - [ ] `latest`
    - [ ] `current`
    - [ ] `newest`
    - [ ] `recent`
5. Dacă imaginea de bază nu este specificată, atunci va fi utilizată imaginea de bază
    - [ ] `scratch`
    - [ ] `empty`
    - [ ] `none`
    - [ ] `null`
6. Prin care comandă se specifică metadatele imaginii?
    - [ ] `LABEL`
    - [ ] `META`
    - [ ] `METADATA`
    - [ ] `METAINFO`
7. Prin care comandă se specifică argumentele de construire?
    - [ ] `ARG`
    - [ ] `ARGUMENT`
    - [ ] `BUILD_ARG`
    - [ ] `BUILD_ARGUMENT`
8. Prin care comandă se specifică punctul de intrare pentru rularea containerului?
    - [ ] `CMD`
    - [ ] `EXEC`
    - [ ] `RUN`
    - [ ] `START`
9. Pentru a copia fișiere și directoare din contextul de construire în sistemul de fișiere al imaginii, se folosește comanda:
    - [ ] `COPY`
    - [ ] `MOVE`
    - [ ] `INSERT`
    - [ ] `PASTE`
10. Imaginea containerului este construită implicit pe baza descrierii fișierului
    - [ ] `Dockerfile`
    - [ ] `docker-compose.yaml`
    - [ ] `docker-image.def`
    - [ ] `image.json`
11. Pentru a descărca un arhivă de la o adresă URL și copia în imaginea se folosește comanda
    - [ ] `ADD`
    - [ ] `COPY`
    - [ ] `GET`
    - [ ] `DOWNLOAD`
12. Executarea unei anumite comenzi la construirea imaginii containerului este determinată de directiva
    - [ ] `RUN`
    - [ ] `EXEC`
    - [ ] `CMD`
    - [ ] `DO`
13. Pentru a specifica directorul de lucru în care se vor executa toate următoarele comenzi, se folosește comanda
    - [ ] `WORKDIR`
    - [ ] `WORK`
    - [ ] `DIR`
    - [ ] `CD`
14. Schimbarea utilizatorului în imagine se poate face cu ajutorul comenzii
    - [ ] `USER`
    - [ ] `CHANGE_USER`
    - [ ] `SWITCH_USER`
    - [ ] `CHOWN`
15. Pentru copierea fisierului `php-fpm.conf` din directorul `files/configs` în directorul `/etc/php` al imaginii, se folosește comanda
    - [ ] `COPY files/configs/php-fpm.conf /etc/php`
    - [ ] `COPY /etc/php files/configs/php-fpm.conf`
    - [ ] `COPY /etc/php/php-fpm.conf files/configs`
    - [ ] `COPY /files/configs/php-fpm.conf /etc/php`
16. Pentru a crea directorul `/var/www` în imagine, se folosește comanda
    - [ ] `RUN mkdir /var/www`
    - [ ] `COPY /var/www`
    - [ ] `CREATE /var/www`
    - [ ] `MKDIR /var/www`
17. Pentru a instala pachetul `nginx` în imagine, se folosește comanda
    - [ ] `RUN apt-get install -y nginx`
    - [ ] `COPY apt-get install -y nginx`
    - [ ] `INSTALL nginx`
    - [ ] `ADD apt-get install -y nginx`
18. Pentru a executa comanda `nginx -g "daemon off;"` la rularea containerului, se folosește comanda
    - [ ] `CMD ["nginx", "-g", "daemon off;"]`
    - [ ] `RUN ["nginx", "-g", "daemon off;"]`
    - [ ] `START ["nginx", "-g", "daemon off;"]`
    - [ ] `EXEC ["nginx", "-g", "daemon off;"]`
19. Reinnoirea listelor de pachete și a pachetelor în imaginea pe baza OS Ubuntu se poate face cu ajutorul comenzii
    - [ ] `RUN apt-get update && apt-get -y upgrade`
    - [ ] `RUN apt-get update`
    - [ ] `RUN apt-get -y upgrade`
    - [ ] `UPGRADE packages`
20. Diferența dintre comenzile `CMD` și `ENTRYPOINT` constă în faptul că
    - [ ] `CMD` permite redefinirea comenzii la rularea containerului, iar `ENTRYPOINT` - nu.
    - [ ] `ENTRYPOINT` permite redefinirea comenzii la rularea containerului, iar `CMD` - nu.
    - [ ] `CMD` și `ENTRYPOINT` efectuează aceleași acțiuni.
    - [ ] `CMD` și `ENTRYPOINT` efectuează acțiuni diferite.

Întrebări de tip _răspuns scurt_:

1. În Dockerfile pentru crearea unei imagini pe baza imaginii `ubuntu:20.04` se folosește comanda
   - `FROM ubuntu:20.04`
2. În Dockerfile pentru crearea unei imagini pe baza ultimei imagini create `nginx` se folosește comanda
   - `FROM nginx`
   - `FROM nginx:latest`
3. În Dockerfile pentru crearea unei imagini pe baza unei imagini goale se folosește comanda
   - `FROM scratch`
4. Care comandă în Dockerfile se folosește pentru instalarea pachetului `nano` în imaginea pe baza OS Ubuntu?
    - `RUN apt-get install -y nano`
    - `RUN apt-get install nano -y`
    - `RUN apt install -y nano`
    - `RUN apt install nano -y`
5. În Dockerfile pentru copierea fișierului `php.ini` din directorul `files` contextului de construire în imagine în directorul `/etc/php/7.4/cli` se folosește comanda
    - `COPY files/php.ini /etc/php/7.4/cli`
6. În Dockerfile pentru crearea directorului `/var/www` în imagine se folosește comanda
    - `RUN mkdir /var/www`
7. Pentru a schimba utilizatorul în imagine pe `www-data` se folosește comanda
    - `USER www-data`
8. Pentru a instala pachetul `nginx` în imagine pe baza OS Ubuntu se folosește comanda
    - `RUN apt-get install -y nginx`
    - `RUN apt-get install nginx -y`
    - `RUN apt install -y nginx`
    - `RUN apt install nginx -y`
9. Pentru a executa comanda `nginx -g "daemon off;"` la rularea containerului, se folosește comanda
    - `CMD ["nginx", "-g", "daemon off;"]`
    - `CMD nginx -g "daemon off;"`
10. Pentru a schimba directorul de lucru în imagine pe `/var/www` se folosește comanda
    - `WORKDIR /var/www`
