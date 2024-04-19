# Integrarea continuă și livrarea continuă (CI / CD)

- [Integrarea continuă și livrarea continuă (CI / CD)](#integrarea-continuă-și-livrarea-continuă-ci--cd)
  - [Integrarea continuă](#integrarea-continuă)
    - [Organizarea integrării continue](#organizarea-integrării-continue)
    - [Avantaje și dezavantaje ale integrării continue](#avantaje-și-dezavantaje-ale-integrării-continue)
  - [Livrarea continuă](#livrarea-continuă)
  - [Un exemplu de proces CI / CD](#un-exemplu-de-proces-ci--cd)
    - [Organizarea codului](#organizarea-codului)
    - [Model exemplar](#model-exemplar)
    - [Instrumente](#instrumente)
  - [Infrastructura pentru CI / CD](#infrastructura-pentru-ci--cd)
  - [Utilizarea containerelor în procesele CI / CD](#utilizarea-containerelor-în-procesele-ci--cd)
  - [Bibliografie](#bibliografie)

Dezvoltarea produselor software modernă este similară cu organizarea producției pe bandă rulantă. Fiecare etapă a dezvoltării software trebuie să fie automatizată și integrată în procesul general. Pentru aceasta se utilizează instrumente și tehnologii specializate, cum ar fi _integrarea continuă_ (CI) și _livrarea continuă_ (CD).

## Integrarea continuă

__Integrarea continuă__ (_Continuous Integration_, CI) este o practică de dezvoltare a software-ului, în care modificările codului dezvoltatorilor sunt integrate într-o bază de cod comună de mai multe ori pe zi. Fiecare integrare este verificată de compilații și teste automate, ceea ce permite identificarea și corectarea erorilor mai repede.

De obicei la un proiect lucrează simultan mai mulți dezvoltatori, fiecare dintre care poate face modificări în cod de mai multe ori pe zi. Pentru a evita conflictele și erorile la integrarea modificărilor, se utilizează practica integrării continue. Această practică presupune rularea automată a compilației și testării software-ului la fiecare modificare a codului.

### Organizarea integrării continue

Pentru organizarea procesului de integrare continuă este necesar să se îndeplinească următoarele cerințe:

- utilizarea sistemului de control al versiunilor pentru stocarea codului sursă;
- configurarea compilației și testării automate a codului la fiecare modificare.

Pentru integrarea continuă pe un server dedicat se lansează un serviciu specializat, care la apariția unui eveniment efectuează următorii pași:

1. Obținerea codului sursă din sistemul de control al versiunilor;
2. Compilarea software-ului;
3. Implementarea software-ului într-un mediu de testare;
4. Lansarea testelor automate;
5. Trimiterea unui raport cu rezultatele testării dezvoltatorilor.

Totodata, compilări și testări pot fi organizate după orar, de exemplu odată per zi (_daily build_ sau _nightly build_). Aceasta reduce sarcina pe server și permite dezvoltatorilor să se concentreze pe dezvoltarea de software.

### Avantaje și dezavantaje ale integrării continue

Integrarea continuă are următoarele avantaje:

- identificarea rapidă și corectarea erorilor;
- rularea imediată și regulată a testelor;
- disponibilitatea imediată a versiunii stabile curente a software-ului;
- efectul imediat al codului incomplet încurajează dezvoltatorii să lucreze în mod iterativ.

Dezavantajele integrării continue includ:

- costuri suplimentare pentru întreținerea integrării continue;
- necesitatea de resurse suplimentare pentru a asigura integrarea continuă.

## Livrarea continuă

__Livrarea continuă__ (_Continuous Delivery_, CD) este o practică de dezvoltare a software-ului, care presupune automatizarea procesului de livrare a software-ului într-un mediu de producție după fiecare trecere a testelor cu succes. Livrarea continuă permite dezvoltatorilor să livreze modificările de cod în producție în mod rapid și sigur către utilizatori.

În afară de livrare continuă poate fi implementată și __implementarea continuă__ (_Continuous Deployment_), care presupune automatizarea procesului de implementare a software-ului în producție după fiecare trecere a testelor cu succes. Implementarea continuă permite dezvoltatorilor să implementeze modificările de cod în producție fără intervenția umană. Totoată, implementarea continuă necesită un control mai atent al calității și securității codului.

Diferența dintre livrarea continuă și implementarea continuă constă în faptul că în primul caz dezvoltatorii decid când să livreze modificările de cod în producție, iar în al doilea caz acest lucru se întâmplă automat.

În practică organizarea proceselor CI / CD impune cerințe suplimentare pentru infrastructură și procesele de dezvoltare.

## Un exemplu de proces CI / CD

### Organizarea codului

Una dintre modalitățile de organizare a codului poate fi următoarea:

1. Există o ramură principală de dezvoltare (de exemplu, `main` sau `master`);
2. La dezvoltarea unei anumite funcționalități se creează o ramură separată pe baza ramurii principale (de exemplu, `feature-branch`);
3. După finalizarea dezvoltării funcționalității se creează o solicitare de tragere (_Pull Request_) în ramura principală;
4. După verificarea codului și trecerea cu succes a testelor solicitarea de tragere se îmbină în ramura principală;
5. După îmbinarea în ramura principală se lansează procesul de compilare și testare a software-ului;
6. La trecerea cu succes a testelor se creează o ramură de lansare a software-ului (sau se etichetează cu eticheta lansării);
7. Crearea ramurii de lansare lansează procesul de implementare a software-ului în mediu de producție.

### Model exemplar

Organizația procesului CI / CD poate fi reprezentată de următoarele medii:

- __local__ - un mediu de dezvoltare local, instalat pe calculatorul fiecărui dezvoltator;
- __qa__ - mediu pentru integrarea noilor funcționalități;
- __staging__ - mediu pentru testarea noilor funcționalități;
- __production__ - mediu pentru implementarea noilor funcționalități.

Dezvoltatorii lucrează în mediu local, unde creează noi funcționalități și efectuează testarea.

După finalizarea dezvoltării funcționalității dezvoltator crează solicitare de tragere (_Pull Request_) în ramura `main`. Crearea cerinței de imbinare lansează procesul de compilare și testare a software-ului în mediu `qa`. Pe mediu `qa` se efectuează testarea automată a noilor funcționalități.

După finalizarea cu succes a testelor în mediu `qa` se efectuează imbinarea în ramura `main`. După imbinarea în ramura `main` codul se livrează în mediu `staging`.

Mediul `staging` este un mediu asemănător cu mediu `production`, unde se efectuează testarea manuală a noilor funcționalități.

După finalizarea cu succes a testelor în mediu `staging` se creează ramura lansării (_release branch_), care lansează procesul de implementare a software-ului în mediu `production`.

### Instrumente

Pentru organizarea proceselor CI / CD se utilizează instrumente specializate, care permit automatizarea proceselor de compilare, testare și implementare a software-ului:

- __Jenkins__ — este un instrument popular pentru organizarea proceselor CI / CD.
- __GitLab CI__ — este un instrument pentru organizarea proceselor CI / CD, integrat cu sistemul de control al versiunilor GitLab. GitLab CI permite configurarea lanțurilor de compilare, testare și implementare a software-ului, precum și gestionarea acestora printr-o interfață web GitLab.
- __TeamCity__ — este un instrument pentru organizarea proceselor CI / CD, dezvoltat de compania JetBrains.
- __CircleCI__ — este un instrument pentru organizarea proceselor CI / CD, integrat cu sistemul de control al versiunilor GitHub.
- __Github Actions__ — este un instrument pentru organizarea proceselor CI / CD, integrat cu sistemul de control al versiunilor GitHub. Github Actions permite configurarea lanțurilor de compilare, testare și implementare a software-ului, precum și gestionarea acestora printr-o interfață web Github Actions.
- __AWS CodeBuild__, __AWS CodePipeline__ — sunt instrumente pentru organizarea proceselor CI / CD, integrate cu platforma cloud Amazon Web Services (AWS).
- __Azure DevOps__ — este un instrument pentru organizarea proceselor CI / CD, integrat cu platforma cloud Microsoft Azure.
- __Atlasian Bamboo__ — este un instrument pentru organizarea proceselor CI / CD, dezvoltat de compania Atlasian.

## Infrastructura pentru CI / CD

Pentru organizarea proceselor CI / CD este necesară o infrastructură specializată, care permite automatizarea proceselor de compilare, testare și implementare a software-ului:

- __Docker__ — este o platformă populară pentru dezvoltarea, livrarea și rularea aplicațiilor în containere. Docker permite ambalarea aplicațiilor și dependințelor lor în containere, ceea ce facilitează implementarea și scalarea aplicațiilor.
- __Kubernetes__ — este o platformă pentru automatizarea implementării, scalării și gestionării aplicațiilor containerizate. Kubernetes permite gestionarea unui cluster de servere pe care rulează containere și asigură disponibilitatea și scalabilitatea aplicațiilor.
- __Terraform__ — este un instrument pentru gestionarea infrastructurii ca cod. Terraform permite descrierea infrastructurii în fișiere de configurare și automatizarea implementării și gestionării acesteia.
- __Ansible__ — este un instrument pentru automatizarea gestionării configurației și implementării software-ului. Pe baza descrierii configurațiilor (playbook) Ansible automatizează implementarea software-ului pe computerul țintă.

## Utilizarea containerelor în procesele CI / CD

Utilizarea containerelor în procesele CI / CD permite simplificarea implementării și scalării aplicațiilor, precum și asigurarea izolării și securității acestora.

Containerele permit ambalarea aplicațiilor și dependințelor lor în medii izolate, ceea ce facilitează implementarea și gestionarea acestora. În plus, containerele permit rularea aplicațiilor în orice mediu, unde este instalat Docker, ceea ce asigură portabilitatea și scalabilitatea acestora.

Majoritatea instrumentelor moderne pentru organizarea proceselor CI / CD suportă lucrul cu containere, mai mult decât atât, ele chiar implementează etapele procesului CI / CD în containere:

- sistem CI / CD rulează în container,
- pentru fiecare etapă a procesului CI / CD se creează un container separat, care compilează și testează codul,
- aplicația se implementează în containere.

Utilizarea containerelor simplifică transferarea aplicației dintr-un mediu în altul, de exemplu la compilarea aplicației în container pentru mediu `qa`, la trecerea cu succes a testelor, acest container poate fi utilizat pentru mediu `staging` și `production`.

## Bibliografie

1. [Continuous Integration, Wikipedia](https://en.wikipedia.org/wiki/Continuous_integration)
2. [Continuous Delivery, Wikipedia](https://en.wikipedia.org/wiki/Continuous_delivery)
3. [Jenkins](https://www.jenkins.io/)
4. [GitLab CI](https://docs.gitlab.com/ee/ci/)
5. [TeamCity](https://www.jetbrains.com/teamcity/)
6. [CircleCI](https://circleci.com/)
7. [Github Actions](https://docs.github.com/en/actions)
8. [Docker](https://www.docker.com/)
9. [Kubernetes](https://kubernetes.io/)
10. [Terraform](https://www.terraform.io/)
11. [Ansible](https://www.ansible.com/)
12. [Continuous integration with Docker, Docker](https://docs.docker.com/build/ci/)
13. [Introduction to GitHub Actions, Docker](https://docs.docker.com/build/ci/github-actions/)
14. [MaxRokatansky, Что такое CI/CD? Разбираемся с непрерывной интеграцией и непрерывной поставкой, Habr.com](https://habr.com/ru/companies/otus/articles/515078/)
15. [Что такое непрерывная поставка?, Microsoft](https://learn.microsoft.com/ru-ru/devops/deliver/what-is-continuous-delivery)