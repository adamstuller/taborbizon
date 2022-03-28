FROM nginx:1.9.15-alpine

COPY ./build/        /usr/share/nginx/html

RUN ls -la /usr/share/nginx/html \
    && ls -l /etc/nginx/conf.d \
    && cat /etc/nginx/nginx.conf \
    && cat /etc/nginx/conf.d/default.conf