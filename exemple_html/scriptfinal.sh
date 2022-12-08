#!/usr/bin/bash
# pour lancer ce script :
# bash scriptfinal.sh <dossier URL> <dossier TABLEAUX>
#--------------------------------------
# stocker les arguments dans les variables
DOSSIER_URL=$1
DOSSIER_TABLEAUX=$2
#--------------------------------------
# todo : valider les arguments (ou arrêter le programme)
echo $DOSSIER_URL
echo $DOSSIER_TABLEAUX
#--------------------------------------
# en-tête du fichier html
echo "<html>
	<head>
	<meta charset=\"utf-8\"/>
		<style>
		table {
		width: 600px;
		border: 4px solid #6c3483;
		border-collapse: collapse;
		}
		th, td {
		border: 1px solid black;
		padding: 5px;
		}
		</style>
	</head>
	<body>" > $DOSSIER_TABLEAUX/tableau.html
#--------------------------------------
# compteur de tableaux
cptTableau=0;
# pour chaque élément contenu dans DOSSIER_URL
for fichier in $(ls $DOSSIER_URL); do
	echo "Fichier lu : $fichier"
	# on compte les tableaux
	cptTableau=$(($cptTableau + 1))
	# compteur d'url dans chaque tableau
	compteur=0
	# début du tableau
	echo "<table align=\"center\">" >> $DOSSIER_TABLEAUX/tableau.html
	if [[ $cptTableau == 1 ]]
	then
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>TABLEAU 1 : Français</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>MOTIF : diplôme</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
	# pour le coréen :
	elif [[ $cptTableau == 2 ]]
	then
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>Tableau 2 : Coréen</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>MOTIF : 졸업장|졸업 증서</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
	# pour le chinois :
	elif [[ $cptTableau == 3 ]]
	then
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>Tableau 3 : Chinois</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
		echo "<tr bgcolor=\"5dade2\"><td colspan=\"12\" align=\"center\"><strong>MOTIF : 文凭|学位 证书|毕业 证书</strong></td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
	fi
	echo "<tr bgcolor=\"aed6f1\"><td>Num.</td><td>Code HTTP</td><td>Encodage</td><td>URL</td><td>Page aspirée</td><td>Dump</td><td>Index</td><td>Bigrammes</td><td>Trigrammes</td><td>Contextes txt</td><td>Contextes html</td><td>Occurences motif</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
	# lire chaque ligne du fichier
	while read line; do
		# on compte les lignes
		compteur=$(($compteur + 1))
		echo "NUMERO URL : $compteur"
		# aspiration des pages via leur URL (dossier PAGES ASPIREES)
		# on récupère le code HTTP (qui permet de savoir si la connexion vers l'url est ok) dans une variable
		codeHTTP=$(curl -L -w '%{http_code}\n' -o ./PAGES-ASPIREES/$cptTableau-$compteur.html $line)
		echo "<tr><td>$compteur</td><td>$codeHTTP</td>" >> $DOSSIER_TABLEAUX/tableau.html
		if [[ $codeHTTP == 200 ]]
		then
			# on récupère l'encodage dans une variable
			encodage=$(curl -L -I $line | egrep -i charset | cut -d"=" -f2 | tr -d '\r' | tr -d '\n' | tr "[:lower:]" "[:upper:]")
			echo "ENCODAGE : $encodage"
			# si encodage = UTF8
			if [[ $encodage == "UTF-8" ]]
			then
				# l'encodage est bien UTF-8, on continue
				lynx -assume_charset="UTF-8" -display_charset="UTF-8" -dump -nolist ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./DUMP-TEXT/"$cptTableau-$compteur".txt
				# nettoyage des fichiers DUMP
				sed -i '/  [*+]/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/__/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/|/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/BUTTON/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/alternate/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/http/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/IFRAME/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				sed -i '/png/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
				# création des index
				# pour le français :
				if [[ $cptTableau == 1 ]]
				then
					cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
					cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
				# pour le coréen :
				elif [[ $cptTableau == 2 ]]
				then
					python ./PROGRAMMES/segmentizer.py ./DUMP-TEXT/"$cptTableau-$compteur".txt > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
				# pour le chinois :
				elif [[ $cptTableau == 3 ]]
				then
					bash ./PROGRAMMES/stanford-segmenter-2020-11-17/segment.sh pku ./DUMP-TEXT/"$cptTableau-$compteur".txt UTF-8 0 > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
				fi
				# création des bigrammes
				head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt
				tail -n +2 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt
				paste ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt
				cat ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-bigramme.txt
				# création des trigrammes
				head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt
				tail -n +3 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt
				paste ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-trigramme.txt
				# création des contextes txt
				# pour le français :
				if [[ $cptTableau == 1 ]]
				then
					cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -iC1 --color "diplôme" > ./CONTEXTES/"$cptTableau-$compteur".txt
					nb_motif=$(cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -ic "diplôme")
				# pour le coréen :
				elif [[ $cptTableau == 2 ]]
				then
					cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "졸업장|졸업 증서" > ./CONTEXTES/"$cptTableau-$compteur".txt
					nb_motif_joleobjang=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업장")
					nb_motif_joleobjeungseo=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업 증서")
					nb_motif=$(($nb_motif_joleobjang+$nb_motif_joleobjeungseo))
				# pour le chinois :
				elif [[ $cptTableau == 3 ]]
				then
					cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "文凭|学位 证书|毕业 证书" > ./CONTEXTES/"$cptTableau-$compteur".txt
					nb_motif_wenping=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "文凭")
					nb_motif_xuewei=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "学位 证书")
					nb_motif_biye=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "毕业 证书")
					nb_motif=$(($nb_motif_wenping+$nb_motif_xuewei+$nb_motif_biye))
				fi
				# création des contextes html
				perl ./PROGRAMMES/minigrepmultilingue-v2.2-regexp/minigrepmultilingue.pl "UTF-8" ./DUMP-TEXT/"$cptTableau-$compteur".txt ./PROGRAMMES/motif.txt
				mv resultat-extraction.html ./CONTEXTES/"$cptTableau-$compteur"-minigrep.html
				# concaténation totale des fichiers DUMP et CONTEXTES
				echo "<file=\"$cptTableau-$compteur\">" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
				# pour le français
				if [[ $cptTableau == 1 ]]
				then
					cat ./DUMP-TEXT/"$cptTableau-$compteur".txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
				# pour le coréen :
				elif [[ $cptTableau == 2 ]]
				then
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
				# pour le chinois :
				elif [[ $cptTableau == 3 ]]
				then
					cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
				fi
				echo "</file>" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
				echo "<file=\"$cptTableau-$compteur\">" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
				cat ./CONTEXTES/"$cptTableau-$compteur".txt >> ./CONTEXTES/corpus-complet-$cptTableau.txt
				echo "</file>" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
				#on remplit le tableau
				echo "<td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-index.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-bigramme.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-trigramme.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur-minigrep.html\">$cptTableau-$compteur</a></td><td>$nb_motif</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
			else
				# si l'encodage n'est pas UTF-8
				echo "ENCODAGE PAS UTF-8"
				if [[ $encodage != "" ]]
				then
					reponse=$(iconv -l | egrep "$encodage") ;
					if  [[ $reponse != "" ]]
					then
						# on convertit la page aspirée en UTF-8
						iconv -f $encodage -t UTF-8 ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./PAGES-ASPIREES/"$cptTableau-$compteur".html
						# on est en UTF-8, on continue
						lynx -assume_charset="UTF-8" -display_charset="UTF-8" -dump -nolist ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./DUMP-TEXT/"$cptTableau-$compteur".txt
						# nettoyage des fichiers DUMP
						sed -i '/  [*+]/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/__/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/|/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/BUTTON/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/alternate/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/http/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/IFRAME/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/png/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						# création des index
						# pour le français :
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							python ./PROGRAMMES/segmentizer.py ./DUMP-TEXT/"$cptTableau-$compteur".txt > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							bash ./PROGRAMMES/stanford-segmenter-2020-11-17/segment.sh pku ./DUMP-TEXT/"$cptTableau-$compteur".txt UTF-8 0 > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						fi
						# création des bigrammes
						head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt
						tail -n +2 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt
						paste ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt
						cat ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-bigramme.txt
						# création des trigrammes
						head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt
						tail -n +3 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt
						paste ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-trigramme.txt
						# création des contextes txt
						# pour le français :
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -iC1 --color "diplôme" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif=$(cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -ic "diplôme")
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "졸업장|졸업 증서" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif_joleobjang=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업장")
							nb_motif_joleobjeungseo=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업 증서")
							nb_motif=$(($nb_motif_joleobjang+$nb_motif_joleobjeungseo))
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "文凭|学位 证书|毕业 证书" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif_wenping=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "文凭")
							nb_motif_xuewei=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "学位 证书")
							nb_motif_biye=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "毕业 证书")
							nb_motif=$(($nb_motif_wenping+$nb_motif_xuewei+$nb_motif_biye))
						fi
						# création des contextes html
						perl ./PROGRAMMES/minigrepmultilingue-v2.2-regexp/minigrepmultilingue.pl "UTF-8" ./DUMP-TEXT/"$cptTableau-$compteur".txt ./PROGRAMMES/motif.txt
						mv resultat-extraction.html ./CONTEXTES/"$cptTableau-$compteur"-minigrep.html
						# concaténation totale des fichiers DUMP et CONTEXTES
						echo "<file=\"$cptTableau-$compteur\">" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le français
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						fi
						echo "</file>" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						echo "<file=\"$cptTableau-$compteur\">" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						cat ./CONTEXTES/"$cptTableau-$compteur".txt >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						echo "</file>" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						#on remplit le tableau
						echo "<td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-index.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-bigramme.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-trigramme.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur-minigrep.html\">$cptTableau-$compteur</a></td><td>$nb_motif</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
					else
						echo "ENCODAGE PAS RECONNU PAR ICONV"
						encodage=$(perl ./PROGRAMMES/detect-encoding.pl PAGES-ASPIREES/$cptTableau-$compteur.html | tr -d '\r' | tr -d '\n' | tr "[:lower:]" "[:upper:]")
						echo "ENCODAGE DETECT-ENCODING : $encodage"
						reponse=$(iconv -l | egrep -io "$encodage")
						if  [[ $reponse != "" ]]
						then
							# on convertit la page aspirée en UTF-8
							iconv -f $encodage -t UTF-8 ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./PAGES-ASPIREES/"$cptTableau-$compteur".html
							# on est en UTF-8, on continue
							lynx -assume_charset="UTF-8" -display_charset="UTF-8" -dump -nolist ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./DUMP-TEXT/"$cptTableau-$compteur".txt
							# nettoyage des fichiers DUMP
							sed -i '/  [*+]/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/__/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/|/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/BUTTON/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/alternate/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/http/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/IFRAME/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							sed -i '/png/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
							# création des index
							# pour le français :
							if [[ $cptTableau == 1 ]]
							then
								cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
								cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
							# pour le coréen :
							elif [[ $cptTableau == 2 ]]
							then
								python ./PROGRAMMES/segmentizer.py ./DUMP-TEXT/"$cptTableau-$compteur".txt > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
							# pour le chinois :
							elif [[ $cptTableau == 3 ]]
							then
								bash ./PROGRAMMES/stanford-segmenter-2020-11-17/segment.sh pku ./DUMP-TEXT/"$cptTableau-$compteur".txt UTF-8 0 > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
							fi
							# création des bigrammes
							head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt
							tail -n +2 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt
							paste ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-bigramme.txt
							# création des trigrammes
							head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt
							tail -n +3 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt
							paste ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-trigramme.txt
							# création des contextes txt
							# pour le français :
							if [[ $cptTableau == 1 ]]
							then
								cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -iC1 --color "diplôme" > ./CONTEXTES/"$cptTableau-$compteur".txt
								nb_motif=$(cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -ic "diplôme")
							# pour le coréen :
							elif [[ $cptTableau == 2 ]]
							then
								cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "졸업장|졸업 증서" > ./CONTEXTES/"$cptTableau-$compteur".txt
								nb_motif_joleobjang=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업장")
								nb_motif_joleobjeungseo=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업 증서")
								nb_motif=$(($nb_motif_joleobjang+$nb_motif_joleobjeungseo))
							# pour le chinois :
							elif [[ $cptTableau == 3 ]]
							then
								cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "文凭|学位 证书|毕业 证书" > ./CONTEXTES/"$cptTableau-$compteur".txt
								nb_motif_wenping=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "文凭")
								nb_motif_xuewei=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "学位 证书")
								nb_motif_biye=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "毕业 证书")
								nb_motif=$(($nb_motif_wenping+$nb_motif_xuewei+$nb_motif_biye))
							fi
							# création des contextes html
							perl ./PROGRAMMES/minigrepmultilingue-v2.2-regexp/minigrepmultilingue.pl "UTF-8" ./DUMP-TEXT/"$cptTableau-$compteur".txt ./PROGRAMMES/motif.txt
							mv resultat-extraction.html ./CONTEXTES/"$cptTableau-$compteur"-minigrep.html
							# concaténation totale des fichiers DUMP et CONTEXTES
							echo "<file=\"$cptTableau-$compteur\">" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
							# pour le français
							if [[ $cptTableau == 1 ]]
							then
								cat ./DUMP-TEXT/"$cptTableau-$compteur".txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
							# pour le coréen :
							elif [[ $cptTableau == 2 ]]
							then
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
							# pour le chinois :
							elif [[ $cptTableau == 3 ]]
							then
								cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
							fi
							echo "</file>" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
							echo "<file=\"$cptTableau-$compteur\">" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
							cat ./CONTEXTES/"$cptTableau-$compteur".txt >> ./CONTEXTES/corpus-complet-$cptTableau.txt
							echo "</file>" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
							#on remplit le tableau
							echo "<td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-index.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-bigramme.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-trigramme.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur-minigrep.html\">$cptTableau-$compteur</a></td><td>$nb_motif</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
						else
							echo "ENCODAGE TOUJOURS PAS OK"
							# on remplit quand même le tableau
							echo "<td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
						fi
					fi
				else
					echo "ENCODAGE VIDE"
					encodage=$(perl ./PROGRAMMES/detect-encoding.pl PAGES-ASPIREES/$cptTableau-$compteur.html | tr -d '\r' | tr -d '\n' | tr "[:lower:]" "[:upper:]")
					echo "ENCODAGE DETECT-ENCODING : $encodage"
					reponse=$(iconv -l | egrep -io "$encodage") ;
					if  [[ $reponse != "" ]]
					then
						# on convertit la page aspirée en UTF-8
						iconv -f $encodage -t UTF-8 ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./PAGES-ASPIREES/"$cptTableau-$compteur".html
						# on est en UTF-8, on continue
						lynx -assume_charset="UTF-8" -display_charset="UTF-8" -dump -nolist ./PAGES-ASPIREES/"$cptTableau-$compteur".html > ./DUMP-TEXT/"$cptTableau-$compteur".txt
						# nettoyage des fichiers DUMP
						sed -i '/  [*+]/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/__/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/|/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/BUTTON/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/alternate/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/http/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/IFRAME/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						sed -i '/png/d' ./DUMP-TEXT/$cptTableau-$compteur.txt
						# création des index
						# pour le français :
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt | grep -o -P "\p{Ll}+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							python ./PROGRAMMES/segmentizer.py ./DUMP-TEXT/"$cptTableau-$compteur".txt > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Hangul}\p{Ll}\p{Han}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							bash ./PROGRAMMES/stanford-segmenter-2020-11-17/segment.sh pku ./DUMP-TEXT/"$cptTableau-$compteur".txt UTF-8 0 > ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-index.txt
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt | grep -o -P "[\p{Han}\p{Ll}]+" > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt
						fi
						# création des bigrammes
						head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt
						tail -n +2 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt
						paste ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme1.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme2.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt
						cat ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-bigramme.txt
						# création des trigrammes
						head -n -1 ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt
						tail -n +3 ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme.txt > ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt
						paste ./DUMP-TEXT/"$cptTableau-$compteur"-all-bigramme2.txt ./DUMP-TEXT/"$cptTableau-$compteur"-unigramme3.txt | sort | uniq -c | sort -nr > ./DUMP-TEXT/"$cptTableau-$compteur"-trigramme.txt
						# création des contextes txt
						# pour le français :
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -iC1 --color "diplôme" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif=$(cat ./DUMP-TEXT/$cptTableau-$compteur.txt | egrep -ic "diplôme")
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "졸업장|졸업 증서" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif_joleobjang=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업장")
							nb_motif_joleobjeungseo=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "졸업 증서")
							nb_motif=$(($nb_motif_joleobjang+$nb_motif_joleobjeungseo))
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -iC1 --color "文凭|学位 证书|毕业 证书" > ./CONTEXTES/"$cptTableau-$compteur".txt
							nb_motif_wenping=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "文凭")
							nb_motif_xuewei=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "学位 证书")
							nb_motif_biye=$(cat ./DUMP-TEXT/$cptTableau-$compteur-segmentized.txt | egrep -c "毕业 证书")
							nb_motif=$(($nb_motif_wenping+$nb_motif_xuewei+$nb_motif_biye))
						fi
						# création des contextes html
						perl ./PROGRAMMES/minigrepmultilingue-v2.2-regexp/minigrepmultilingue.pl "UTF-8" ./DUMP-TEXT/"$cptTableau-$compteur".txt ./PROGRAMMES/motif.txt
						mv resultat-extraction.html ./CONTEXTES/"$cptTableau-$compteur"-minigrep.html
						# concaténation totale des fichiers DUMP et CONTEXTES
						echo "<file=\"$cptTableau-$compteur\">" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le français
						if [[ $cptTableau == 1 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur".txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le coréen :
						elif [[ $cptTableau == 2 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						# pour le chinois :
						elif [[ $cptTableau == 3 ]]
						then
							cat ./DUMP-TEXT/"$cptTableau-$compteur"-segmentized.txt >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						fi
						echo "</file>" >> ./DUMP-TEXT/corpus-complet-$cptTableau.txt
						echo "<file=\"$cptTableau-$compteur\">" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						cat ./CONTEXTES/"$cptTableau-$compteur".txt >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						echo "</file>" >> ./CONTEXTES/corpus-complet-$cptTableau.txt
						#on remplit le tableau
						echo "<td>$encodage</td><td><a href=\"$line\">$line</a></td><td><a href=\"../PAGES-ASPIREES/$cptTableau-$compteur.html\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-index.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-bigramme.txt\">$cptTableau-$compteur</a></td><td><a href=\"../DUMP-TEXT/$cptTableau-$compteur-trigramme.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur.txt\">$cptTableau-$compteur</td><td><a href=\"../CONTEXTES/$cptTableau-$compteur-minigrep.html\">$cptTableau-$compteur</a></td><td>$nb_motif</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
					else
						echo "ENCODAGE TOUJOURS PAS OK"
						# on remplit quand même le tableau
						echo "<td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
					fi
				fi	
			fi
		else
			# si l'URL est inaccessible (code HTTP n'est pas 200)
			echo "<td>-</td><td><a href=\"$line\">$line</a></td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>" >> $DOSSIER_TABLEAUX/tableau.html
			echo "CODE HTTP PAS 200"
		fi
	done < $DOSSIER_URL/$fichier
	# insertion des fichiers concaténés dans le tableau
	echo "<tr><th colspan=\"5\"><td><a href=\"../DUMP-TEXT/corpus-complet-$cptTableau.txt\">Fichier DUMP global</td><td colspan=\"3\"></td><td><a href=\"../CONTEXTES/corpus-complet-$cptTableau.txt\">Fichier CONTEXTES global</td></th></tr>" >> $DOSSIER_TABLEAUX/tableau.html
	# fermeture du tableau
	echo "</table><hr/>" >> $DOSSIER_TABLEAUX/tableau.html
done
#--------------------------------------
echo "</body>
</html>" >> $DOSSIER_TABLEAUX/tableau.html
exit;