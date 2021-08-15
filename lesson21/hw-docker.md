# Docker

## Критерии приема

- Должен быть оформлен Pull Request с Вашего fork-репозитория в основной.
- Все файлы должны быть закоммичены по мере прохождения задания.
 
## Цель: Посмотрим решение на базе проектов под все языки\фреймворки "RealWorld" - https://github.com/gothinkster

- Создаем новую ветку hw-docker-01 в вашем репозитории https://github.com/hillel-devops-052021/<YourGitHubAccountName>-hw

- Загрузим одну из реализаций backend данного проекта - https://github.com/gothinkster/hapijs-realworld-example-app в каталог "backend" вашего репозитория.

- Удалим внутри .git каталог

- Так же загрузим реализацию frontend - https://github.com/gothinkster/react-redux-realworld-example-app в каталог "frontend" вашего репозитория

- Удалим внутри .git каталог

- Создаем аккаунт Docker если еще нет

- Давайте соберем проект frontend в контейнер, создаем dockerfile со следующим содержимым

```
FROM node:lts as build
COPY . .
RUN npm install && npm run build
FROM nginx:latest
COPY --from=build ./build /usr/share/nginx/html
```

- Соберем образ frontend

```
docker build -t <YourAccountDockerHub>/hillel-frontend:0.0.1 .

example: docker build -t sergeykudelin/hillel-frontend:0.0.1 .
```

- Загрузим его в DockerHub
```
docker push <YourAccountDockerHub>/hillel-frontend:0.0.1

example: docker push sergeykudelin/hillel-frontend:0.0.1 
```

- Соберем backend по такому же сценарию
```
cd ../backend

docker build -t <YourAccountDockerHub>/hillel-backend:0.0.1 .

docker push  <YourAccountDockerHub>/hillel-backend:0.0.1
```

- Теперь нам надо попробовать создать окружение которое позволит связать frontend + backend

- Создаем в корне репозитория docker-compose.yml

```
version: "3.8"
services:
    frontend:
        build: ./frontend
        image: <YourAccountDockerHub>/hillel-frontend:0.0.1
        ports:
            - "8080:80"
        networks:
            - public
    backend:
        build: ./backend
        image: <YourAccountDockerHub>/hillel-backend:0.0.1
        depends_on:
            - mongo
        environment:
            PORT: '8081'
            NODE_ENV: 'production'
            MONGO_DB_URI: 'mongodb://mongo/conduit'
            SECRET: 'secret'
        healthcheck:
            test: ["CMD", "curl", "-f", "http://backend:8081/api/status"]
            interval: 10m
            timeout: 10s
            retries: 3
        ports: 
            - 8081:8081
        restart: on-failure
        networks:
            - public
            - private
    mongo:
        image: mongo:latest
        expose:
            - 27017
        restart: on-failure
        volumes:
            - data:/data/db
        networks:
            - private
    
volumes:
    data:
networks:
    private:
    public:
```

- Попробуем собрать локальное окружение
```
docker-compose up -d
```

- Проверим доступность frontend по ссылке http://localhost:8080

- Пройдите регистрацию и опубликуйте свой первый пост

- Попробуем проверить как храняться наши данные в БД, для этого поднимем инструмент работы с MongoDB, создаем docker-compose.dev.yml

```
version: "3.8"
services:

    admin-mongo:
        image: adicom/admin-mongo
        ports:
            - 8082:8082
        environment:
            PORT: 8082
            DB_HOST: mongo
        networks:
            - public
            - private
```

- Расширим наше локальное окружение данным контейнером
```
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

- Попробуем обратится на веб-интерфейс данного решения и настроить соединения с MongoDB которая в изолированной сети http://localhost:8082

- Как мы видим отсутсвует какие либо записи в БД, по этому можно сделать вывод что приложение (frontend) работает с другим backend-ом по умолчанию.

## Результатом домашнего задания будет

- Реализация при которой будет использоваться локальный backend

    Подсказка: читать README.MD для frontend проекта.

- Загруженные в DockerHub образы

# У вас все получится!!!