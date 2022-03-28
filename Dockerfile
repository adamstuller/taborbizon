FROM node:14-slim as builder

RUN apt-get -y update 

WORKDIR /app
COPY package* /app/

RUN npm install

ADD . /app

ENV NPM_CONFIG_LOGLEVEL info

RUN npm run build 
    
FROM nginx:1.9.15-alpine

COPY --from=builder /app/index.html    /usr/share/nginx/html
COPY --from=builder /app/app.js        /usr/share/nginx/html
COPY --from=builder /app/assets        /usr/share/nginx/html/assets

RUN ls -la /usr/share/nginx/html \
    && ls -l /etc/nginx/conf.d \
    && cat /etc/nginx/nginx.conf \
    && cat /etc/nginx/conf.d/default.conf