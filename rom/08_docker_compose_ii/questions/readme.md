# Вопросы к занятию "Особенности настройки кластера контейнеров"

Вопросы с выбором одного варианта из четырёх.

1. Какой ключ используется в файле `docker-compose.yml` для указания переменных окружения, которые необходимо передать в контейнер?
    - [x] environment
    - [ ] env
    - [ ] variables
    - [ ] vars
2. Какой ключ используется в файле `docker-compose.yml` для указания файла с переменными окружения?
    - [x] env_file
    - [ ] environment_file
    - [ ] variables_file
    - [ ] vars_file
3. Какой файл автоматически подставляет Docker Compose в файл `docker-compose.yml`, если переменные окружения объявлены в нём?
    - [x] .env
    - [ ] .vars
    - [ ] .variables
    - [ ] .env_file
4. Какой ключ используется в файле `docker-compose.yml` для указания аргументов сборки образа?
    - [x] build.args
    - [ ] image.args
    - [ ] build.arguments
    - [ ] image.variables
5. Какой ключ используется в файле `docker-compose.yml` для указания контекста сборки образа?
    - [x] build.context
    - [ ] image.context
    - [ ] build.dir
    - [ ] image.dir
6. Каким образом можно в `docker-compose.yml` ограничить процессорное время, доступное контейнеру?
    - [x] указать значение ключа `deploy.resources.limits.cpus`
    - [ ] указать значение ключа `deploy.resources.cpu_limit`
    - [ ] указать значение ключа `deploy.resources.cpu.quota`
    - [ ] указать значение ключа `deploy.resources.cpu.shares`
7. Каким образом можно в `docker-compose.yml` ограничить объём памяти, доступный контейнеру?
    - [x] указать значение ключа `deploy.resources.limits.memory`
    - [ ] указать значение ключа `deploy.resources.memory_limit`
    - [ ] указать значение ключа `deploy.resources.memory.quota`
    - [ ] указать значение ключа `deploy.resources.memory.shares`
8. Какой ключ используется в файле `docker-compose.yml` для указания ограничений ресурсов контейнера?
   - [x] deploy.resources
   - [ ] resources
   - [ ] limits
   - [ ] deploy.limits
