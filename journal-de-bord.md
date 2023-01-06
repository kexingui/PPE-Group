##séance 1,2 3
Au début de cours le prof nous présente le déroulement général de ce cours « projet encadré » et tous les matériaux et les outils que nous devrons utiliser. 
Nous apprenions l’utilisation le shell, et les profs nous présentent le git. 

##séance 04-10 
 
Nous devons comment la première étape de travailler sur notre projet selon la constitution d’un groupe de travail, sera de choisir le mot adéquat. Nous devrons ensuite lister au moins 50 URLs de sites par langue qui traitent du sujet et qui contiennent des occurrences du mot choisi.  
 
Pour notre groupe nous avons eu de nombreuses discussions pour choisir le vocabulaire de l'étude. Au début nous sommes vraiment coincés dans le problème : est-ce que nous devons travailler seulement sur l'ambiguïté. Nous avons essayé d'étudier l'ambiguïté du même mot dans différentes langues, mais cela ne fonctionne pas très bien. 
 Nous proposons certains termes ayant plus d'un sens : baguette, place...  et quelques mots avec un contexte culturel : gendarme, grève... quelques mots ayant un sens abstrait : élection, relation, oscillation... Mais nous n'avons pas réussi à nous décider sur le mot  




























# octobre
Mot/expression choisi: "femme au foyer"
On se concentre sur les articles de presse 
langues envisagées: français, mandarin, kazakh ou russe
Le but est de comprendre comment sont perçues les femmes au foyer et comment cette perception varie d'une culture à l'autre

# 15 novembre 
On reste sur des articles récents (2015-2022)

# 25 novembre.

Nous reprenons le travail de groupe sur le sujet de femme au foyer.

# 30 novembre

Nous avons bien organisé tous les branches necessaires pour notre projet. Charlotte a bien transmis les 50 urls françaises.
De ma part, je transmis les urls chinois,aspirations chinois, dumps chinois; ensuite je mis mon tableau, etje remplis un peu l’histoire de notre choix de mot.
Mais je rencontre un peu difféculté de compléter mon urls, j'ai seulement 20 maintnant, parce que c'est difficle de trouver les articles de presse officiels, de toute façon je vais élargir
champe de rechere, ou nous allons accpter aussi des article pas officiel sur Internet.



notre étape suivante
Le but d'aujoud'hui

-compte l'occurence.
-trouver les mots dans leur context
-concordance ajouter une fiche concordance.sh

# 1 décembre
Après avoir réuni les 50 URLs en français et sans analyse (juste en parcourant les articles) je remarque les choses suivantes:
La plupart des articles français semblent relever surtout des aspects negatifs liés au fait d'être femme au foyer (fatigue, manque de reconnaissance, mort professionnelle, précarité/dépendance au conjoint) 

Les articles qui mentionnent des aspects positifs et/ou font la promotion des femmes au foyer semblent provenir de médias plus conservateurs/de droite (journaux chrétiens, le figaro etc...) 

Parfois l'expression "femme au foyer" est remplacée par une expression équivalente comme "mère au foyer" et ces différentes expressions peuvent être au pluriel
Il faudrait donc utiliser une expression régulière tel que :
(mère|femme|maman)s?(au foyer)
pour repérer les occurences de ce concept dans les différents textes
De plus, le index.html est bien rédigé et notre page git est bien crée.

# 5 décembre 
J'ai effectué un push de 50 urls en russe. 
# 7 décembre 
Aigerim :La correction de configuration de git user name.
Kexin: De ma part, je rencontre grand problème de run out de contxt et faire le concordance ： Après que je run mon script, il y a des fichiers de context qui affichent, mais tous les fichiers sont vides.
Après avoir demandé à mes camarades de classe, je me rends compte qu'il y avait un problème avec la définition  des variables dans mon script, et que les noms de fichiers dans le script ne correspondaient pas à mes noms de fichiers locaux. Pour moi le but des journée suivante est de règler ce problème.
De plus, j‘ai trouvé l'exemple html de la désignation de site pour préparer l'organisation de notre page, et un bon exemple de scripte de tableau des étudiants ancient pour nous aider à avancer.
#10 décembre
charlotte: lors de la recherche d'urls en français et avant de faire des analyses, je peux observer un changement de perception des femmes au foyer selon l'orientation politique du media (journaux de droite et religieux ont une opinion plutôt positive des femmes au foyer qu'ils mettent en valeur, tandis que les autres pointent les risques et les désavantages de cette situation
#20 décembre
charlotte: Abandon de certaines langues car difficulté à trouver assez de materiel sur le sujet dans les langues en question
#22 décembre
charlotte: test des tableaux avec les url en anglais, espagnol et français
#23 décembre
charlotte: ajout du tableau en espagnol
#5 janvier
charlotte: dernières modifications sur les tableaux en anglais, espagnol et français, nettoyage de certains dossiers (les fichiers inutiles sont retirés
