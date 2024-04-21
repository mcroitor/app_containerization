# Optimizarea imaginii containerului

- [Optimizarea imaginii containerului](#optimizarea-imaginii-containerului)
  - [Obținerea informațiilor despre dimensiunea imaginii](#obținerea-informațiilor-despre-dimensiunea-imaginii)
  - [Imaginea de bază minimă](#imaginea-de-bază-minimă)
    - [Construirea în mai multe etape](#construirea-în-mai-multe-etape)
    - [Metoda veche de construcție a imaginilor](#metoda-veche-de-construcție-a-imaginilor)
      - [Exemplu](#exemplu)
    - [Principiile de bază ale construcției în mai multe etape](#principiile-de-bază-ale-construcției-în-mai-multe-etape)
      - [Exemplu multi-stage build](#exemplu-multi-stage-build)
    - [Forma generală a construcției în mai multe etape](#forma-generală-a-construcției-în-mai-multe-etape)
  - [Ștergerea dependențelor neutilizate și a fișierelor temporare](#ștergerea-dependențelor-neutilizate-și-a-fișierelor-temporare)
  - [Reducerea numărului de straturi](#reducerea-numărului-de-straturi)
  - [Repachetarea imaginii](#repachetarea-imaginii)
  - [Utilizarea .dockerignore](#utilizarea-dockerignore)
  - [Păstrarea datelor în afara imaginii](#păstrarea-datelor-în-afara-imaginii)
  - [Utilizarea cache-ului pentru straturile imaginii](#utilizarea-cache-ului-pentru-straturile-imaginii)
  - [Bibliotrafie](#bibliotrafie)

Simplitatea determinării imaginilor containerelor permite crearea și utilizarea lor rapidă, ceea ce duce la erori și crearea de imagini inutile. Este obișnuit să se creeze imagini de dimensiuni de câteva gigabyte, ceea ce este clar o greșeală. Cel mai probabil, această imagine conține date care pot fi mutate în volume externe sau nu sunt necesare; dependențe inutile care pot fi eliminate; fișiere temporare și cache care pot fi șterse; etc.

Un volum mare al imaginii are următoarele dezavantaje:

- timpul lung de încărcare a imaginii din depozit;
- ocupă mai mult spațiu pe disc;
- ocupă mai mult spațiu în memorie.

Adică o imagine mare necesită mai multe resurse pentru încărcare, stocare și rulare. Prin urmare, optimizarea imaginii containerului este un pas important în dezvoltarea și utilizarea containerelor.

## Obținerea informațiilor despre dimensiunea imaginii

Pentru a vizualiza dimensiunea imaginii, puteți folosi comanda `docker images` (sau `docker image ls`). Executarea acestei comenzi va afișa o listă de imagini, inclusiv dimensiunile lor. De exemplu:

```shell
$ docker images
docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED      SIZE
lab07        latest    4e96acf7022c   5 days ago   468MB
<none>       <none>    3de1890f5bde   5 days ago   468MB
myphp        latest    ec1fdb037c54   8 days ago   162MB
```

Obținerea informațiilor despre straturile imaginii poate fi realizată cu ajutorul comenzii `docker history`. De exemplu:

```shell
$ docker history myphp
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
ec1fdb037c54   8 days ago   CMD ["/app/php" "-v"]                           0B        buildkit.dockerfile.v0
<missing>      8 days ago   WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicui18n.so…   3.31MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicudata.so…   31.3MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libicuuc.so.7…   2.08MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libsqlite3.so…   1.44MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libgmp.so.10 …   529kB     buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libpspell.so.…   14kB      buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libmariadb.so…   337kB     buildkit.dockerfile.v0
<missing>      8 days ago   COPY /usr/lib/x86_64-linux-gnu/libxml2.so.2 …   1.75MB    buildkit.dockerfile.v0
<missing>      8 days ago   COPY /app/php/sapi/cli/php /app/php # buildk…   40.7MB    buildkit.dockerfile.v0
<missing>      9 days ago   /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>      9 days ago   /bin/sh -c #(nop) ADD file:5d6b639e8b6bcc011…   80.6MB
```

## Imaginea de bază minimă

Crearea imaginii containerului începe cu alegerea imaginii de bază. Cu cât imaginea de bază are o dimensiune mai mică, cu atât va fi mai mică dimensiunea imaginii finale. De exemplu, puteți folosi imaginea `alpine`, care are o dimensiune de aproximativ 7 MB, în loc de `ubuntu`, care are o dimensiune de aproximativ 80 MB.

Deasemenea, puteți folosi imaginea `scratch`, care nu conține nimic, și adăugați doar fișierele și dependențele necesare. Cu toate acestea, de multe ori dezvoltatorii au nevoie de anumite proprietăți ale sistemului de operare în timpul dezvoltării aplicației lor, așa că se opresc la imaginea `alpine` ca la o imagine de bază minimă.

Pentru probleme concrete pot fi alese imagini specializate, care adesea oferă versiuni optimizate. De exemplu, pentru Python puteți folosi imaginea `python:alpine`, care conține un set minim de pachete pentru lucru cu Python.

### Construirea în mai multe etape

Construirea în mai multe etape permite reducerea dimensiunii imaginii containerului, deoarece în imaginea finală rămân doar fișierele și dependențele necesare. De exemplu, puteți folosi o imagine cu compilator pentru construirea aplicației, iar apoi copiați doar fișierul executabil în imaginea finală.

Pentru a crea o imagine cu adevărat eficientă, mică și sigură, se recomandă să se efectueze procesul de construcție în mai multe etape. Fiecare etapă de construcție este efectuată într-un container separat, iar rezultatul său este salvat într-o imagine. În cele din urmă, în loc de o singură imagine mare, sunt create mai multe intermediare, care conțin rezultatele fiecărei etape. În imaginea finală vor fi doar fișierele necesare pentru funcționarea aplicației.

### Metoda veche de construcție a imaginilor

Un proces de dezvoltare a unui produs software include următoarele etape:

- Configurarea mediului
- Scrierea codului
- Compilarea și construirea
- Testarea
- Implementarea

În mod asemănător, construcția imaginii Docker include următoarele etape:

- Configurarea mediului
- Instalarea dependențelor
- Construirea aplicației
- Testarea
- Implementarea containerului

Pentru fiecare etapă se creează un container separat, care efectuează o anumită acțiune. De exemplu, pentru instalarea dependențelor se folosește un container cu un compilator și biblioteci instalate, pentru construirea aplicației - un container cu un compilator și biblioteci instalate, pentru testare - un container cu un framework de testare instalat etc. La sfârșit, rezultatele fiecărui container sunt combinate într-o singură imagine.

Din acest motiv pentru fiecare etapa se crea un `Dockerfile` separat, care efectua o anumită acțiune, și un script care combina rezultatele fiecărui container într-o singură imagine.

#### Exemplu

Fie dată o aplicație CPP (fișier `helloworld.cpp`), pe care dorim să o rulăm într-un container.

```cpp
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

Pentru a construi imaginea, creăm următoarele fișiere:

- `Dockerfile.build` - pentru construirea aplicației
- `Dockerfile.run` - pentru rularea aplicației
- `build.sh` - script pentru construirea imaginii

`Dockefile.build`:

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld -static
```

`Dockerfile.run`:

```Dockerfile
FROM debian:latest

WORKDIR /app

COPY app/helloworld .

CMD ["./helloworld"]
```

`build.sh`:

```bash
#!/bin/bash
echo "Building helloworld-build image..."
docker build -t helloworld-build -f Dockerfile.build .

echo "Extracting helloworld binary..."
mkdir -p app
docker create --name extract helloworld-build
docker cp extract:/app/helloworld app/helloworld
docker rm -f extract

echo "Building helloworld-run image..."
docker build -t helloworld-run -f Dockerfile.run .
rm -f app/helloworld
```

La pornirea scriptului `build.sh`:

- se creează imaginea `helloworld-build`, care construiește aplicația;
- se rulează containerul `extract`, în care aplicația construită este copiată pe mașina gazdă;
- se șterge containerul `extract`;
- se creează imaginea `helloworld-run`, care rulează aplicația.

Utilizarea construcției în mai multe etape permite simplificarea procesului de construcție a imaginii și reducerea dimensiunii acesteia.

### Principiile de bază ale construcției în mai multe etape

Construirea în mai multe etape permite crearea imaginilor care conțin doar fișierele necesare pentru funcționarea aplicației, folosind un singur `Dockerfile`. Pentru aceasta se folosesc următoarele principii:

- Fiecare instrucțiune folosește o imagine de bază și setează o etapă de construcție;
- Fiecare etapă de construcție este efectuată într-un container separat;
- Rezultatul fiecărei etape este salvat într-o imagine;
- Se pot copia fișiere dintr-o etapă în alta.

#### Exemplu multi-stage build

În acest caz, exemplul nostru poate fi simplificat la un singur `Dockerfile`:

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld -static

FROM debian:latest

WORKDIR /app

COPY --from=0 app/helloworld .

CMD ["./helloworld"]
```

Construirea imaginii în acest caz se reduce la o singură comandă:

```bash
docker build -t helloworld-run .
```

Această este posibil datorită faptului că instrucția `COPY` poate copia fișiere dintr-o etapă în alta, fiind necesar să se specifice numărul etapei din care trebuie să se copieze fișierele.

Fiecărei etape i se atribuie un număr, începând de la 0. Totodată fiecărei etape poate fi atribuit un nume, care poate fi folosit în locul numărului etapei.

```Dockerfile
FROM gcc:latest AS build

WORKDIR /app

COPY helloworld.cpp .

RUN g++ helloworld.cpp -o helloworld

FROM debian:latest AS run

WORKDIR /app

COPY --from=build app/helloworld .

CMD ["./helloworld"]
```

### Forma generală a construcției în mai multe etape

Se face clar că construcția în mai multe etape poate fi utilizată nu numai pentru construirea aplicațiilor, ci și pentru alte sarcini: testare, analiză a codului, construirea documentației etc.

Forma generală a construcției în mai multe etape este următoarea:

```Dockerfile
# crearea imaginii de bază
FROM debian:latest AS base

# ...

# instalarea dependențelor
FROM base AS dependencies

# ...

# construirea aplicației
FROM dependencies AS build

# ...

# testare
FROM build AS test

# ...

# amplasarea aplicatiei
FROM debian

# copierea aplicatiei din imagine build
COPY --from=build /app/app /app/app

# pornirea aplicatiei
CMD ["./app"]
```

## Ștergerea dependențelor neutilizate și a fișierelor temporare

Ștergerea dependențelor neutilizate permite reducerea dimensiunii imaginii containerului. De exemplu, după instalarea pachetelor puteți șterge fișierele temporare și cache-ul pentru a reduce dimensiunea imaginii.

Această procedură are sens în cazul unirii straturilor imaginii sau în cazul repachetării imaginii. În caz contrar, ștergerea fișierelor temporare și a cache-ului nu va duce la reducerea dimensiunii imaginii.

## Reducerea numărului de straturi

Imaginea containerului păstrează informația despre fiecare strat, ceea ce mărește dimensiunea sa. În plus, fiecare strat al imaginii este reprezentat printr-o imagine intermediară, stocarea căreia necesită spațiu suplimentar pe disc.

Unirea comenzilor într-un singur strat permite reducerea numărului de imagini intermediare, precum și reducerea dimensiunii imaginii prin reducerea cantității de metadate. În plus, nu se poate crea o imagine mai mică dacă imaginile intermediare au dimensiuni mai mari.

În loc să creați un strat temporar pentru instalarea pachetelor și ștergerea cache-ului, puteți executa toate comenzile într-un singur strat.

De exemplu, imaginea construită pe baza `Dockefile`:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y php-cli
```

va avea aproximativ aceeași dimensiune ca imaginea construită pe baza `Dockerfile`:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y php-cli
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

Cu toate acestea, unirea comenzilor într-un singur strat permite reducerea dimensiunii imaginii:

```dockerfile
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y php-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

## Repachetarea imaginii

Repachetarea imaginii permite a combina toate straturi ale imaginii într-un strat, ce micșorează volumul imaginii

> **Note:** Repachetarea imaginii duce la pierderea avantajului de partajare a straturilor imaginii între diferite imagini. În plus, se pierd toate metadatele imaginii, precum și porturile deschise, variabilele de mediu etc. Acest lucru poate fi folosit doar dacă încercați să optimizați o imagine străină.

Repachetarea imaginii se bazează pe faptul că la crearea containerului se combină toate straturile imaginii într-un singur strat. De exemplu, puteți crea un container din imagine și apoi crea o imagine din container.

Dacă imaginea se numește `myphp`, atunci repachetarea imaginii va arăta astfel:

```shell
# Crearea containerului
$ docker create --name myphp myphp
# Crearea imaginii din container
$ docker export myphp | docker import - myphp:optimized
```

## Utilizarea .dockerignore

Utilizarea fișierului `.dockerignore` permite excluderea fișierelor și directoarelor care nu sunt necesare pentru crearea imaginii. De exemplu, puteți exclude fișierele temporare, cache-ul, fișierele de configurare, fișierele de log etc.

Un exemplu de fișier `.dockerignore`:

```dockerfile
# .dockerignore
.git
.vscode
__pycache__
*.pyc
```

## Păstrarea datelor în afara imaginii

Păstrarea datelor în afara imaginii permite reducerea dimensiunii imaginii containerului. De exemplu, puteți utiliza volume externe pentru stocarea datelor, cum ar fi fișierele de configurare, fișierele de log, fișierele temporare etc.

## Utilizarea cache-ului pentru straturile imaginii

Docker folosește cache-ul pentru straturile imaginii, ceea ce permite accelerarea construirii imaginii. Cu toate acestea, cache-ul straturilor imaginii duce la consumarea spațiului pe disc. Pentru a utiliza cache-ul eficient, trebuie să țineți cont de ordinea comenzilor în `Dockerfile` și să utilizați construirea în mai multe etape.

La modificarea comenzilor din `Dockerfile`, toate straturile imaginii vor fi reconstruite, ceea ce va duce la creșterea timpului de construire a imaginii. Prin urmare, trebuie să executați mai întâi comenzile care sunt mai puțin susceptibile de modificare (de exemplu, configurarea mediului), iar apoi să executați comenzile care sunt mai susceptibile de modificare (copierea aplicației).

În exemplul dat, imaginea va fi reconstruită complet la fiecare modificare a aplicației:

```dockerfile
FROM nginx

COPY . /usr/share/nginx/html
RUN apt-get update && apt-get install -y php-cli
```

Dacă se schimbă cu locul comenzile `RUN` și `COPY`, atunci la modificarea aplicației imaginea va fi reconstruită doar parțial, ceea ce va accelera construirea imaginii:

```dockerfile
FROM nginx

RUN apt-get update && apt-get install -y php-cli

COPY . /usr/share/nginx/html
```

## Bibliotrafie

1. [Predrag Rakić, Docker Image Size – Does It Matter?, semaphoreci.com, 2021-03-30](https://semaphoreci.com/blog/2018/03/14/docker-image-size.html)
2. [Rafael Benevides, Keep it small: a closer look at Docker image sizing, RedHat, 2016-03-09](https://developers.redhat.com/blog/2016/03/09/more-about-docker-images-size)
3. [Bibin Wilson, Shishir Khandelwal, How to Reduce Docker Image Size: 6 Optimization Methods, devopscube.com, 2023-08-22](https://devopscube.com/reduce-docker-image-size/)
4. [Jeff Hale, Slimming Down Your Docker Images, towardsdatascience.com, 2019-01-31](https://towardsdatascience.com/slimming-down-your-docker-images-275f0ca9337e)
5. [pxeno, Полное руководство по созданию Docker-образа для обслуживания системы машинного обучения в продакшене, habr.com](https://habr.com/ru/companies/vk/articles/548480/)
6. [BOOTLOADER, Многоэтапные (multi-stage builds) сборки в Docker, habr.com](https://habr.com/ru/articles/349802/)
7. [Использование многоэтапных (multi-stage) сборок в Docker, cloud.croc.ru](https://cloud.croc.ru/blog/about-technologies/multi-stage-v-docker/)
8. [Docker, Multi-stage builds, docs.docker.com](https://docs.docker.com/build/building/multi-stage/)