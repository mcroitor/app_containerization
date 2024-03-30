# Particularitățile configurării clusterului de containere

- [Particularitățile configurării clusterului de containere](#particularitățile-configurării-clusterului-de-containere)
  - [Argumente la construirea imaginii](#argumente-la-construirea-imaginii)
  - [Variabile de mediu](#variabile-de-mediu)
  - [Limitarea resurselor](#limitarea-resurselor)
  - [Acces către procesorul grafic](#acces-către-procesorul-grafic)
  - [Verificarea stării containerului](#verificarea-stării-containerului)
  - [Bibliografie](#bibliografie)

## Argumente la construirea imaginii

Cum era deja menționat la descrierea fișierului Dockerfile, la construirea imaginii se pot transmite argumente. Acest lucru permite controlul procesului de construire a imaginii, de exemplu, transmiterea versiunii aplicației sau a altor parametri. În Docker Compose argumentele pot fi definite în fișierul `docker-compose.yml` cu ajutorul cheii `build.args`:

```yaml
version: '3.9'

services:
  web:
    build:
      context: .
      args:
        - APP_VERSION=1.0.0
```

## Variabile de mediu

La pornirea serviciului în container se pot transmite variabile de mediu. Acest lucru permite controlul comportamentului containerului, de exemplu, transmiterea parametrilor de conectare la baza de date sau a altor parametri.

În Docker Compose variabilele de mediu se pot transmite în fișierul `docker-compose.yml` cu ajutorul cheii `environment`:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      - DB_HOST=db
      - DB_PORT=5432
```

Totodată, variabilele de mediu se pot defini sub forma unui dicționar:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      DB_HOST: db
      DB_PORT: 5432
```

Nu întotdeauna este convenabil să se stocheze variabilele de mediu în fișierul `docker-compose.yml`. De aceea, de multe ori acestea sunt plăsate într-un fișier separat. Dacă variabilele de mediu sunt definite în fișierul `.env`, atunci Docker Compose le va înlocui automat în fișierul `docker-compose.yml`.

Exemplu de fișier `.env`:

```env
DB_HOST=db
DB_PORT=5432
```

Acum în fișierul `docker-compose.yml` se pot folosi variabilele de mediu:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    environment:
      - DB_HOST=${DB_HOST}
      - DB_PORT=${DB_PORT}
```

De asemenea, se pot specifica fișiere cu variabile de mediu în fișierul `docker-compose.yml` cu ajutorul cheii `env_file`, iar se pot specifica mai multe fișiere cu variabile de mediu:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    env_file:
      - .env
      - runtime.env
```

Trebuie să ținem cont că variabilele de mediu transmise în fișierul `docker-compose.yml` suprascriu variabilele de mediu transmise în fișierul `.env`.

În plus, nu se recomandă să se stocheze în fișierul `.env` parole și alte date secrete. Pentru stocarea datelor secrete se recomandă utilizarea Docker Secrets sau a altor instrumente de gestionare a secretelor.

## Limitarea resurselor

Implicit containerele în Docker Compose au acces la toate resursele gazdei. Un astfel de acces nelimitat la resurse poate duce la lipsa de resurse pentru alte containere și, în consecință, la competiția pentru resurse. Stabilirea limitelor clare pentru resurse permite evitarea acestor probleme.

Acces către memoria operativă și procesor poate fi limitat pentru container. În Docker Compose acest lucru se poate face cu ajutorul cheii `deploy.resources`:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 1G
        reservations:
          cpus: '0.1'
          memory: 0.5G
```

În exemplu dat containerului `web` îi este disponibil nu mai mult de 0.5 procesor și 1 GB de memorie. În plus, la pornire containerului este rezervat nu mai puțin de 0.1 procesor și 0.5 GB de memorie.

## Acces către procesorul grafic

Pentru container se poate defini accesul la procesorul grafic (GPU). În Docker Compose acest lucru se poate face cu ajutorul cheii `deploy.resources`:

```yaml
version: '3.9'

services:
  neural_network:
    image: neuwrl:latest
    deploy:
      resources:
        reservations:
          devices:
            - capabilities: [gpu]
              count: 1
              driver: nvidia
```

Acest exemplu indică faptul că pentru containerul `neural_network` este necesar accesul la procesorul grafic. Containerului îi este rezervat 1 procesor grafic. Pentru accesul la procesorul grafic se folosește driverul `nvidia`.

În prezent sunt acceptate următoarele parametri pentru `capabilities`:

- `gpu` - acces către procesorul grafic;
- `tpu` - acces către procesorul tensorial;

Pot fi specificate și alte parametri pentru `capabilities`, care depind de driverul procesorului grafic, de exemplu, pentru utilizarea acceleratorului CUDA al driverului `nvidia` poate fi folosit parametrul `nvidia-compute`.

## Verificarea stării containerului

De asemenea se poate verifica starea containerului după pornirea acestuia. De exemplu, se poate verifica că containerul a pornit cu succes și este pregătit pentru lucru. În Docker Compose acest lucru se poate face cu ajutorul cheii `healthcheck`:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
```

După pornirea acestui cluster de containere Docker Compose va verifica starea serviciului `web` cu ajutorul comenzii `curl -f http://localhost` la fiecare 30 de secunde. Dacă containerul nu răspunde la cerere în decurs de 10 secunde, Docker Compose va repeta cererea de 3 ori. Dacă containerul nu răspunde la cerere după 3 încercări, Docker Compose îl va reporni.

Uneori serviciile în containere încearcă să folosească mai multe resurse decât le sunt disponibile. În acest caz poate apărea eroarea `OOME` (Out Of Memory Error). Pentru prevenirea acestei erori se pot folosi reguli de repornire a containerului:

```yaml
version: '3.9'

services:
  web:
    image: myapp:latest
    deploy:
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
```

În acest exemplu containerul va fi repornit în caz de eroare `OOME` nu mai mult de 3 ori cu un interval de 5 secunde. Dacă containerul nu pornește după 3 încercări, Docker Compose îl va opri și va afișa un mesaj de eroare. Condițiile de repornire a containerului pot fi următoarele:

- `none` - containerul nu va fi repornit;
- `on-failure` - containerul va fi repornit în caz de eroare;
- `any` - containerul va fi repornit în orice caz.

## Bibliografie

1. [Docker Compose file reference](https://docs.docker.com/compose/compose-file/)
