#!/usr/bin/env python

import os
import pymongo

uri = os.environ['MONGO_URI']
data = pymongo.uri_parser.parse_uri(uri)
if data['username'] is None:
    auth = ''
else:
    auth = '-u %s -p %s' % (data['username'], data['password'])
host = '-h %s:%s' % (data['nodelist'][0][0], data['nodelist'][0][1])
if os.environ.get('MONGO_COMPLETE') is None:
    dbname = '-d %s' % data['database']
else:
    dbname = ''
options = '%s %s %s' % (auth, host, dbname)

print(options)
