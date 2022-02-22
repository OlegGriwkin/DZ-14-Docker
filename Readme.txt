Установка Docker. Примеры команд взяты с https://docs.docker.com/engine/install/centos/
Устаналиваем ```yum install -y yum-utils```
Добавляем репозиторий ```yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo```
Устанавливаем Docker и дополнительные компоненты ```yum install -y docker-ce docker-ce-cli containerd.io```
Запускаем Docker ```systemctl enable docker```, ```systemctl start docker```
Убедиться в том, что демон стартовал без ошибок и предупреждений ```systemctl status docker```

[root@Docker ~]# systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Tue 2022-02-22 11:39:26 UTC; 6s ago
     Docs: https://docs.docker.com
 Main PID: 16535 (dockerd)
    Tasks: 8
   Memory: 30.7M
   CGroup: /system.slice/docker.service
           └─16535 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

Проверить список образов ```docker images```


1.Создайте свой кастомный образ nginx на базе alpine.

Создать Dockerfile ```vi Dockerfile```
#указываю базовый образ
FROM alpine:latest
#обновляю БД пакетного менеджера, устанавливаю nginx
RUN apk update && apk upgrade && apk add nginx
#транслирую 80 порт из контейнера в хостовую систему
EXPOSE 80
#копирую конфиг сайта внутрь контейнера
COPY index.html /root/html/
#указываю, что будет являться процессом внутри контейнера
CMD ["nginx", "-g", "daemon off;"] 

Создаем в каталоге root index.html ```vi index.html```
Welcome to Otus. I'm Oleg

Собираем образ ```docker build -t olegotus/myimages:nginx_v1 .``` 
...
Successfully built 4bc3f15fd81b
Successfully tagged olegotus/myimages:nginx_v1

Запустим контейнер командой ```docker run -d -p 8080:80 4bc3f15fd81b```


Вывести инф о запущенных контейнерах  ```docker ps``
[root@Docker ~]# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                                   
bff354b22519   4bc3f15fd81b   "nginx -g 'daemon of…"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp, :::8080->80/tcp


Собранный образ необходимо запушить в docker hub:
Авторизация на docker hub ```docker login --username olegotus```
Делаем push ```docker push olegotus/myimages:nginx_v1```
Ссылка на репозиторий - https://hub.docker.com/repository/docker/olegotus/myimages/tags


2. Определите разницу между контейнером и образом.
Образ, это неизменяемый образ, из которого разворачивается контейнер.
Это набор файлов, необходимых для запуска и работы приложения на другом хосте.
Аналогия может быть такой: образ — это компакт-диск, с которого устанавливается программа.

Контейнер, это уже развернутое и запущенное приложение.
Аналогия может быть такой: это устанавленная и запущенная программа из образа.
Из одного образа может быть запущено несколько контейнеров.



3. Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собрать ядро можно, загрузиться с него не получится.

