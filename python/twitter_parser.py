#!/usr/bin/python

import MySQLdb as mdb, sys

reading = True

host = sys.argv[1]
user = sys.argv[2]
passw = sys.argv[3]
db = sys.argv[4]

conn = mdb.connect(host, user, passw, db)
cur = conn.cursor()

while reading:
	try:
		line = raw_input().split('\t')

		name = line[0]
		twitter = line[3]

		cur.execute("SELECT * FROM deputados WHERE nome LIKE '%s'" % (name))
		deputado = cur.fetchone()

		if deputado != None and not "possui" in twitter:
			
			sql = "INSERT INTO twitters (`id`, `deputado_id`, `address`, `created_at`, `updated_at`) VALUES (NULL, '%s', '%s', CURRENT_DATE(), CURRENT_DATE());" % (deputado[0], twitter)

			print sql

	except EOFError:
		reading = False
