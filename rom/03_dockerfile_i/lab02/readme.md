# Lucrare de laborator Nr2: Prima aplicație Docker

## Scop

Aceasta lucrare de laborator familiarizează cu elementele de bază ale containerizării și pregătește spațiul de lucru pentru următoarele lucrări de laborator.

## Sarcina

Instalarea Docker Desktop și verificarea funcționării acestuia.

## Pregătire

Descărcați și instalați [Docker Desktop](https://www.docker.com/products/docker-desktop/).

## Executare

Creați un repozitoriu `containers02` și clonați-l pe computerul dvs.

Creați în directorul `containers02` fișierul `Dockerfile` cu următorul conținut:

```dockerfile
FROM debian:latest
COPY ./site/ /var/www/html/
CMD ["sh", "-c", "echo hello from $HOSTNAME"]
```

В той же папке проекта создайте папку `site`. В новой папке создайте файл `index.html` с произвольным
содержимым.

În aceeași director de proiect creați directorul `site`. În noul director creați fișierul `index.html` cu conținut arbitrar.

## Pornire și testare

Deschideți terminalul în directorul `containers02` și executați comanda:

```bash
docker build -t containers02 .
```

-Cât timp a durat crearea imaginii?_

Executați comanda pentru a porni containerul:

```bash
docker run --name containers02 containers02
```

_Ce a fost afișat în consolă?_

Ștergeți containerul și porniți-l din nou, executând comenzile:

```bash
docker rm containers02
docker run -ti --name containers02 containers02 bash
```

În fereastra deschisă, executați comenzile:

```bash
cd /var/www/html/
ls -l
```

_Ce este afișat pe ecran?_

Închideți fereastra cu comanda `exit`.

Creați în directorul proiectului fișierul `README.md` cu descrierea proiectului. Descrierea proiectului trebuie să conțină:

1. Denumirea lucrării de laborator.
2. Scopul lucrării.
3. Sarcina.
4. Descrierea executării lucrării cu răspunsuri la întrebări.
5. Concluzii.
6. Bibliografie.

## Prezentare

Pentru prezentarea lucrului efectuat indicați referința la repozitoriul creat în răspuns la sarcina.

## Modul de evaluare
