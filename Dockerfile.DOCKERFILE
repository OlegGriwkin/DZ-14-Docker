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