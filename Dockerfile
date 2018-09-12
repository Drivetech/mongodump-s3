FROM alpine:3.7@sha256:a52b4edb6240d1534d54ee488d7cf15b3778a5cfd0e4161d426c550487cddc5d

MAINTAINER Leonardo Gatica <lgatica@protonmail.com>

RUN apk add --no-cache mongodb-tools py2-pip && \
  pip install pymongo awscli && \
  mkdir /backup

ENV S3_PATH=mongodb AWS_DEFAULT_REGION=us-east-1

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup
COPY mongouri.py /usr/local/bin/mongouri

VOLUME /backup

CMD /usr/local/bin/entrypoint
