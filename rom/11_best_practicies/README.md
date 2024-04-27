# Рекомендации при разработке контейнеров
# Bune practici pentru dezvoltarea containerelor

- [Рекомендации при разработке контейнеров](#рекомендации-при-разработке-контейнеров)
- [Bune practici pentru dezvoltarea containerelor](#bune-practici-pentru-dezvoltarea-containerelor)
  - [Privilegii excesive](#privilegii-excesive)
    - [Executarea aplicațiilor din partea unui utilizator](#executarea-aplicațiilor-din-partea-unui-utilizator)
    - [Interzicerea modificării fișierelor executabile](#interzicerea-modificării-fișierelor-executabile)
  - [Dependințe](#dependințe)
    - [Utilizarea construcțiilor în mai multe etape](#utilizarea-construcțiilor-în-mai-multe-etape)
    - [Imagini de bază verificate](#imagini-de-bază-verificate)
    - [Îmbunătățirea la timp a imaginilor](#îmbunătățirea-la-timp-a-imaginilor)
    - [Porturi deschise](#porturi-deschise)
  - [Securizarea datelor](#securizarea-datelor)
    - [Datele sensibile](#datele-sensibile)
    - [ADD și COPY](#add-și-copy)
    - [Contextul construcției](#contextul-construcției)
    - [Registrele](#registrele)
  - [Altele](#altele)
    - [Ordinea straturilor](#ordinea-straturilor)
    - [Metadate](#metadate)
    - [Verificarea imaginilor pe vulnerabilități](#verificarea-imaginilor-pe-vulnerabilități)
  - [Concluzii](#concluzii)
  - [Bibliografie](#bibliografie)

Un fișier Dockerfile bine pregătit elimină necesitatea de a folosi containere privilegiate, de a deschide porturi care nu sunt necesare, de a include pachete inutile și de a evita scurgerile de date sensibile. Aceste probleme trebuie abordate de la început pentru a reduce eforturile de întreținere a aplicațiilor dezvoltate.

## Privilegii excesive

### Executarea aplicațiilor din partea unui utilizator

__Rulați aplicațiile din partea unui utilizator cu privilegii minime.__

Conform raportului [Sysdig 2021 container security and usage report](https://sysdig.com/blog/sysdig-2021-container-security-usage-report), 58% din toate containerele sunt rulate de la utilizatorul `root`. Utilizarea `root` în containere poate duce la vulnerabilități de securitate grave. Prin urmare, se recomandă rularea aplicațiilor de la un utilizator cu privilegii minime, folosind directiva `USER` în Dockerfile.

Pentru a configura un utilizator neprivilegiat, trebuie să efectuați câțiva pași suplimentari:

- asigurați-vă că utilizatorul există în imagine (creați-l);
- setați permisiunile necesare pentru fișierele și directoarele cu care lucrează aplicația.

Un exemplu de Dockerfile:

```Dockerfile
FROM ubuntu:20.04

# crearea utilizatorului myuser
RUN adduser -D myuser && \
    chown -R myuser:myuser /app-data

# copierea aplicației
COPY app /app

# setarea utilizatorului de lucru
USER myuser

ENTRYPOINT ["/app"]
```

### Interzicerea modificării fișierelor executabile

__Interziceți modificarea fișierelor executabile.__

În containere Docker fișierele marcate cu atributul `+x` pot fi modificate în timpul rulării. Acest lucru poate duce la modificarea fișierelor executabile și, ca urmare, la vulnerabilități de securitate. Pentru a preveni modificarea fișierelor executabile, se recomandă utilizarea directivei `COPY` în loc de `ADD` și setarea atributelor fișierelor după copiere.

Cea mai bună practică este să setați `root` ca proprietar al fișierelor executabile, astfel încât acestea să nu fie disponibile pentru scriere pentru alți utilizatori. În acest caz, containerul va fi imutabil și sigur, permițând evitarea situațiilor în care aplicația lansată este modificată accidental sau intenționat.

Utilizatorul containerului destul să aibă drepturi doar pentru citire și executare a fișierelor.

```Dockerfile
FROM ubuntu:20.04

# Crearea utilizatorului myuser
RUN adduser -D myuser && \
    chown -R myuser:myuser /app-data

# Copierea aplicației
COPY app /app

RUN chmod +x-w /app

# Setarea utilizatorului de lucru
USER myuser

ENTRYPOINT ["/app"]
```

## Dependințe

__Încercați să minimizați dimensiunea imaginii.__

Nu includeți pachete necesare și nu deschideți porturi inutile - aceasta poate crește suprafața de atac. Cu cât includeți mai multe componente în container, cu atât sistemul dvs. va fi mai vulnerabil și cu atât mai dificil va fi de întreținut, în special pentru componentele care nu sunt sub controlul dvs.

### Utilizarea construcțiilor în mai multe etape

__Utilizați construcții în mai multe etape.__

Un mod eficient de a reduce dimensiunea imaginii este utilizarea construcțiilor în mai multe etape. Acest lucru vă permite să împărțiți construcția și rularea aplicației în mai multe etape, fiecare utilizând propria imagine. De exemplu, puteți utiliza o imagine pentru construirea aplicației și alta pentru rularea acesteia.

După această metodă, se creează un container intermediar care conține toate dependințele necesare pentru construirea aplicației (instrumente, pachete, fișiere temporare). În imaginea finală rămân doar fișierele executabile și bibliotecile necesare pentru funcționarea aplicației. Utilizarea construcțiilor în mai multe etape nu numai că reduce dimensiunea imaginii, dar și îmbunătățește securitatea, deoarece un atacator nu va putea accesa instrumentele de construcție și fișierele temporare.

### Imagini de bază verificate

__Alegeți cu atenție imaginile de bază.__

Imaginile voastre bazate pe imagini neverificate și nesuportate vor moșteni toate problemele și vulnerabilitățile din aceste imagini de bază.

Cea mai bună opțiune este să creați o imagine de la zero (`scratch`), dar acest lucru este potrivit doar pentru fișiere binare statice.

Altă varianta bune va fi utilizarea imaginilor `Distroless` care conțin numai un minim de biblioteci și instrumente necesare pentru rularea aplicației. Acest lucru vă permite să reduceți dimensiunea imaginii și suprafața de atac.

- [Google Distroless Container Tools](https://github.com/GoogleContainerTools/distroless) - construite pe baza Debian, conțin build-uri pentru limbaje compilate static (C / C++, Go, Rust), precum și pentru Java, Python, Node.js.
- [Chainguard Images](https://github.com/chainguard-images) - compania pregătește imagini mici și sigure, construite pe baza Alpine Linux. Există imagini pentru .NET, php, Ruby și alte limbaje.

Se recomandă să utilizați imagini oficiale, deoarece acestea sunt actualizate și verificate în mod regulat pentru securitate.

### Îmbunătățirea la timp a imaginilor

__Utilizați imagini de bază care se actualizează regulat. Totodată, actualizați și propriile imagini bazate pe acestea.__

Procesul de detectare a vulnerabilităților este continuu, așa că abordarea corectă va fi actualizarea regulată a imaginilor de bază.

Totodată nu este necesar să actualizați imediat la ultima versiune, care poate conține erori sau vulnerabilități. Strategia de versionare ar trebui să fie următoarea:

- Utilizați versiuni stabile sau long-term ale imaginilor de bază, care oferă rapid și frecvent actualizări de securitate;
- Fiți pregătit să renunțați la versiunile vechi și să faceți migrarea înainte de expirarea suportului pentru versiunea curentă a imaginii de bază, care nu mai primește actualizări;
- De asemenea, recompilați periodic propriile imagini folosind o strategie similară pentru a obține cele mai recente pachete din distribuția de bază, Node, Golang, Python etc. Majoritatea managerilor de pachete sau dependințe, cum ar fi `composer`, `npm` sau `go mod`, `pip` sau `poetry oferă modalități de a specifica intervalul de versiuni pentru a urmări cele mai recente actualizări de securitate.

### Porturi deschise

__Deschideți doar porturile necesare.__

Fiecare port deschis în container este o ușă deschisă în sistemul dvs. Lăsați deschise doar porturile care sunt necesare aplicațiilor dvs. și evitați porturile standard, cum ar fi SSH (22).

Atrageți atenție, chiar dacă fișierul Dockerfile conține instrucțiunea `EXPOSE`, aceasta nu înseamnă că portul este deschis automat. Deschiderea porturilor în Dockerfile nu înseamnă conectarea la acestea automat la rularea containerului (cu excepția cazului în care se utilizează comanda `docker run --publish-all`), deoarece tot trebuie să specificați porturile publicate la rularea containerului.

Utilizați comanda `EXPOSE` în Dockerfile doar pentru a marca și documenta porturile necesare, apoi utilizați porturile specificate în procesul de rulare a containerelor.

## Securizarea datelor

În proces de lucru cu containere, trebuie să fiți atenți pentru a evita scurgerile de date și pentru a proteja datele sensibile.

### Datele sensibile

__Niciodată nu plasați date sensibile (parole, chei, certificate) în Dockerfile.__

Niciodată nu plasați date sensibile (parole, chei, certificate) în Dockerfile. Imaginea creată poate fi ușor citită, datele pot fi extrase și utilizate de către atacatori.

Și mai mult, fiți atent la copierea fișierelor în container. Chiar dacă fișierul important a fost șters din imagine în straturile ulterioare, încă puteți accesa fișierul în straturile anterioare.

În timpul creării imaginii, urmați aceste recomandări:

- Dacă aplicația suportă lucrul cu variabile de mediu, folosiți-le pentru a transmite date confidențiale în container sau folosiți secretele Docker pentru a lucra cu date confidențiale.
- Utilizați fișiere de configurare și montați-le în container la rulare.

În plus, imaginile voastre nu trebuie să conțină datele confidențiale sau parametrii de configurare care sunt specifice unui anumit mediu (de exemplu, `dev`, `qa`, `prod` etc.).

### ADD și COPY

__Preferați comanda `COPY` în loc de `ADD`.__

Instrucțiuni `ADD` și `COPY` oferă funcții similare - copiază fișiere din contextul de construcție în imagine. Cu toate acestea, utilizarea `COPY` este preferabilă, deoarece procesul de copiere a datelor este previzibil și mai puțin predispus la erori.

Instrucția `ADD` are funcționalități suplimentare, cum ar fi dezarhivarea automată a arhivelor și descărcarea fișierelor de la URL-uri. Aceste funcționalități pot fi periculoase, deoarece pot duce la scurgeri de date sau vulnerabilități de securitate.

În cazul copierii unui pachet după URL, este mai bine să utilizați comanda `RUN` cu `wget` sau `curl` pentru a descărca pachetul, extrageți-l și ștergeți arhiva.

Construcții în mai multe etape (multistage builds) de asemenea rezolvă această problemă și ajută la urmarea celor mai bune practici, permițând copierea fișierelor din arhiva dezarhivată pe etapa anterioară.

### Contextul construcției

__Nu copiați tot contextul construcției în imagine.__

O practică proastă este copierea întregului context de construcție în imagine, deoarece acest lucru poate duce la scurgeri de date confidențiale.

Conform bunelor practici se recomandă crearea unei directoare pentru toate fișierele care trebuie copiate în imagine și utilizarea acestei directoare ca context de construcție. Acest lucru vă va ajuta să evitați copierea accidentală a datelor confidențiale și să reduceți dimensiunea contextului de construcție.

În plus, utilizați fișiere `.dockerignore` pentru a exclude fișierele și directoarele nedorite din contextul de construcție.

### Registrele

__Nu afișați date confidențiale în registre.__

Registrele pot conține date confidențiale, cum ar fi parole, chei sau alte date sensibile. Asigurați-vă că datele confidențiale nu sunt afișate în registre și că accesul la registre este securizat.

Utilizați variabile de mediu pentru configurarea nivelului de jurnalizare și montați directoare pentru scrierea jurnalelor în afara containerului.

## Altele

### Ordinea straturilor

__Plăsați instrucțiile în Dockerfile în ordinea inversă a frecvenței modificărilor.__

Ordinea instrucțiilor în fișierul Dockerfile afectează la cache-ul straturilor imaginii. Atunci când se modifică o instrucțiune, toate instrucțiunile ulterioare vor fi recompilate, ceea ce poate duce la creșterea timpului de construcție.

Din acest motiv se recomandă plasarea instrucțiilor în Dockerfile în ordinea inversă a frecvenței modificărilor. De exemplu, instrucțiile care se schimbă rar (instalarea dependințelor, copierea fișierelor) ar trebui plasate la începutul Dockerfile, iar instrucțiile care se schimbă frecvent (compilarea codului, instalarea pachetelor) ar trebui plasate la sfârșitul Dockerfile.

Ordinea greșită a instrucțiunilor:

```Dockerfile
FROM ubuntu:20.04

COPY . /app

RUN apt-get update && apt-get install -y python3

CMD ["python3", "/app/app.py"]
```

Va fi mai bine dacă se schimbă ordinea instrucțiilor `COPY` și `RUN`:

```Dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3

COPY . /app

CMD ["python3", "/app/app.py"]
```

### Metadate

__Includeți metadate în imagine.__

Se recomandă strict includerea metadatelor în imagine. Metadatele ajută la identificarea imaginii, conțin informații despre versiune, autor, licență și alte atribute importante.

### Verificarea imaginilor pe vulnerabilități

__Verificați regulat imaginile pe vulnerabilități.__

Este necesar să verificați regulat imaginile la existența greșelilor și vulnerabilităților. Sunt multe instrumente care vă pot ajuta să automatizați acest proces:

- [Docker Scout](https://docs.docker.com/scout/)
- [Trivy](https://trivy.dev)
- [Clair](https://trivy.dev)

## Concluzii

Respectarea recomandărilor la elaborarea Dockerfile vă va ajuta să îmbunătățiți securitatea și fiabilitatea containerelor dvs. Aceasta vă va ajuta să evitați multe probleme legate de scurgerile de date, vulnerabilitățile de securitate și complexitatea întreținerii.

Există multe recomandări (de exemplu, semnarea imaginilor, utilizarea `HEALTHCHECK`) care nu au fost discutate de noi, așa că vă recomandăm să vă familiarizați cu literatura din bibliografie.

## Bibliografie

1. [Overview of best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
2. [Docker Security](https://docs.docker.com/engine/security/)
3. [Newcomb Aaron, Sysdig 2021 container security and usage report: Shifting left is not enough, 2021](https://sysdig.com/blog/sysdig-2021-container-security-usage-report/)
4. [Iradier Álvaro, Top 20 Dockerfile best practices, 2021](https://sysdig.com/blog/dockerfile-best-practices/)
5. [antonkh, Distroless контейнеры, habr.com, 2023](https://habr.com/ru/articles/710968/)
