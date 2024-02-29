# Sintaxa Dockerfile

- [Sintaxa Dockerfile](#sintaxa-dockerfile)
  - [Docker](#docker)
  - [Dockerfile](#dockerfile)
  - [Instructiuni Dockerfile](#instructiuni-dockerfile)
    - [FROM](#from)
    - [COPY](#copy)
    - [ADD](#add)
    - [RUN](#run)
    - [CMD](#cmd)
    - [ENTRYPOINT](#entrypoint)
    - [WORKDIR](#workdir)
    - [USER](#user)
  - [Bibliografie](#bibliografie)

## Docker

**Docker** este un produs software pentru automatizarea implementării și gestionării aplicațiilor într-un mediu de virtualizare la nivel de sistem de operare. Docker permite "împachetarea" aplicației cu întregul său mediu și dependențele sale într-un container care poate fi mutat pe orice sistem Linux cu suport pentru `cgroups` în nucleu, precum și oferă un mediu pentru gestionarea containerelor.

Для работы с Docker в ОС Unix / Linux необходимо установить [Docker Engine](https://docs.docker.com/engine/install/).

Для работы с Docker в ОС Windows необходимо установить [Docker Desktop](https://www.docker.com/products/docker-desktop).

## Dockerfile

Imaginile Docker se creează pe baza unui fișier `Dockerfile`. Acest fișier descrie ce comenzi trebuie executate pentru a construi imaginea. Executarea fiecărei comenzi creează o imagine intermediară, numită *strat*, care este utilizată pentru a crea următoarea imagine. Crearea imaginilor intermediare permite reutilizarea lor în construirea altor imagini, ceea ce permite reducerea semnificativă a timpului de construire a imaginii.

Un exemplu de fișier `Dockerfile`:

```dockerfile
# in baza imaginii de bază ubuntu:18.04
FROM ubuntu:18.04

# imbunatatirea listei de pachete si a pachetelor in sine
RUN apt-get update && apt-get -y upgrade
# instalarea pachetului nginx
RUN apt-get install -y nginx
# crearea fișierului index.html
RUN echo "Hello, world!" > /var/www/html/index.html

# pornirea nginx
CMD ["nginx", "-g", "daemon off;"]
```

După ce imaginea este construită, aceasta poate fi pornită și obținut un container.

## Instructiuni Dockerfile

Tabelul următor conține o listă de comenzi care pot fi utilizate în fișierul `Dockerfile`.

| Comanda | Descriere |
| --- | --- |
| `FROM` | Indică imaginea de bază în baza cărui va fi creată imaginea nouă. |
| `COPY` | Copiază fișiere și directoare din contextul de construire în sistemul de fișiere al imaginii. |
| `ADD` | Copiază fișiere și directoare din contextul de construire în sistemul de fișiere al imaginii. Permite, de asemenea, descărcarea fișierelor de pe internet și dezarhivarea arhivelor. |
| `RUN` | Rulează o comandă în container. Rezultatul executării comenzii este salvat în imagine. |
| `CMD` | Specifică comanda care va fi executată la pornirea containerului. |
| `ENTRYPOINT` | Definește o comandă care va fi executată la pornirea containerului. Comanda specificată în `ENTRYPOINT` nu poate fi redefinită la pornirea containerului. |
| `WORKDIR` | Specifică directoriu de lucru pentru comanzi `RUN`, `CMD`, `ENTRYPOINT`, `COPY` și `ADD`. |
| `USER` | Definește utilizator din numele cărui va fi executate comenzile `RUN`, `CMD`, `ENTRYPOINT`, `COPY` și `ADD`. |
| `ENV` | Setează variabile de mediu. |
| `ARG` | Setează argumentele care pot fi transmise în timpul asamblării imaginii.  |
| `EXPOSE` | Deschide porturile pentru interacțiunea cu containerul. |
| `VOLUME` | Creează puncte de montare pentru interacțiunea cu containerul. |
| `SHELL` | Definește interpretator de comenzi care va fi utilizat pentru executarea comenzilor `RUN`, `CMD`, `ENTRYPOINT`, `COPY` și `ADD`. |
| `MAINTAINER` | Definește nume și email a autorului imaginii. |
| `LABEL` | Specifică datele meta a imaginii. |
| `ONBUILD` | Specifică comenzile care vor fi executate la construirea unei imagini, pe baza căreia va fi creată o nouă imagine. |
| `HEALTHCHECK` | Specifică comanda care va fi executată pentru verificarea stării containerului. |
| `STOPSIGNAL` | Specifică semnalul care va fi trimis containerului pentru oprire. |

### FROM

Fiecare imagine nouă este creată pe baza unei imagini de bază. Imaginea de bază este specificată în comanda `FROM`. De exemplu, următoarea comandă va crea o imagine pe baza imaginii de bază `ubuntu:18.04`:

```dockerfile
FROM ubuntu:18.04
```

În cazul dat imaginea creată va include un set minim de fișiere necesare pentru funcționarea sistemului de operare Ubuntu 18.04.

Comanda `FROM` trebuie să fie specificată în prima linie a fișierului `Dockerfile`. Dacă imaginea de bază nu este specificată, atunci va fi utilizată imaginea de bază `scratch`, care nu conține niciun fișier, ceea ce este echivalent cu comanda `FROM scratch`.

La specificarea imaginii de bază poate fi indicat tag-ul imaginii care este legat cu versiunea concretă a imaginii de bază. **Tag-ul** este o etichetă text care indică, de exemplu, versiunea imaginii sau caracteristicile acesteia. Dacă tag-ul nu este specificat, atunci va fi utilizat tag-ul `latest`, care indică întotdeauna ultima imagine construită.

### COPY

Comanda `COPY` copiază fișiere și directoare din contextul de construire în sistemul de fișiere al imaginii. **Contextul de construire** este directorul în care se află fișierul `Dockerfile`. Comanda `COPY` are următorul sintaxă:

```dockerfile
СOPY <src> <dest>
```

unde `<src>` - calea către fișierul sau directorul din contextul de construire, `<dest>` - calea către fișierul sau directorul din sistemul de fișiere al imaginii.

### ADD

Comanda `ADD` copiază fișiere și directoare din contextul de construire în sistemul de fișiere al imaginii. Permite, de asemenea, descărcarea fișierelor de pe internet și dezarhivarea arhivelor. Comanda `ADD` are următorul sintaxă:

```dockerfile
ADD <src> <dest>
```

unde `<src>` - calea către fișierul sau directorul din contextul de construire, `<dest>` - calea către fișierul sau directorul din sistemul de fișiere al imaginii. Dacă `<src>` - URL, atunci fișierul va fi descărcat de pe internet. Dacă `<src>` - arhivă, atunci aceasta va fi dezarhivată în sistemul de fișiere al imaginii.

Comanda `ADD` are mai multe posibilități decât comanda `COPY`, dar în scopuri de securitate se recomandă utilizarea comenzii `COPY` în locul comenzii `ADD`.

### RUN

Comanda `RUN` execută o comandă în container. Rezultatul executării comenzii este salvat în imagine. Comanda `RUN` are următorul sintaxă:

```dockerfile
RUN <command>
```

unde `<command>` - comanda care va fi executată în container.

Exemplu de actualizare a listei de pachete și, de fapt, a pachetelor în imaginea Ubuntu:

```dockerfile
FROM ubuntu:18.04

RUN apt-get update && apt-get -y upgrade
```

### CMD

Comanda `CMD` specifică comanda care va fi executată la pornirea containerului. Comanda `CMD` are următorul sintaxă:

```dockerfile
CMD <command>
```

unde `<command>` - comanda care va fi executată la pornirea containerului, sau în formă de masiv:

```dockerfile
CMD ["<command>", "<arg1>", "<arg2>", ...]
```

Diferența dintre executarea comenzii sub formă de șir și sub formă de masiv constă în faptul că la executarea comenzii sub formă de șir comanda va fi executată în interiorul unui interpretator de comenzi (shell, sh sau bash), iar la executarea comenzii sub formă de masiv comanda va fi executată direct, fără interpretator de comenzi.

Exemplu de pornire a containerului cu comanda `echo`:

```dockerfile
FROM ubuntu:18.04

CMD echo "Hello, world!"
```

sau în formă de masiv:

```dockerfile
FROM ubuntu:18.04

CMD ["echo", "Hello, world!"]
```

### ENTRYPOINT

Comanda `ENTRYPOINT` specifică comanda care va fi executată la pornirea containerului. Această comandă nu poate fi redefinită la pornirea containerului. Comanda `ENTRYPOINT` are următorul sintaxă:

```dockerfile
ENTRYPOINT <command>
```

unde `<command>` - comanda care va fi executată la pornirea containerului, sau în formă de masiv:

```dockerfile
ENTRYPOINT ["<command>", "<arg1>", "<arg2>", ...]
```

Un exemplu de pornire a containerului cu comanda `echo`:

```dockerfile
FROM ubuntu:18.04

ENTRYPOINT echo "Hello, world!"
```

Diferența dintre comenzile `CMD` și `ENTRYPOINT` constă în faptul că comanda specificată în `CMD` poate fi redefinită la pornirea containerului, iar comanda specificată în `ENTRYPOINT` nu poate fi redefinită.

### WORKDIR

Comanda `WORKDIR` specifică directoriu de lucru pentru comenzi `RUN`, `CMD`, `ENTRYPOINT`, `COPY` și `ADD`. Comanda `WORKDIR` are următorul sintaxă:

```dockerfile
WORKDIR <path>
```

unde `<path>` - calea către directorul de lucru. Dacă directorul de lucru nu există, atunci va fi creat.

Exemplu de specificare a directorului de lucru:

```dockerfile
FROM ubuntu:18.04

WORKDIR /var
CMD ["ls", "-l"]
```

### USER

Comanda `USER` specifică utilizatorul, în numele căruia vor fi executate comenzile `RUN`, `CMD`, `ENTRYPOINT`, `COPY` și `ADD`. Comanda `USER` are următorul sintaxă:

```dockerfile
USER <user>
```

unde `<user>` - numele utilizatorului. Utilizatorul trebuie să existe în imagine. În mod implicit, comenzile sunt executate de pe numele utilizatorului `root`.

Exemplu de specificare a utilizatorului `user`:

```dockerfile
FROM ubuntu:18.04

USER root
RUN apt-get update && apt-get -y upgrade
USER user
```

În scopuri de securitate, se recomandă executarea comenzilor `CMD`, `ENTRYPOINT` în numele unui utilizator diferit de `root`.

## Bibliografie

1. [Dockerfile reference, docker.com](https://docs.docker.com/engine/reference/builder/)
2. [olemskoi, ENTRYPOINT vs CMD: назад к основам, Слёрм, Habr.com, 2017](https://habr.com/ru/companies/slurm/articles/329138/)
3. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
