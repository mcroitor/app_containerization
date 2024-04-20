# Optimizarea imaginii containerului

- [Optimizarea imaginii containerului](#optimizarea-imaginii-containerului)
  - [Obținerea informațiilor despre dimensiunea imaginii](#obținerea-informațiilor-despre-dimensiunea-imaginii)
  - [Imaginea de bază minimă](#imaginea-de-bază-minimă)
  - [Construirea în mai multe etape](#construirea-în-mai-multe-etape)
  - [Ștergerea dependențelor neutilizate și a fișierelor temporare](#ștergerea-dependențelor-neutilizate-și-a-fișierelor-temporare)
  - [Reducerea numărului de straturi](#reducerea-numărului-de-straturi)
  - [Repachearea imaginii](#repachearea-imaginii)
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

## Construirea în mai multe etape

Construirea în mai multe etape permite reducerea dimensiunii imaginii containerului, deoarece în imaginea finală rămân doar fișierele și dependențele necesare. De exemplu, puteți folosi o imagine cu compilator pentru construirea aplicației, iar apoi copiați doar fișierul executabil în imaginea finală.

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

## Repachearea imaginii

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
