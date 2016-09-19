#!/bin/sh

set +e

if [ -z ${BACKUP_CRON_SCHEDULE+x} ]; then
  /usr/local/bin/backup
else
  BACKUP_CRON_SCHEDULE=${BACKUP_CRON_SCHEDULE}
  echo "${BACKUP_CRON_SCHEDULE} /usr/local/bin/backup" > /etc/crontabs/root
  # Starting cron
  crond -f -d 0
fi
