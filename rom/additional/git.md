# Lucru cu GIT

__Git__ [^1] este un sistem de control al versiunilor distribuit. Proiectul a fost creat de Linus Torvalds pentru a gestiona dezvoltarea nucleului Linux, prima versiune fiind lansată la 7 aprilie 2005.

Sisteme de control al versiunilor permit dezvoltatorilor să gestioneze dezvoltarea și să fie siguri că orice modificare nouă nu "strică" codul. Mai multe detalii pot fi găsite în manualul oficial GIT [^2].

## terminologie

* __repozitoriu (en. repository)__ - local de stocare a codului sursă.
* __urmarirea versiunilor (en. version tracking)__ - urmărirea schimbărilor în documente (de exemplu, in codul sursă). Aceasta urmărire permite gestionarea istoricului schimbărilor. Urmărirea versiunilor este realizată de programe specializate - _sisteme de control al versiunilor_.
* __control al versiunilor (en. version control)__ - totodată cunoscut ca __control al codului sursă (source control)__ este o practică de urmărire a modificărilor în codul sursă și gestionare acestor modificări.
* __sistema de control al versiunilor (en. version control system)__ - un product software specializat care permite efectuarea controlului al versiunilor. Cele mai populare sisteme de control al versiunilor sunt: [CVS](https://ru.wikipedia.org/wiki/CVS), [SVN](https://ru.wikipedia.org/wiki/Subversion), [GIT](https://ru.wikipedia.org/wiki/Git).
* __ramura modificărilor__ sau __ramura (en. branch)__ - direcție de dezvoltare, independentă de altele. Ramura reprezintă o copie a unei părți a repozitoriului (de exemplu, a unui director), în care se pot face modificări care nu afectează alte ramuri. Documentele din ramuri diferite au aceeași istorie până la punctul de ramificare și diferită - după aceea.
* __modificare (salvare modificare) (en. commit)__ - salvarea (memorarea) modificărilor codului în sistemul de control al versiunilor.
* __versiune a proiectului (en. project version)__ - starea proiectului la un moment dat.
* __a extrage o versiune (en. pull version)__ - a obține o versiune dintr-un repozitoriu de cod sursă.
* __a publica o versiune (en. push version)__ - a trimite o versiune într-un repozitoriu de cod sursă.
* __îmbinarea ramurilor (en. merge branch)__ - combinarea modificărilor dintr-o ramură în alta.
* __cerere de tragere (en. pull request)__ - cererea de a trage modificările dintr-o ramură în alta.
* __cerere de îmbinare (en. merge request)__ - cererea de a îmbina modificările dintr-o ramură în alta.
* __conflict de îmbinare (en. merge conflict)__ - situația în care două ramuri modifică același fișier și sistemul de control al versiunilor nu poate îmbina automat modificările.

## cheatsheet

| acțiune | comanda |
| -------- | ------- |
| Afișarea ramurilor existente: | `git branch` |
| Crearea ramurii `my-cool-branch`: | `git branch my-cool-branch` |
| Schimbarea ramurii active la `my-cool-branch`: | `git checkout my-cool-branch` |
| Ștergerea ramurii `my-cool-branch`: | `git branch -D my-cool-branch` |
| Crearea și schimbarea: | `git checkout -B my-cool-branch` |
| Verificarea statutului: | `git status` |
| Adăugarea tuturor fișierelor spre control: | `git add *` |
| Adăugarea fișierului `mycoolfile` spre control: | `git add mycoolfile` |
| Crearea commitului cu mesaj `test message`: | `git commit -m "test message"` |
| Trimiterea modificărilor în repozitoriu extern | `git push` |

## începutul interacțiunii cu GITHUB

Creați un cont GITHUB. După finalizarea puteți crea repozitoriile proprii cât publice atât și private.

Для взаимодействия с GITHUB сначала надо установить GIT. Для его скачивания и знакомства с процессом установки перейдите на страницу [Установка GIT](https://git-scm.com/book/ru/v2/Введение-Установка-Git) и выполните указанные инструкции.

## ключ безопасности

Пусть вы зарегистрировали аккаунт на почтовый адрес `my@cool.email`.

После установки GIT в меню ОС появится GIT BASH. Откройте эту консоль и создайте ключи аутентификации для GITHUB. Для этого выполните следующую команду:

```shell
ssh-keygen -C "my@cool.email"
```

В папке пользователя компьютера (`~/.ssh`) будут созданы два файла: приватный и публичный ключи. Публичный ключ необходимо зарегистрировать в github.
> При желании можно задать своё имя ключам, тогда необходимо создать файл `~/.ssh/config` в котором
> прописывается имя ключа для конкретного клиента - github.

## создание репозитория

Простейшим способом создания репозитория будет создание его через Web интерфейс с последующим его клонированием.

## Минимальный рабочий сценарий

Минимальный рабочий сценарий включает в себя следующие шаги:

1. переключение на главную ветку
2. получение последних изменений с удаленного сервера
3. создание новой ветки (для новой функциональности) и переход на неё
4. _реализация новой функциональности - к GIT не имеет отношения_
5. добавление измененных файлов к отслеживаемым файлам
6. создание точки изменения (commit, коммит)
7. отправка точки изменения на сервер

На удаленном сервере будет создана новая ветка, которую надо будет влить в главную ветку. Для этого создаётся запрос (pull request или merge request) через web интерфейс репозитория. После проверки кода и его одобрения новая ветка вливается в главную.

```shell
git checkout main
git pull
git checkout -B <new-branch>
# some work inside
git add *
git commit -m <message>
git push
```

## Bibliografie

[^1]: [Wiki GIT](https://ro.wikipedia.org/wiki/Git)
[^2]: [Pro GIT](https://git-scm.com/book/ru/v2)
