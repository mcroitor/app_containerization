# Interacțiunea containerelor

- [Interacțiunea containerelor](#interacțiunea-containerelor)
  - [Sistem de fișiere](#sistem-de-fișiere)
    - [Lucrul cu volume](#lucrul-cu-volume)
    - [Montarea volumelor](#montarea-volumelor)
    - [Exemplu](#exemplu)
  - [Rețea](#rețea)
    - [Gestionarea rețelelor în Docker](#gestionarea-rețelelor-în-docker)
    - [Pornirea containerelor în rețea](#pornirea-containerelor-în-rețea)
  - [Bibliografie](#bibliografie)

Sisteme informaționale complexe sunt de obicei compuse din mai multe componente. Fiecare componentă poate fi dezvoltată și întreținută de o echipă separată. În astfel de cazuri este important să se asigure interacțiunea între componente.

Interacțiunea între containere poate fi realizată prin rețea sau sistem de fișiere.

## Sistem de fișiere

Două containere pot interacționa prin sistemul de fișiere, dacă acestea montează același volum. De exemplu, containerul `A` poate scrie un fișier în volum, iar containerul `B` poate citi acest fișier. În acest caz, containerele pot interacționa între ele, chiar dacă sunt rulate în rețele diferite.

### Lucrul cu volume

Volumele în Docker reprezintă mecanismul de stocare a datelor, care poate fi utilizat de mai multe containere. Volumele pot fi create, listate, șterse și atașate la containere.

Pentru lucrul cu volume se utilizează următoarele comenzi:

- `docker volume create <VOLUME>` - creează un volum cu numele `<VOLUME>`;
- `docker volume ls` - afișează lista volumelor;
- `docker volume rm <VOLUME>` - șterge volumul cu numele `<VOLUME>`;
- `docker volume inspect <VOLUME>` - afișează informații despre volumul cu numele `<VOLUME>`;
- `docker volume prune` - șterge toate volumele neutilizate.

### Montarea volumelor

Pentru a monta volumul la container se utilizează opțiunea `-v` a comenzii `docker run`. De exemplu, pentru a monta volumul cu numele `myvolume` la containerul `mycontainer`, se utilizează următoarea comandă:

```bash
docker run -v opt:/opt --name mycontainer myimage
```

În acest caz, volumul `opt` va fi disponibil în containerul `mycontainer` la calea `/opt`.

### Exemplu

Să analizăm un exemplu, în care un container scrie fiecare 5 secunde un număr aleatoriu într-un fișier, iar alt container citește acest fișier și afișează conținutul său în consolă. Pentru containerul care scrie `dockerfile.write` arată astfel:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do shuf -i1-10 -n1 > /opt/data.txt; sleep ${TIMEOUT}; done"]
```

Pentru containerul care citește fișierul `dockerfile.read` arată astfel:

```Dockerfile
FROM debian:latest

ARG TIMEOUT=5
ENV TIMEOUT=${TIMEOUT}

VOLUME [ "/opt" ]

CMD ["sh", "-c", "while true; do cat opt/data.txt; sleep ${TIMEOUT}; done"]
```

Creăm un volum comun `opt`:

```bash
docker volume create opt
```

După aceea, asamblăm imaginile:

```bash
docker build -t read -f dockerfile.read .
docker build -t write -f dockerfile.write .
```

Pornim containerele:

```bash
docker run -d -v opt:/opt --name write write
docker run -d -v opt:/opt --name read read
```

## Rețea

Două containere pot interacționa prin rețea. În Docker rețeaua reprezintă mecanismul de conectare a mai multor containere. Rețeaua poate fi creată, listată, ștearsă și containerele pot fi conectate la rețea.

### Gestionarea rețelelor în Docker

Pentru a lucra cu rețelele se utilizează următoarele comenzi:

- `docker network create <NETWORK>` - creează o rețea cu numele `<NETWORK>`;
- `docker network ls` - afișează lista rețelelor;
- `docker network rm <NETWORK>` - șterge rețeaua cu numele `<NETWORK>`;
- `docker network inspect <NETWORK>` - afișează informații despre rețeaua cu numele `<NETWORK>`;
- `docker network connect <NETWORK> <CONTAINER>` - conectează containerul cu numele `<CONTAINER>` la rețeaua cu numele `<NETWORK>`;
- `docker network disconnect <NETWORK> <CONTAINER>` - deconectează containerul cu numele `<CONTAINER>` de la rețeaua cu numele `<NETWORK>`;
- `docker network prune` - șterge toate rețelele neutilizate.

### Pornirea containerelor în rețea

Există două posibilități de a porni containerele în rețea:

- conectarea containerului la rețea după pornirea lui;
- conectarea containerului la rețea la pornirea lui.

În primul caz se utilizează comanda `docker network connect`, în al doilea - opțiunea `--network` a comenzii `docker run`.

Presupunem că există două containere `frontend` și `backend`, care trebuie să comunice între ele prin rețea `local`, pentru aceasta este necesar:

- să se creeze rețeaua `local`;
- să se pornească containerul `backend` în rețeaua `local`;
- să se pornească containerul `frontend` în rețeaua `local`.

```bash
docker network create local
docker run -d --name backend --network local backend
docker run -d --name frontend --network local frontend
```

## Bibliografie

1. [Швалов А., Хранение данных в Docker, Слерм](https://slurm.io/blog/tpost/i5ikrm9fj1-hranenie-dannih-v-docker)
2. [Docker Networking, Docker](https://docs.docker.com/network/)
3. [Docker Volumes, Docker](https://docs.docker.com/storage/volumes/)
