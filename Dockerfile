FROM alpine:edge

MAINTAINER Leonardo Gatica <lgatica@protonmail.com>

RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
  apk add --no-cache mongodb-tools py2-pip && \
  pip install pymongo awscli && \
  mkdir /backup

ENV S3_PATH=mongodb
ENV AWS_DEFAULT_REGION=us-east-1

ADD entrypoint.sh /usr/local/bin/entrypoint
ADD backup.sh /usr/local/bin/backup
ADD mongouri.py /usr/local/bin/mongouri

VOLUME /backup

CMD /usr/local/bin/entrypoint
