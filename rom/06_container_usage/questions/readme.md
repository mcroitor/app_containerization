# Întrebări pentru "Interacțiunea containerelor"

1. Vizualizarea listei de volume existente se poate face cu ajutorul comenzii:
   [x] `docker volume ls`
   [ ] `docker volume list`
   [ ] `docker volume show`
   [ ] `docker volume inspect`
2. Pentru a crea un volum cu numele `opt` se folosește comanda:
   [x] `docker volume create opt`
   [ ] `docker volume create --name opt`
   [ ] `docker volume make opt`
   [ ] `docker volume create name=opt`
3. Pentru a vizualiza informații despre volumul `opt` se folosește comanda:
   [x] `docker volume inspect opt`
   [ ] `docker volume show opt`
   [ ] `docker volume info opt`
   [ ] `docker volume ls opt`
4. Pentru a șterge volumul `opt` se folosește comanda:
   [x] `docker volume rm opt`
   [ ] `docker volume remove opt`
   [ ] `docker volume delete opt`
   [ ] `docker volume prune opt`
5. Pentru a șterge toate volumele neutilizate se poate folosi comanda:
   [x] `docker volume prune`
   [ ] `docker volume remove`
   [ ] `docker volume clear`
   [ ] `docker volume rm`
6. Vizualizarea listei de rețele se poate face cu ajutorul comenzii:
   [x] `docker network ls`
   [ ] `docker network list`
   [ ] `docker network show`
   [ ] `docker network inspect`
7. Pentru a crea o rețea cu numele `local` se folosește comanda:
   [x] `docker network create local`
   [ ] `docker network make --name local`
   [ ] `docker network make local`
   [ ] `docker network create name=local`
8. Pentru a vizualiza informații despre rețeaua `local` se folosește comanda:
   [x] `docker network inspect local`
   [ ] `docker network show local`
   [ ] `docker network info local`
   [ ] `docker network ls local`
9. Pentru a șterge rețeaua `local` se folosește comanda:
   [x] `docker network rm local`
   [ ] `docker network remove local`
   [ ] `docker network delete local`
   [ ] `docker network prune local`
10. Pentru a conecta containerul `frontend` la rețeaua `local` se poate folosi comanda:
   [x] `docker network connect local frontend`
   [ ] `docker network connect frontend local`
   [ ] `docker network attach frontend local`
   [ ] `docker network attach local frontend`
11. Pentru a deconecta containerul `frontend` de la rețeaua `local` se poate folosi comanda:
   [x] `docker network disconnect local frontend`
   [ ] `docker network disconnect frontend local`
   [ ] `docker network detach frontend local`
   [ ] `docker network detach local frontend`
12. Pentru a șterge toate rețelele neutilizate se poate folosi comanda:
   [x] `docker network prune`
   [ ] `docker network remove`
   [ ] `docker network clear`
   [ ] `docker network rm`

Întrebări de tip _răspuns scurt_:

1. Pentru a crea containerul `webserver` pe baza imaginii `webserver` cu redirecționarea portului `80` containerului pe portul `8000` gazdei se folosește comanda:
   - `docker create --name webserver -p 8000:80 webserver`
   - `docker create --name webserver --port 8000:80 webserver`
   - `docker create -p 8000:80 --name webserver webserver`
   - `docker create --port 8000:80 --name webserver webserver`
2. Pentru a crea și rula containerul `webserver` pe baza imaginii `webserver` cu redirecționarea portului `80` containerului pe portul `8080` gazdei se folosește comanda:
   - `docker run --name webserver -p 8080:80 webserver`
   - `docker run -p 8080:80 --name webserver webserver`
   - `docker run --name webserver --port 8080:80 webserver`
   - `docker run --port 8080:80 --name webserver webserver`
3. Pentru a crea și rula containerul `webserver` pe baza imaginii `webserver` cu montarea volumului `opt` în directorul `/opt` al containerului se folosește comanda:
   - `docker run -v opt:/opt --name webserver webserver`
   - `docker run --volume opt:/opt --name webserver webserver`
   - `docker run --name webserver -v opt:/opt webserver`
   - `docker run --name webserver --volume opt:/opt webserver`
4. Pentru a crea și rula containerul `nodeapp` pe baza imaginii `nodeapp` cu montarea volumului `app` în directorul `/app` al containerului se folosește comanda:
   - `docker run -v app:/app --name nodeapp nodeapp`
   - `docker run --volume app:/app --name nodeapp nodeapp`
   - `docker run --name nodeapp -v app:/app nodeapp`
   - `docker run --name nodeapp --volume app:/app nodeapp`
5. Pentru a crea și rula containerul `webserver` pe baza imaginii `webserver` cu conectarea la rețeaua `local` se folosește comanda:
   - `docker run --name webserver --network local webserver`
   - `docker run --network local --name webserver webserver`
6. Pentru a crea și rula containerul `nodeapp` pe baza imaginii `nodeapp` cu conectarea la rețeaua `backend` se folosește comanda:
   - `docker run --name nodeapp --network backend nodeapp`
   - `docker run --network backend --name nodeapp nodeapp`
7. Pentru a șterge rețeaua `local` se folosește comanda:
   - `docker network rm local`
8. În Docker pentru a crea o rețea cu numele `local` se folosește comanda:
   - `docker network create local`
9. Pentru a adăuga containerul `frontend` la rețeaua `local` se folosește comanda:
   - `docker network connect local frontend`
10. În Docker pentru a crea un volum cu numele `opt` se folosește comanda:
    - `docker volume create opt`
11. Pentru a șterge volumul `opt` se folosește comanda:
    - `docker volume rm opt`
