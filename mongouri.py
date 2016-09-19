#!/usr/bin/env python

import pymongo
import os

uri = os.environ['MONGO_URI']
data = pymongo.uri_parser.parse_uri(uri)
auth = '' if data['username'] is None else '-u %s -p %s' % (data['username'], data['password'])
host = '-h %s:%s' % (data['nodelist'][0][0], data['nodelist'][0][1])
dbname = '-d %s' % data['database']
options = '%s %s %s' % (auth, host, dbname)

print options
