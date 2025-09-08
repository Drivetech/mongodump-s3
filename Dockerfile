FROM alpine:3.7@sha256:92251458088c638061cda8fd8b403b76d661a4dc6b7ee71b6affcf1872557b2b

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
