# Pornirea aplicatiilor containerizate

- [Pornirea aplicatiilor containerizate](#pornirea-aplicatiilor-containerizate)
  - [Asamblarea imaginii](#asamblarea-imaginii)
  - [Vizualizarea imaginilor existente](#vizualizarea-imaginilor-existente)
  - [Stergerea imaginii](#stergerea-imaginii)
  - [Crearea unui container](#crearea-unui-container)
  - [Pornirea containerului](#pornirea-containerului)
  - [Comunicarea cu containerul](#comunicarea-cu-containerul)
  - [Repornirea containerului](#repornirea-containerului)
  - [Copierea fișierelor din container](#copierea-fișierelor-din-container)
  - [Copierea fișierelor în container](#copierea-fișierelor-în-container)
  - [Vizualizarea containerelor](#vizualizarea-containerelor)
  - [Oprirea containerului](#oprirea-containerului)
  - [Stergerea containerului](#stergerea-containerului)
  - [Bibliografie](#bibliografie)

Containere sunt instanțe ale imaginilor. Containerele pot fi pornite, oprite, mutate și șterse. În această secțiune vom examina comenzile pentru lucru cu containere.

## Asamblarea imaginii

După ce fișierul `Dockerfile` este creat, puteți începe să construiți imaginea. Construirea imaginii se face de obicei din linia de comandă și pentru construirea imaginii se utilizează comanda `docker build`. Comanda `docker build` are următorul sintaxă:

```bash
docker build [OPTIONS] PATH | URL | -
```

unde `PATH` - calea către directorul în care se află fișierul `Dockerfile`, `URL` - adresa URL a depozitului Git în care se află fișierul `Dockerfile`, `-` - intrare standard.

În caz dacă fișierul `Dockerfile` se află în directorul curent, atunci pentru construirea imaginii este suficient să se execute comanda:

```bash
docker build .
```

În acest caz va fi utilizat directorul curent ca context de construire și va fi creată o imagine cu un nume arbitrar și tag `latest`. Dacă este necesar să se specifice numele și tag-ul imaginii, atunci acest lucru poate fi făcut cu ajutorul opțiunii `-t`:

```bash
docker build -t myimage:1.0 .
```

Pentru a vă familiariza în detaliu cu opțiunile comenzii `docker build`, puteți executa comanda:

```bash
docker build --help
```

## Vizualizarea imaginilor existente

Pentru vizualizarea imaginilor existente se utilizează comanda `docker images`:

```bash
docker images
```

Ieșirea comenzii va conține următoarele coloane:

- `REPOSITORIES` - nume imagine, inclusiv nume repozitoriu
- `TAG` - tagul imaginii
- `IMAGE ID` - identificatorul imaginii
- `CREATED` - data crearii imaginii
- `SIZE` - volumul imaginii

## Stergerea imaginii

Pentru ștergerea obrazului se utilizează comanda `docker rmi`:

```bash
docker rmi <image_name>
```

Unde `<image_name>` - este identificatorul sau numele imaginii.

Cu o comanda se poate șterge simultan mai multe imagini, pentru aceasta este necesar să se enumere numele lor prin spațiu:

```bash
docker rmi <image_name_1> <image_name_2> <image_name_3>
```

## Crearea unui container

In baza imaginii existente se poate crea un container. Pentru aceasta se utilizează comanda `docker create`:

```bash
docker create <image_name>
```

In acest caz va fi creat un container cu un nume arbitrar pe baza imaginii `<image_name>`. Dacă imaginea nu este găsită local, atunci ea va fi descărcată din depozitor. Dacă este necesar să se creeze un container cu un anumit nume, atunci se utilizează opțiunea `--name`:

```bash
docker create --name <container_name> <image_name>
```

Totodată, la crearea containerului se poate specifica întreaga serie de opțiuni, cum ar fi montarea volumelor, redirecționarea porturilor, transmiterea variabilelor de mediu etc. Pentru a vă familiariza în detaliu cu opțiunile comenzii `docker create`, puteți executa comanda:

```bash
docker create --help
```

## Pornirea containerului

După ce containerul este creat, el poate fi pornit cu ajutorul comenzii `docker start`:

```bash
docker start <container_name>
```

Deseori dezvoltatorii creează și pornesc containerul cu o singură comandă. Pentru aceasta se utilizează comanda `docker run`:

```bash
docker run <image_name>
```

In acest caz va fi creat și pornit containerul cu un nume arbitrar pe baza imaginii `<image_name>`. Dacă imaginea nu este găsită local, atunci ea va fi descărcată din depozitor.

Pentru a porni containerul în modul daemon se utilizează opțiunea `-d`:

```bash
docker run -d <image_name>
```

Dacă este necesar să se pornesc containerul cu un anumit nume, atunci se utilizează opțiunea `--name`:

```bash
docker run -d --name <container_name> <image_name>
```

In acest caz va fi creat și pornit containerul cu un nume `<container_name>` pe baza imaginii `<image_name>`.

## Comunicarea cu containerul

Comunicarea cu containerul se poate face doar cu containerul pornit. Pentru aceasta este necesar să se cunoască numele sau identificatorul containerului. Numele containerului se poate specifica la crearea containerului cu ajutorul opțiunii `--name`, iar identificatorul containerului se poate afla cu ajutorul comenzii `docker ps`.

Pentru a executa comanda în interiorul containerului se poate utiliza comanda `docker exec`:

```bash
docker exec <container_name> <command>
```

La pornirea containerului se execută comanda, specificată în fișierul `Dockerfile` cu ajutorul unei din directivelor `CMD` sau `ENTRYPOINT`. Dacă este necesar să se execute o altă comandă, atunci ea se specifică după numele imaginii:

```bash
docker run <image_name> <command>
```

Uneori apare necesitatea de a porni containerul în modul interactiv, de exemplu, pentru depanare. Comunicarea cu containerul permite să se vizualizeze conținutul său, să se execute în el comenzi (de exemplu, să se instaleze un anumit pachet).

Pentru a porni containerul în modul interactiv se utilizează opțiunea `-it`, care combină două opțiuni `-i` (interactive) și `-t` (pseudo-TTY):

```bash
docker run -it <image_name> <command>
```

De exemplu, pentru a porni containerul cu imaginea `ubuntu` în modul interactiv se utilizează comanda:

```bash
docker run -it ubuntu /bin/bash
```

## Repornirea containerului

Pentru repornirea containerului se utilizează comanda `docker restart`. De exemplu, pentru repornirea containerului cu numele `my_container` se utilizează următoarea comandă:

```bash
docker restart my_container
```

## Copierea fișierelor din container

Pentru copierea fișierelor din container se utilizează comanda `docker cp`. De exemplu, pentru copierea fișierului `file.txt` din containerul cu numele `my_container` în directorul curent se utilizează următoarea comandă:

```bash
docker cp my_container:/path/to/file.txt .
```

## Copierea fișierelor în container

Pentru copierea fișierelor în container se utilizează comanda `docker cp`. De exemplu, pentru copierea fișierului `file.txt` în containerul cu numele `my_container` din directorul curent se utilizează următoarea comandă:

```bash
docker cp file.txt my_container:/path/to/file.txt
```

## Vizualizarea containerelor

Pentru vizualizarea containerelor pornite se utilizează comanda `docker ps`:

```bash
docker ps
```

Afișarea comenzii va conține următoarele coloane:

- `CONTAINER ID` - identificatorul containerului
- `IMAGE` - numele imaginii in baza căreia a fost creat containerul
- `COMMAND` - comanda, pornită în container
- `CREATED` - data creării containerului
- `STATUS` - starea containerului
- `PORTS` - porturile legate la container
- `NAMES` - numele containerului

Daca este necesar să se vizualizeze toate containerele, inclusiv cele oprite, atunci se utilizează opțiunea `-a`:

```bash
docker ps -a
```

## Oprirea containerului

Pentru oprirea containerului se utilizează comanda `docker stop`:

```bash
docker stop <container_name>
```

Cu o comanda se poate opri simultan mai multe containere, pentru aceasta este necesar să se enumere numele lor prin spațiu:

```bash
docker stop <container_name_1> <container_name_2> <container_name_3>
```

## Stergerea containerului

Pentru ștergerea containerului se utilizează comanda `docker rm`:

```bash
docker rm <container_name>
```

Cu o comanda se poate șterge simultan mai multe containere, pentru aceasta este necesar să se enumere numele lor prin spațiu:

```bash
docker rm <container_name_1> <container_name_2> <container_name_3>
```

## Bibliografie

1. [How do I run a container?, docker.com](https://docs.docker.com/guides/walkthroughs/run-a-container/)
2. [Getting started guide, docker.com](https://docs.docker.com/get-started/)
3. [Запуск контейнера Docker, losst.pro, 2020](https://losst.pro/zapusk-kontejnera-docker)
