#!/usr/bin/bash


fichier_text=$1
motif=$2

if [[ $# -ne 2 ]]
then
	echo "Ce programme demande exactement deux arguments."
	exit
fi

if [[ ! -f $fichier_text ]]
then
  echo "le fichier $fichier_text n'existe pas"
  exit
fi

if [[ -z $motif ]]
then
  echo "le motif est vide"
  exit
fi

echo "
<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <title>Concordance</title>
</head>
<body>
<table>
<thead>
  <tr>
    <th class=\"has-text-right\">Contexte gauche</th>
    <th>Cible</th>
    <th class=\"has-text-left\">Contexte droit</th>
  </tr>
</thead>
<tbody>
"
##sur mac pour utiliser GUN grep il faut préfixer grep avec g
ggrep -P "\p{Han}{0,5}$motif(\p{Han}){0,5}" $fichier_text | sed -E "s/(.*)($motif)(.*)/<tr><td class="has-text-right">\1<\/td><td class="has-text-centre">\2<\/td><td class="has-text-left">\3<\/td><\/tr>/"
##pour français.anglais,espagnol.on utilise la ligne suivant: 
#grep -E -o "(\w+\W+){0,5}\b$motif\b(\W+\w+){0,5}" $fichier_text | sed -E "s/(.*)($motif)(.*)/<tr><td>\1<\/td><td>\2<\/td><td>\3<\/td><\/tr>/"

echo "
</tbody>
</table>
</body>
</html>
"

