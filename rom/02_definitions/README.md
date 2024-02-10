# Noțiuni de bază

- [Noțiuni de bază](#noțiuni-de-bază)
  - [Imagine](#imagine)
  - [Container](#container)
  - [Repozitoriu](#repozitoriu)
  - [Server](#server)
  - [Arhitectura monolitică](#arhitectura-monolitică)
  - [Arhitectura modulară](#arhitectura-modulară)
  - [Serviciu](#serviciu)
  - [Serviciu Web](#serviciu-web)
  - [Scalare](#scalare)
  - [Cluster](#cluster)
  - [Orchestrare](#orchestrare)
  - [Cloud](#cloud)
  - [Bibliografie](#bibliografie)

Pentru a înțelege un anumit domeniu, este necesar să cunoașteți termenii din acest domeniu. În această secțiune, vom încerca să definim principalele concepte care vor fi utilizate în continuare.

## Imagine

**Imaginea** reprezintă un fișier care conține tot ce este necesar pentru a rula o aplicație. Aceasta include aplicația în sine, bibliotecile dinamice necesare pentru rularea aplicației, fișierele de configurare și datele. Imaginile se crează pe baza fișierului `Dockerfile`, care descrie ce trebuie inclus în imagine. Imaginile se stochează într-un repozitoriu, fie local, fie la distanță.

## Container

**Containerul** reprezintă o instanță a unei imagini. Containerele pot fi considerate ca aplicații și pot fi pornite, oprite, șterse, repornite etc. Containerele pot fi conectate între ele (să schimbe informații) și pot interacționa cu resurse externe.

## Repozitoriu

**Repozitoriul** se referă la un depozit de fișiere, dar în contextul containerizării, aceste depozite conțin imagini. Repozitoriile pot fi publice sau private. Repozitoriile publice sunt disponibile pentru descărcare pentru oricine, în timp ce cele private sunt disponibile doar pentru anumiți utilizatori.

Cel mai popular repozitoriu public este [Docker Hub](https://hub.docker.com/), în care sunt stocate imagini create de comunitate.

## Server

Serverul, în funcție de context, are diferite semnificații.

- **Serverul** ca parte hardware reprezintă un calculator specializat pe care rulează software-ul server. Aceste calculatoare au performanță ridicată, fiabilitate și disponibilitate, ceea ce permite funcționarea aplicației pe o perioadă lungă de timp.
- **Serverul** ca parte software reprezintă un program care oferă anumite servicii clienților. Serverul poate fi rulat pe orice calculator, însă pentru a asigura o disponibilitate și fiabilitate ridicate, serverele sunt rulate pe calculatoare specializate. Serverele rulează în fundal în sistemul de operare, în Linux sunt numite demoni, iar în Windows - servicii.

Cerința principală a serverelor este **fiabilitatea**, deoarece trebuie să ofere servicii clienților în mod continuu, fără întreruperi. Serverul poate avea și alte caracteristici, în funcție de sarcinile pe care le rezolvă, cum ar fi:

- **Performanța** - capacitatea serverului de a procesa cererile clienților într-un timp minim.
- **Scalabilitatea** - capacitatea serverului de a crește performanța prin alocarea de resurse suplimentare.
- **Administrabilitatea** - capacitatea serverului de a fi gestionat de la distanță, fără a fi necesară prezența fizică a unui administrator.

## Arhitectura monolitică

**Arhitectura monolitică** se referă la arhitectura unei aplicații în care întregul cod al aplicației se află într-un singur component. Toate componentele aplicației sunt rulate într-un singur proces, într-un singur container. Această arhitectură este simplă în implementare, însă are câteva dezavantaje, cum ar fi:

- **Înțelegerea** - întregul cod al aplicației se află într-un singur component, ceea ce dificultează citirea și înțelegerea acestuia;
- **Menținerea** - o bază de cod extinsă complică căutarea codului necesar pentru îmbunătățirea și adăugarea de noi funcționalități;
- **Scalarea** - scalarea aplicației în cazul arhitecturii monolitice este verticală, ceea ce limitează posibilitățile de scalare;
- **Actualizarea** - în acest caz, este necesară actualizarea întregului component, chiar dacă doar o parte a funcționalității a fost modificată.

## Arhitectura modulară

Aplicațiile moderne sunt sisteme complexe, alcătuite din mai multe componente. Fiecare componentă își îndeplinește propria funcție, iar interacțiunea între componente permite implementarea funcționalității necesare. Componentele pot fi scrise în diferite limbaje de programare, pot utiliza baze de date diferite și pot folosi protocoale de comunicare diferite. Toate acestea fac ca dezvoltarea și întreținerea unor astfel de aplicații să fie o sarcină dificilă. În cazul în care o aplicație este alcătuită din mai multe componente, se spune că aplicația are o **arhitectură multi-componentă** sau **arhitectură modulară**.

Dezvoltarea aplicațiilor cu o arhitectură multi-componentă este o sarcină dificilă, însă are mai multe avantaje, și anume:

- **Înțelegere** - fiecare componentă își îndeplinește propria funcție, ceea ce facilitează înțelegerea aplicației;
- **Întreținere** - nu este nevoie să înțelegi întregul cod al aplicației, este suficient să înțelegi doar componenta pe care trebuie să o întreții;
- **Scalabilitate** - scalarea aplicației în cazul unei arhitecturi multi-componentă este orizontală, ceea ce permite creșterea performanței aplicației prin adăugarea de componente suplimentare;
- **Actualizare** - în acest caz, se actualizează doar componentele care au suferit modificări.

Un caz particular al arhitecturii multi-componentă este **arhitectura cu microservicii**, în care rolul modulelor este jucat de servicii web (microservicii).

Pentru a simplifica dezvoltarea și întreținerea aplicațiilor, se folosesc containere. Fiecare componentă a aplicației este rulată într-un container separat, ceea ce permite dezvoltatorilor să se concentreze pe implementarea funcționalității componentei, nu pe integrarea acesteia cu celelalte componente. Pentru a rula aplicația, trebuie să pornești fiecare container care conține componentele aplicației și să configurezi interacțiunea între ele.

## Serviciu

**Serviciu** este o aplicație care oferă servicii îngust specializate și se rulează, de obicei, pe server.

În acest context un web site poate fi prezentat ca un serviciu, ca un set de servicii dependente unul de altul, sau ca un set de servicii independente care lucrează împreună pentru a oferi o funcționalitate complexă.

## Serviciu Web

**Serviciu web** se referă la un serviciu care oferă servicii prin protocolul HTTP. Serviciile web pot fi accesibile atât în rețeaua locală, cât și în rețeaua globală a internetului. Pe baza interacțiunii între servicii, se dezvoltă aplicații cu arhitectură bazată pe microservicii.

## Scalare

**Scalarea** se referă la procesul de creștere a performanței unei aplicații prin alocarea unui număr mai mare de resurse pentru funcționarea sa. Scalarea poate fi verticală sau orizontală.

**Scalarea verticală** se referă la creșterea performanței unei aplicații prin alocarea unui număr mai mare de resurse pe același server. De exemplu, creșterea capacității de memorie, creșterea numărului de nuclee ale procesorului, creșterea capacității de stocare.

**Scalarea orizontală** se referă la creșterea performanței unei aplicații prin adăugarea de servere pe care este rulată aplicația. De exemplu, creșterea numărului de servere pe care este rulată aplicația.

## Cluster

**Clusterul** se referă în general la un grup de dispozitive independente care lucrează împreună pentru a îndeplini o sarcină comună.

În contextul containerizării, clusterul se referă la un grup de calculatoare pe care este rulată o aplicație, implementată în containere.

Un set de containere în care este rulată o aplicație se numește **cluster de containere**.

## Orchestrare

**Orchestrarea** se referă la procesul de gestionare a unui cluster de containere. Orchestrarea permite pornirea, oprirea, repornirea containerelor și gestionarea interacțiunii între ele. Orchestrarea permite gestionarea clusterului de containere ca o entitate unitară, nu ca o colecție de containere separate.

Orchestratorii oferă următoarele funcționalități:

- Pornirea și oprirea containerelor
- Scalarea aplicației
- Distribuirea sarcinilor între containere
- Detectarea și recuperarea containerelor care au eșuat

## Cloud

**Cloud-ul** se referă la un grup de calculatoare conectate într-o rețea unică, cu software specializat instalat, care oferă servicii utilizatorilor. Serviciile standard ale cloud-ului includ: putere de calcul, stocare de date, resurse de rețea, rularea diferitelor aplicații.

Multe companii oferă servicii de cloud, cum ar fi

- [Amazon Web Services](https://aws.amazon.com/ru/),
- [Microsoft Azure](https://azure.microsoft.com/ru-ru/),
- [Google Cloud](https://cloud.google.com/).

## Bibliografie

1. [**В чем разница между образами Docker и контейнерами?**, AWS Amazon](https://aws.amazon.com/ru/compare/the-difference-between-docker-images-and-containers/)
2. [**Что такое контейнеризация?**, AWS Amazon](https://aws.amazon.com/ru/what-is/containerization/)
3. [**Микрослужбы .NET: Архитектура контейнерных приложений .NET**, learn.microsoft.com, 2022](https://learn.microsoft.com/ru-ru/dotnet/architecture/microservices/)
4. [simust, **Основы контейнеризации (обзор Docker и Podman)**, Habr.com, 2022](https://habr.com/ru/articles/659049/)
5. [**Что такое облачные вычисления?**, AWS Amazon](https://aws.amazon.com/ru/what-is-cloud-computing/)
