# Comenzile suplimentare din Dockerfile

- [Comenzile suplimentare din Dockerfile](#comenzile-suplimentare-din-dockerfile)
  - [Variabile la construirea imaginii](#variabile-la-construirea-imaginii)
    - [ARG](#arg)
    - [ENV](#env)
  - [Interacțiunea cu containerul](#interacțiunea-cu-containerul)
    - [EXPOSE](#expose)
    - [VOLUME](#volume)
  - [Metadatele imaginii](#metadatele-imaginii)
    - [LABEL](#label)
  - [Comenzile suplimentare](#comenzile-suplimentare)
    - [SHELL](#shell)
    - [ONBUILD](#onbuild)
    - [HEALTHCHECK](#healthcheck)
    - [STOPSIGNAL](#stopsignal)
  - [Bibliografie](#bibliografie)

## Variabile la construirea imaginii

La construirea imaginii, adesea este necesar să se transmită în imagine anumite parametri. De exemplu, se poate avea un `Dockerfile` comun pentru mai multe proiecte, în care diferă doar anumite parametri. De asemenea, se pot transmite în imagine anumite date confidențiale, cum ar fi parole, token-uri etc.

Totodată, în timpul construirii imaginii se pot folosi variabile de mediu, care vor fi disponibile în timpul rulării containerului.

### ARG

Comanda `ARG` definește argumentele care pot fi transmise la construirea imaginii. Argumentele pot fi folosite în comenzile `FROM`, `RUN`, `CMD`, `LABEL` și `MAINTAINER`. Argumentele pot fi transmise la construirea imaginii cu ajutorul opțiunii `--build-arg`.

```dockerfile
ARG <name>[=<default value>]
```

unde `<name>` - numele argumentului, `<default value>` - valoarea implicită a argumentului.

Exemplu de utilizare a argumentelor:

```dockerfile
ARG VERSION=latest

FROM ubuntu:$VERSION
```

Argumentele pot fi transmise la construirea imaginii cu ajutorul opțiunii `--build-arg`:

```bash
docker build --build-arg VERSION=18.04 -t myimage .
```

### ENV

Comanda `ENV` definește variabilele de mediu. Variabilele de mediu vor fi disponibile în timpul rulării containerului. Variabilele de mediu pot fi folosite în comenzile `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD` și `WORKDIR`.

```dockerfile
ENV <key> <value>
```

unde `<key>` - numele variabilei de mediu, `<value>` - valoarea variabilei de mediu.

Exemplu utilizare variabile de mediu:

```dockerfile
FROM ubuntu:18.04
ENV MY_NAME="John Doe"

RUN echo "Hello, $MY_NAME"
```

Diferenta dintre `ARG` și `ENV` constă în faptul că `ARG` este folosit doar în timpul construirii imaginii, iar `ENV` - în timpul rulării containerului. Dacă este necesar să se transmită informație pentru utilizare în timpul rulării containerului, atunci se poate folosi definirea `ENV` prin `ARG`:

```dockerfile
ARG MY_NAME="John Doe"
FROM ubuntu:18.04
ENV MY_NAME=$MY_NAME

RUN echo "Hello, $MY_NAME"
```

Variabilele de mediu pot fi suprascrise la rularea containerului cu ajutorul opțiunii `-e` a comenzii `docker run`:

```bash
docker run -e MY_NAME="Jane Doe" myimage
```

## Interacțiunea cu containerul

Containerul este o entitate izolată, de aceea, pentru ca containerul să poată interacționa cu sistemele externe, este necesar să se definească anumite parametri ai containerului. De exemplu, se pot defini porturile pe care le va folosi containerul pentru interacțiune cu sistemele externe, de asemenea, se pot defini volumele pe care le va folosi containerul pentru stocarea datelor.

### EXPOSE

Comanda `EXPOSE` definește porturile pe care le va folosi containerul pentru interacțiune cu sistemele externe. Comanda `EXPOSE` are următorul sintaxă:

```dockerfile
EXPOSE <port> [<port>...]
```

unde `<port>` - numărul portului, care va fi deschis pentru accesul în container.

Porturile, definite cu ajutorul comenzii `EXPOSE`, sunt disponibile pentru alte containere, care sunt conectate la același rețea, dar nu sunt disponibile pentru gazdă (host). Pentru a face porturile disponibile pentru gazdă, acestea trebuie să fie redirecționate pe porturile gazdei cu ajutorul opțiunii `-p` (sau `--publish`) a comenzii `docker run`.

```bash
docker run -p 80 myimage
```

In acest caz portul 80 al containerului va fi asociat cu un port aleator al gazdei. Pentru a specifica portul gazdei, se poate folosi următoarea sintaxă:

```bash
docker run -p 8080:80 myimage
```

In acest caz portul 80 al containerului va fi asociat cu portul 8080 al gazdei.

### VOLUME

Comanda `VOLUME` definește volumele, care vor fi folosite de container pentru stocarea datelor. Comanda `VOLUME` are următorul sintaxă:

```dockerfile
VOLUME <path> [<path>...]
```

unde `<path>` - calea către volum, care va fi folosit de container. Acest volum va fi disponibil pentru scriere în timpul rulării containerului, este plasat în sistemul de fișiere al gazdei și, după terminarea containerului, datele scrise de container sunt păstrate.

Un exemplu de utilizare a comenzii `VOLUME`:

```dockerfile
FROM ubuntu:18.04

VOLUME /var/www
```

Totodată, se pot defini volume în timpul rulării containerului cu ajutorul opțiunii `-v` a comenzii `docker run`:

```bash
docker run -v /var/www myimage
```

Poate fi definită și o cale a volumului în timpul rulării containerului:

```bash
docker run -v /path/to/host:/path/to/container myimage
```

## Metadatele imaginii

Metadatele imaginii - este informația despre creatorul imaginii, descrierea imaginii, informația de contact etc. Metadatele imaginii pot fi folosite pentru căutarea imaginilor, pentru automatizarea procesului de construire a imaginilor, pentru automatizarea procesului de rulare a imaginilor.

### LABEL

Comanda `LABEL` definește metadatele imaginii. Comanda `LABEL` are următorul sintaxă:

```dockerfile
LABEL <key> = <value> <key> = <value>...
```

unde `<key>` - cheia metadatei, `<value>` - valoarea metadatei. Metadatele pot fi folosite pentru căutarea imaginilor, pentru automatizarea procesului de construire a imaginilor, pentru automatizarea procesului de rulare a imaginilor.

Un exemplu de utilizare a comenzii `LABEL`:

```dockerfile
FROM ubuntu:18.04

LABEL version="1.0"

RUN echo "Hello, world"
```

Metadatele imaginii pot fi afișate cu ajutorul comenzii `docker inspect`:

```bash
docker inspect myimage
```

Sunt următoarele recomandări pentru definirea metadatelor imaginii:

- autorii pachetelor terțe trebuie să folosească prefixul cheii, care reprezintă o înregistrare de domeniu inversă, de exemplu, `com.example-vendor=ACME Incorporated`. Acest prefix reprezintă un spațiu de nume;
- utilizați prefixele cheilor (spațiile de nume) numai cu permisiunea proprietarului domeniului;
- prefixele `com.docker.*`, `io.docker.*`, și `org.dockerproject.*` sunt rezervate pentru uz intern Docker;
- cheia unui label trebuie să înceapă cu o literă mică sau cu un număr și să conțină numai litere mici, cifre și caracterele `.`, `-`. Nu se permite utilizarea caracterelor speciale consecutive.
- simbolul `.` separă spațiile de nume încorporate. Cheile label-urilor fără spațiu de nume sunt folosite în mod implicit în modul de linie de comandă (CLI) pentru a eticheta obiectele Docker cu șiruri scurte, prietenoase pentru utilizator.

## Comenzile suplimentare

### SHELL

Comanda `SHELL` definește teminal care va fi folosit pentru rularea comenzilor `RUN`, `CMD`, `ENTRYPOINT`. Comanda `SHELL` are următorul sintaxă:

```dockerfile
SHELL ["executable", "parameters"]
```

unde `executable` - executabilul terminalului, `parameters` - parametrii terminalului.

Exemplu de utilizare a comenzii `SHELL`:

```dockerfile
FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

RUN echo "Hello, world"
```

In descrierea imaginii, terminalul poate fi redefinit de mai multe ori și acest lucru va afecta toate comenzile `RUN`, `CMD` și `ENTRYPOINT` ulterioare, până la următoarea definire a comenzii `SHELL`:

```dockerfile
FROM microsoft/windowsservercore

# verificăm terminalul implicit
RUN echo default shell is %COMSPEC%

# redefinim terminalul
SHELL ["powershell", "-Command"]

# verificăm terminalul
RUN Write-Host default shell is %COMSPEC%
```

### ONBUILD

Comanda `ONBUILD` definește comenzile care vor fi executate la construirea imaginii, pe baza căreia va fi construită o altă imagine. Comanda `ONBUILD` are următorul sintaxă:

```dockerfile
ONBUILD <command>
```

unde `<command>` - comanda, care va fi executată la construirea imaginii, pe baza căreia va fi construită o altă imagine.

Exemplu de utilizare a comenzii `ONBUILD`:

```dockerfile
FROM ubuntu:18.04

ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src
```

### HEALTHCHECK

Instrucțiunea `HEALTHCHECK` definește comanda care va fi executată pentru verificarea stării containerului. Comanda `HEALTHCHECK` are următorul sintaxă:

```dockerfile
HEALTHCHECK [OPTIONS] CMD command
```

unde `OPTIONS` - opțiunile comenzii, `CMD` - comanda care va fi executată pentru verificarea stării containerului.

Verificarea starii containerului poate fi dezactivată cu ajutorul comenzii `HEALTHCHECK NONE`:

Inainte de directiva `CMD` pot fi specificate urmatoarele proprietati:

- `--interval=DURATION` - intervalul dintre verificările stării containerului. Implicit, intervalul este de 30 de secunde;
- `--timeout=DURATION` - timpul de așteptare pentru executarea comenzii de verificare a stării containerului. Implicit, timpul de așteptare este de 30 de secunde;
- `--start-period=DURATION` - timpul de așteptare înainte de începerea executării comenzii de verificare a stării containerului. Implicit, timpul de așteptare este de 0 secunde;
- `--start-interval=DURATION` - intervalul dintre încercările de a executa comanda de verificare a stării containerului la pornire. Implicit, intervalul este de 5 secunde. Pentru a folosi această proprietate, este necesar să aveți versiunea Docker Engine 25.0 sau mai mare;
- `--retries=N` - numărul de încercări de a executa comanda de verificare a stării containerului. Implicit, numărul de încercări este de 3.

Comanda, specificată după `CMD`, trebuie să returneze un cod de stare:

- `0` - starea containerului este sănătoasă;
- `1` - starea containerului este nesănătoasă.
- `2` - starea containerului este rezervată pentru viitoră utilizare, nu folosiți în prezent.

Exemplu de utilizare a comenzii `HEALTHCHECK`:

```dockerfile
FROM ubuntu:18.04

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

### STOPSIGNAL

Comanda `STOPSIGNAL` definește semnalul care va fi trimis containerului pentru oprire. Comanda `STOPSIGNAL` are următorul sintaxă:

```dockerfile
STOPSIGNAL signal
```

unde `signal` - semnalul care va fi trimis containerului pentru oprire. Semnalul poate fi specificat sub formă de număr sau sub formă de nume de semnal. Cele mai frecvente semnale sunt:

- `SIGTERM` - semnalul implicit cu codul `15`, care este trimis containerului pentru oprire;
- `SIGKILL` - semnalul cu codul `9` care trimite containerului pentru oprire imediată.
- `SIGINT` - semnalul cu codul `2` care trimite containerului pentru intrerupere.
- `SIGQUIT` - semnalul cu codul `3` care trimite containerului pentru oprire imediată.

Valoarea semnalului de oprire poate fi suprascrisă la rularea containerului cu ajutorul opțiunii `--stop-signal` a comenzii `docker run`:

```bash
docker run --stop-signal=SIGKILL myimage
```

## Bibliografie

1. [Dockerfile reference, docker.com](https://docs.docker.com/engine/reference/builder/)
2. [vsupalov, __Docker ARG vs ENV__, vsupalov.com](https://vsupalov.com/docker-arg-vs-env/)
3. [Docker object labels, docker.com](https://docs.docker.com/config/labels-custom-metadata/)
4. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
