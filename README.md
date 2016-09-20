# mongodump-s3

[![Layers](https://images.microbadger.com/badges/image/lgatica/mongodump-s3.svg)](http://microbadger.com/images/lgatica/mongodump-s3)
[![Docker Stars](https://img.shields.io/docker/stars/lgatica/mongodump-s3.svg?style=flat-square)](https://hub.docker.com/r/lgatica/mongodump-s3)
[![Docker Pulls](https://img.shields.io/docker/pulls/lgatica/mongodump-s3.svg?style=flat-square)](https://hub.docker.com/r/lgatica/mongodump-s3/)

> Docker Image with [Alpine Linux](http://www.alpinelinux.org), [mongodump](https://docs.mongodb.com/manual/reference/program/mongodump/) and [awscli](https://github.com/aws/aws-cli) for backup mongo database to s3

## Use

### Periodic backup

Run every day at 2 am

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *"
  lgatica/mongodump-s3
```

Run every day at 2 am with full mongodb

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *"
  -e "MONGO_COMPLETE=true"
  lgatica/mongodump-s3
```

Run every day at 2 am with full mongodb and keep last 5 backups

```bash
docker run -d --name mongodump \
  -v /tmp/backup:/backup
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  -e "BACKUP_CRON_SCHEDULE=0 2 * * *"
  -e "MONGO_COMPLETE=true"
  -e "MAX_BACKUPS=5"
  lgatica/mongodump-s3
```

### Inmediatic backup

```bash
docker run -d --name mongodump \
  -e "MONGO_URI=mongodb://user:pass@host:port/dbname"
  -e "AWS_ACCESS_KEY_ID=your_aws_access_key"
  -e "AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key"
  -e "AWS_DEFAULT_REGION=us-west-1"
  -e "S3_BUCKET=your_aws_bucket"
  lgatica/mongodump-s3
```

## IAM Policity

You need to add a user with the following policies. Be sure to change `your_bucket` by the correct.

```xml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1412062044000",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket/*"
            ]
        },
        {
            "Sid": "Stmt1412062128000",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your_bucket"
            ]
        }
    ]
}
```

## Extra environmnet

- `S3_PATH` - Default value is `mongodb`. Example `s3://your_bucket/mongodb`
- `MONGO_COMPLETE` - Default not set. If set doing backup full mongodb
- `MAX_BACKUPS` - Default not set. If set doing it keeps the last n backups in /backup
