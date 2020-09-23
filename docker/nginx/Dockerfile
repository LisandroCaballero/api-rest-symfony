FROM nginx:1.15.8-alpine

ARG UID
EXPOSE $UID

RUN adduser -u ${UID} --disabled-password --gecos "" appuser

COPY default.conf /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/nginx.conf
ENV PS1="\u@\h:\w\\$ "

RUN apk add --no-cache bash
