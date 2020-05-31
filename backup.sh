#!/usr/bin/env sh

#OPTIONS=`python /usr/local/bin/mongouri`
BACKUP_NAME="$(date -u +%Y-%m-%d_%H-%M-%S)_UTC.gz"

# Run backup
mongodump --uri=$MONGO_URI --gzip --forceTableScan -o /backup/dump
# Compress backup
cd /backup/ && tar -cvzf "${BACKUP_NAME}" dump
# Upload backup
aws s3 cp "/backup/${BACKUP_NAME}" "s3://${S3_BUCKET}/${S3_PATH}/${BACKUP_NAME}"
# Delete temp files
rm -rf /backup/dump

#Slack nontification
echo --Sending slack Notification for $DBNAME
curl -X POST -H 'Content-type: application/json' \
--data '{"text":"'$DBNAME' backup done and uploaded to S3"}' \
$SLACK_URL

# Delete backup files
if [ -n "${MAX_BACKUPS}" ]; then
  while [ $(ls /backup -w 1 | wc -l) -gt ${MAX_BACKUPS} ];
  do
    BACKUP_TO_BE_DELETED=$(ls /backup -w 1 | sort | head -n 1)
    rm -rf /backup/${BACKUP_TO_BE_DELETED}
  done
else
  rm -rf /backup/*
fi