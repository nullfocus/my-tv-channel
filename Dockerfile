FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y nginx libnginx-mod-rtmp ffmpeg supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./rtmp /etc/nginx/sites-enabled/rtmp
COPY ./index.html /var/www/html/index.html
COPY ./run_stream.sh /run_stream.sh
RUN chmod -R 755 /run_stream.sh
RUN mkdir /vids/
RUN mkdir /var/www/html/stream

EXPOSE 80 1935 8088

CMD ["/usr/bin/supervisord"]