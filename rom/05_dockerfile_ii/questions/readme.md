# Întrebări la tema "Comenzile suplimentare ale Dockerfile"

1. Pentru specificarea unei variabile de mediu în imaginea containerului, se folosește directiva
    - [x] `ENV`
    - [ ] `ARG`
    - [ ] `VAR`
    - [ ] `VARIABLE`
2. Pentru specificarea argumentului de construcție, care poate fi folosit în timpul construirii imaginii, se folosește directiva
    - [x] `ARG`
    - [ ] `ENV`
    - [ ] `BUILD_ARG`
    - [ ] `VAR`
3. Pentru a deschide un port al containerului, se folosește directiva
    - [x] `EXPOSE`
    - [ ] `PORT`
    - [ ] `OPEN`
    - [ ] `PUBLISH`
4. Pentru specificarea punctului de montare al volumului în container, se folosește directiva
    - [x] `VOLUME`
    - [ ] `MOUNT`
    - [ ] `MOUNTPOINT`
    - [ ] `MOUNTVOLUME`
5. Datele meta ale imaginii pot fi specificate cu ajutorul directivei
    - [x] `LABEL`
    - [ ] `META`
    - [ ] `METADATA`
    - [ ] `COMMENT`
6. Schimbarea shell-ului implicit în imagine se poate face cu ajutorul directivei
    - [x] `SHELL`
    - [ ] `CMD`
    - [ ] `SH`
    - [ ] `BASH`
7. Verificarea funcționării imaginii se poate face cu ajutorul directivei
    - [x] `HEALTHCHECK`
    - [ ] `CHECK`
    - [ ] `TEST`
    - [ ] `VERIFY`
8. Argumentul de construcție `DEBIAN_VERSION` în Dockerfile se poate defini astfel:
    - [x] `ARG DEBIAN_VERSION`
    - [ ] `ENV DEBIAN_VERSION`
    - [ ] `VAR DEBIAN_VERSION`
    - [ ] `SET DEBIAN_VERSION`
9. Variabila de mediu `DEBIAN_VERSION` în Dockerfile se poate defini astfel:
    - [x] `ENV DEBIAN_VERSION`
    - [ ] `ARG DEBIAN_VERSION`
    - [ ] `VAR DEBIAN_VERSION`
    - [ ] `SET DEBIAN_VERSION`
10. Pentru a defini argumentul de construcție `DEBIAN_VERSION` cu valoarea `10` la construirea imaginii `myimage`, se folosește comanda:
    - [x] `docker build --build-arg DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build -e DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build --arg DEBIAN_VERSION=10 -t myimage .`
    - [ ] `docker build --build-env DEBIAN_VERSION=10 -t myimage .`

Întrebări de tip _"răspuns scurt"_:

1. Pentru a specifica argumentul de construcție `UBUNTU_VERSION` cu valoarea `20.04`, se adaugă în Dockerfile următoarea linie:
    - `ARG UBUNTU_VERSION=20.04`
2. Pentru a specifica argumentul de construcție `APP_DIR` cu valoarea `/usr/src/app`, se adaugă în Dockerfile următoarea linie:
    - `ARG APP_DIR=/usr/src/app`
3. Pentru a specifica variabila de mediu `APP_DIR` cu valoarea `/usr/src/app`, se adaugă în Dockerfile următoarea linie:
    - `ENV APP_DIR=/usr/src/app`
4. Pentru a specifica variabila de mediu `UBUNTU_VERSION` cu valoarea `20.04`, se adaugă în Dockerfile următoarea linie:
    - `ENV UBUNTU_VERSION=20.04`
5. Pentru a specifica argumentul de construcție `UBUNTU_VERSION` cu valoarea `20.04` la construirea imaginii `myimage`, se folosește comanda:
    - `docker build --build-arg UBUNTU_VERSION=20.04 -t myimage .`
    - `docker build -t myimage --build-arg UBUNTU_VERSION=20.04 .`
6. Pentru definirea argumentului de construcție `APP_DIR` cu valoarea `/usr/src/app` la construirea imaginii `myimage`, se folosește comanda:
    - `docker build --build-arg APP_DIR=/usr/src/app -t myimage .`
    - `docker build -t myimage --build-arg APP_DIR=/usr/src/app .`
7. În Dockerfile este definită variabila de mediu `UBUNTU_VERSION`. Scrieți directiva care va afișa valoarea acestei variabile de mediu în timpul construirii imaginii în fișierul `/version.txt`.
    - `RUN echo $UBUNTU_VERSION > /version.txt`
    - `RUN echo "$UBUNTU_VERSION" > /version.txt`
    - `RUN echo ${UBUNTU_VERSION} > /version.txt`
8. În fișier Dockerfile este definit argumentul de construcție `UBUNTU_VERSION`. Scrieți directiva care va defini variabila de mediu `UBUNTU_VERSION` cu valoarea argumentului de construcție.
    - `ENV UBUNTU_VERSION=$UBUNTU_VERSION`
    - `ENV UBUNTU_VERSION=${UBUNTU_VERSION}`
    - `ENV UBUNTU_VERSION="$UBUNTU_VERSION"`
9. În Dockerfile este definit argumentul de construcție `UBUNTU_VERSION`. Scrieți directiva care va defini crearea imaginii pe baza imaginii `ubuntu` cu utilizarea argumentului de construcție `UBUNTU_VERSION`.
    - `FROM ubuntu:$UBUNTU_VERSION`
    - `FROM ubuntu:${UBUNTU_VERSION}`
10. Pentru a deschide portul `80` în container, se adaugă în Dockerfile următoarea linie:
    - `EXPOSE 80`
11. Pentru a deschide portul `8080` în container, se adaugă în Dockerfile următoarea linie:
    - `EXPOSE 8080`
12. Pentru a proba portul `80` al containerului pe portul `8080` al gazdei la crearea și pornirea containerului cu imaginea `myimage`, se folosește comanda:
    - `docker run -p 8080:80 myimage`
13. Pentru a defini punctul de montare al volumului la directorul `/data` în container, se adaugă în Dockerfile următoarea linie:
    - `VOLUME /data`
14. Pentru a defini punctul de montare al volumului la directorul `/var/lib/mysql` în container, se adaugă în Dockerfile următoarea linie:
    - `VOLUME /var/lib/mysql`
15. Pentru a defini metadatele imaginii `maintainer` cu valoarea `Gicu Stirbu`, se adaugă în Dockerfile următoarea linie:
    - `LABEL maintainer="Gicu Stirbu"`
    - `LABEL maintainer=Gicu Stirbu`
16. Pentru a defini metadatele imaginii `version` cu valoarea `1.0`, se adaugă în Dockerfile următoarea linie:
    - `LABEL version="1.0"`
    - `LABEL version=1.0`
