# Construirea imaginilor Docker în mai multe etape

- [Construirea imaginilor Docker în mai multe etape](#construirea-imaginilor-docker-în-mai-multe-etape)
  - [Problema eficienței containerelor](#problema-eficienței-containerelor)
  - [Metoda veche de construcție a imaginilor](#metoda-veche-de-construcție-a-imaginilor)
    - [Exemplu](#exemplu)
  - [Principiile de bază ale construcției în mai multe etape](#principiile-de-bază-ale-construcției-în-mai-multe-etape)
    - [Exemplu multi-stage build](#exemplu-multi-stage-build)
  - [Общий вид многоэтапной сборки](#общий-вид-многоэтапной-сборки)
  - [Библиография](#библиография)

## Problema eficienței containerelor

Adesea, la crearea imaginilor Docker, apare problema eficienței: imaginile devin prea mari, ceea ce încetinește descărcarea lor și crește consumul de resurse. Acest lucru se datorează faptului că în imagine sunt incluse toate fișierele necesare pentru funcționarea aplicației, inclusiv cele care nu sunt utilizate în timpul funcționării aplicației. De exemplu, în imagine pot fi incluse coduri sursă, teste, documentație etc. Dimensiunile imaginii pot ajunge la câteva gigabyte.

Pentru a crea o imagine cu adevărat eficientă, mică și sigură, se recomandă să se efectueze procesul de construcție în mai multe etape. Fiecare etapă de construcție este efectuată într-un container separat, iar rezultatul său este salvat într-o imagine. În cele din urmă, în loc de o singură imagine mare, sunt create mai multe intermediare, care conțin rezultatele fiecărei etape. În imaginea finală vor fi doar fișierele necesare pentru funcționarea aplicației.

## Metoda veche de construcție a imaginilor

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

### Exemplu

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

## Principiile de bază ale construcției în mai multe etape

Construirea în mai multe etape permite crearea imaginilor care conțin doar fișierele necesare pentru funcționarea aplicației, folosind un singur `Dockerfile`. Pentru aceasta se folosesc următoarele principii:

- Fiecare instrucțiune folosește o imagine de bază și setează o etapă de construcție;
- Fiecare etapă de construcție este efectuată într-un container separat;
- Rezultatul fiecărei etape este salvat într-o imagine;
- Se pot copia fișiere dintr-o etapă în alta.

### Exemplu multi-stage build

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

Сборка образа в этом случае сокращается до одной команды:

```bash
docker build -t helloworld-run .
```

Это возможно благодаря тому что инструкция `COPY` может копировать файлы из одного этапа в другой, при этом необходимо указать номер этапа, из которого нужно скопировать файлы.

Кроме того, можно этапам сборки задавать имена, чтобы обращаться к ним по имени:

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

## Общий вид многоэтапной сборки

Естественно, многоэтапная сборка позволяет не только собирать приложения, но и выполнять другие задачи: тестирование, анализ кода, сборку документации и т.д.

В общем виде многоэтапная сборка может выглядеть следующим образом:

```Dockerfile
# создание базового образа
FROM debian:latest AS base

# ...

# установка зависимостей
FROM base AS dependencies

# ...

# сборка приложения
FROM dependencies AS build

# ...

# тестирование приложения
FROM build AS test

# ...

# развертывание приложения
FROM debian

# копирование файлов из других этапов
COPY --from=build /app/app /app/app

# запуск приложения
CMD ["./app"]
```

## Библиография

1. [pxeno, Полное руководство по созданию Docker-образа для обслуживания системы машинного обучения в продакшене, habr.com](https://habr.com/ru/companies/vk/articles/548480/)
2. [BOOTLOADER, Многоэтапные (multi-stage builds) сборки в Docker, habr.com](https://habr.com/ru/articles/349802/)
3. [Использование многоэтапных (multi-stage) сборок в Docker, cloud.croc.ru](https://cloud.croc.ru/blog/about-technologies/multi-stage-v-docker/)
4. [Docker, Multi-stage builds, docs.docker.com](https://docs.docker.com/build/building/multi-stage/)
