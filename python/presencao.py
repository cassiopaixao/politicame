

import sys, io
import xml.etree.ElementTree as ET
import commands

import MySQLdb as mdb, sys
import datetime as dt

reading = True

host = sys.argv[1]
user = sys.argv[2]
passw = sys.argv[3]
db = sys.argv[4]

conn = mdb.connect(host, user, passw, db)
conn.autocommit(True)
cur = conn.cursor()

if __name__ == "__main__":

	if len(sys.argv) == 7:

		dataIni = sys.argv[5]
		dataFim = sys.argv[6]

		cur.execute("SELECT * FROM deputados")
		deputados = cur.fetchall()

		for dep in deputados:

			matricula = dep[10]

			if matricula == None:
				continue

			ws  = "http://www.camara.gov.br/SitCamaraWS/sessoesreunioes.asmx/ListarPresencasParlamentar?dataIni=" + dataIni + "&dataFim=" + dataFim + "&numMatriculaParlamentar=" + matricula
			op  = "presenca.xml"


			for i in range(0, 10):
				cmd = commands.getstatusoutput("wget \"%s\" -O %s" % (ws, op))
				if cmd[0] == 0:
					break

			if cmd[0] == 0:

				print "Processing %s" % (op)

				tree = ET.parse(op)
				root = tree.getroot()

				for pal in root.iter("parlamentar"):
					print pal.find("nomeParlamentar").text

					freqCont = 0
					ausCont = 0

					for sessao in pal.iter("diasDeSessoes2"):
						for dia in sessao.iter("dia"):
							#print dia.find("frequencianoDia").text.encode("utf-8")

							for sessoes in dia.find("sessoes").iter("sessao"):
								#print "# descricao ", sessoes.find("descricao").text.encode("utf-8")
								frequencia = sessoes.find("frequencia").text.encode("utf-8")

								if "Presen" in frequencia:
									freqCont = freqCont + 1
								else:
									ausCont = ausCont + 1

					print "Presenca: %d ; Ausencia : %d" % (freqCont, ausCont)

					cur.execute("SELECT COUNT(*) FROM presenca_sessaos WHERE deputado_id = '%s'" % (dep[0]))
					sess_bd = cur.fetchone()

					dataIniFormat = dataIni.split("/")
					dataFimFormat = dataFim.split("/")

					dataIniDT = dataIniFormat[2] + "-" + dataIniFormat[1] + "-" + dataIniFormat[0]
					dataFimDT = dataFimFormat[2] + "-" + dataFimFormat[1] + "-" + dataFimFormat[0]

					if int(sess_bd[0]) == 0:
						cur.execute("INSERT INTO presenca_sessaos (`id`, `deputado_id`, `presenca`, `ausencia`, `inicio`, `fim`, `created_at`, `updated_at`) VALUES (NULL, '%s', '%s', '%s', '%s', '%s', CURRENT_DATE(), CURRENT_DATE())" % (dep[0], freqCont, ausCont, dataIniDT, dataFimDT))
					else:
						cur.execute("UPDATE presenca_sessaos SET presenca = '%s', ausencia = '%s', inicio = '%s', fim = '%s', updated_at = CURRENT_DATE() WHERE deputado_id = '%s'" % (freqCont, ausCont, dataIniDT, dataFimDT, dep[0]))
						

			else:
				print "Failed to download file %s" % (ws)

	else:

		print "Invalid number of arguments"