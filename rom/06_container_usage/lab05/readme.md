# Lucrare de laborator №5: Interacțiunea containerelor

## Scopul lucrării

După finalizarea acestei lucrări studentul va fi capabil să gestioneze interacțiunea între mai multe containere.

## Sarcina

Creați o aplicație PHP pe baza a două containere: nginx, php-fpm.

## Pregătire

Pentru efectuarea acestei lucrări este necesar să aveți instalat pe computer [Docker](https://www.docker.com/).

Pentru efectuarea lucrării este necesar să aveți experiență în efectuarea lucrării de laborator №3.

## Efectuarea lucrării

Creați un repozitoriu `containers05` și copiați-l pe computerul dvs.

În directorul `containers05` creați directorul `mounts/site`. În acest director copiați site-ul PHP creat în cadrul cursului  _Programare PHP_.

Creați fișierul `.gitignore` în rădăcina proiectului și adăugați următoarele linii:

```gitignore
# Ignore files and directories
mounts/site/*
```

Creați în directorul `containers05` fișierul `nginx/default.conf` cu următorul conținut:

```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    location ~ \.php$ {
        fastcgi_pass backend:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

## Pornirea și testarea

Creați rețeaua `internal` pentru containere.

Creați containerul `backend` cu următoarele proprietăți:

- pe baza imaginii `php:7.4-fpm`;
- directorul `mounts/site` este montat în `/var/www/html`;
- funcționează în rețeaua `internal`.

Creați containerul `frontend` cu următoarele proprietăți:

- pe baza imaginii `nginx:1.23-alpine`;
- directorul `mounts/site` este montat în `/var/www/html`;
- fișierul `nginx/default.conf` este montat în `/etc/nginx/conf.d/default.conf`;
- portul 80 al containerului este expus pe portul 80 al calculatorului gazdei;
- funcționează în rețeaua `internal`.

Pentru a testa funcționarea site-ului, deschideți site-ul în browser, trecând la adresa `http://localhost`. Dacă este afișată pagina de pornire `nginx`, atunci reîncărcați pagina.

## Crearea raportului

Creați în directorul `containers05` fișierul `README.md` care conține descrierea etapizată a proiectului. Descrierea proiectului trebuie să conțină:

1. Numele lucrării de laborator.
2. Scopul lucrării.
3. Sarcina.
4. Descrierea efectuării lucrării cu răspunsuri la întrebări.
5. Concluzii.

Răspundeți la întrebările:

1. În ce mod în acest exemplu containerele pot interacționa unul cu celălalt?
2. Cum văd containerele unul pe celălalt în cadrul rețelei `internal`?
3. De ce a fost necesar să se suprascrie configurarea `nginx`?

Încărcați proiectul pe GitHub.

## Prezentare

Pentru prezentarea răspunsului atașați la sarcină un link către repozitoriul.

## Evaluare
