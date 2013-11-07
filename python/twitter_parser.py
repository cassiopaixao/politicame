#!/usr/bin/python

# Copyright 2013 de PoliticaMe/Cassio Paixao e Max Rosan.
# Este arquivo e parte do programa PoliticaMe.
# O PoliticaMe e um software livre; voce pode redistribui-lo e/ou modifica-lo
# dentro dos termos da GNU General Public License.
# como publicada pela Fundacao do Software Livre (FSF); na versao 3 da Licenca.
# Este programa e distribuido na esperanca que possa ser util,
# mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUACAO a qualquer MERCADO ou APLICACAO EM PARTICULAR.
# Veja a licenca para maiores detalhes.
# Voce deve ter recebido uma copia da GNU General Public License,
# sob o titulo "LICENCA.txt", junto com este programa, se nao, acesse http://www.gnu.org/licenses/

import MySQLdb as mdb, sys

reading = True

host = sys.argv[1]
user = sys.argv[2]
passw = sys.argv[3]
db = sys.argv[4]

conn = mdb.connect(host, user, passw, db)
conn.autocommit(True)
cur = conn.cursor()

while reading:
	try:
		line = raw_input().split('\t')

		name = line[0]
		twitter = line[3]

		cur.execute("SELECT * FROM deputados WHERE nome LIKE '%s'" % (name))
		deputado = cur.fetchone()

		if deputado != None and not "possui" in twitter:

			cur.execute("SELECT * FROM twitters WHERE deputado_id = '%s'" % (deputado[0]))
			twitter_obj = cur.fetchone()

			if twitter_obj != None:
				sql = "UPDATE twitters SET address = '%s', updated_at = CURRENT_DATE() WHERE deputado_id = '%s'" % (twitter, deputado[0])
			else:
				sql = "INSERT INTO twitters (`id`, `deputado_id`, `address`, `created_at`, `updated_at`) VALUES (NULL, '%s', '%s', CURRENT_DATE(), CURRENT_DATE());" % (deputado[0], twitter)

			cur.execute(sql)

			print sql

	except EOFError:
		reading = False
