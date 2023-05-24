# Создание и запуск первого контейнера

Создайте `Dockerfile` со следующим содержимым:

```dockerfile
FROM debian:latest

CMD ["echo", "hello", "world"]
```

Соберите образ:

```shell
docker build -t appcnt:002 .
```

Будет создан образ `appcnt` с этикеткой (тагом) `002` на базе описанного `Dockerfile` файла.

Для запуска контейнера на основе созданного образа выполните команду:

```shell
docker run --name appcnt_002 appcnt:002
```
