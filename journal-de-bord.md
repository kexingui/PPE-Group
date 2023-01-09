##septembre
Au début de cours le prof nous présente le déroulement général de ce cours « projet encadré » et tous les matériaux et les outils que nous devrons utiliser. 
Nous apprenions l’utilisation le shell, et les profs nous présentent le git. 

##4 octobre
 
Nous devons comment la première étape de travailler sur notre projet selon la constitution d’un groupe de travail, sera de choisir le mot adéquat. Nous devrons ensuite lister au moins 50 URLs de sites par langue qui traitent du sujet et qui contiennent des occurrences du mot choisi.  
 
Pour notre groupe nous avons eu de nombreuses discussions pour choisir le vocabulaire de l'étude. Au début nous sommes vraiment coincés dans le problème : est-ce que nous devons travailler seulement sur l'ambiguïté. Nous avons essayé d'étudier l'ambiguïté du même mot dans différentes langues, mais cela ne fonctionne pas très bien. 
 Nous proposons certains termes ayant plus d'un sens : baguette, place...  et quelques mots avec un contexte culturel : gendarme, grève... quelques mots ayant un sens abstrait : élection, relation, oscillation... Mais nous n'avons pas réussi à nous décider sur le mot.


# 12 octobre
Nous nous sommes mises d'accord sur quel mot nous allions étudier :« femme au foyer ». Dans notre groupe nous décidions à étudier en trois langues : Charlotte fait la partie de français, Kexin fait la partie de chinois et Aigerim fait la partie de russe ou kazakh.  
Mot/expression choisi: "femme au foyer"
On va se concentre sur les articles de presse, et article sur Internet.  
langues envisagées: français, mandarin, kazakh ou russe. 
Le but est de comprendre comment sont perçues les femmes au foyer et comment cette perception varie d'une culture à l'autre

# 15 octobre
pour le corpus, on reste sur des articles récents (2015-2022). 

# 25 novembre.

Nous reprenons le travail de groupe sur le sujet de femme au foyer.

# 30 novembre
Kexin: 
Nous avons bien organisé tous les branches necessaires pour notre projet. Charlotte a bien transmis les 50 urls françaises.
De ma part, je transmis les urls chinois,aspirations chinois, dumps chinois; ensuite je mis mon tableau, et je remplis un peu l’histoire de notre choix de mot.
Mais je rencontre un peu difféculté de compléter mon urls, j'ai seulement 20 maintnant, parce que c'est difficle de trouver les articles de presse officiels, de toute façon je vais élargir le champe de rechere, ou nous allons accpter aussi des article pas officiel sur Internet.

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
Aigrim a effectué un push de 50 urls en russe. 
# 7 décembre 
Aigerim :La correction de configuration de git user name.
Kexin: De ma part, je rencontre grand problème de run out de contxt et faire le concordance ： Après que je run mon script, il y a des fichiers de context qui affichent, mais tous les fichiers sont vides.
Après avoir demandé à mes camarades de classe, je me rends compte qu'il y avait un problème avec la définition  des variables dans mon script, et que les noms de fichiers dans le script ne correspondaient pas à mes noms de fichiers locaux. Pour moi le but des journée suivante est de règler ce problème.
Dans mon tableux chinois la concordance n'affiche pas, il me donne seument '"Contexte gauche"	"Cible" et	"Contexte droit". Cette problème me bloque. 

#10 décembre
charlotte: lors de la recherche d'urls en français et avant de faire des analyses, je peux observer un changement de perception des femmes au foyer selon l'orientation politique du media (journaux de droite et religieux ont une opinion plutôt positive des femmes au foyer qu'ils mettent en valeur, tandis que les autres pointent les risques et les désavantages de cette situation

#20 décembre
charlotte: Abandon de certaines langues car difficulté à trouver assez de materiel sur le sujet dans les langues en question
Kexin : Une membre de notre groupe décide de quitter notre peojet, dans ca cas on décide d'ajouter l'anglais et l'espagnol dans notre traviller. Charlotte s'occupe de trouver les urls d'espagol et moi je prépare les 50 urls d'anglais. J'ai essayé à exercuter le tableau anglais, la pluspart des urls marche, mais il y a certain urls qui ne marche pas, donc il y a beaucoup de chose à ranger. 

#22 décembre
charlotte: test des tableaux avec les url en anglais, espagnol et français
#23 décembre
charlotte: ajout du tableau en espagnol
#5 janvier
charlotte: dernières modifications sur les tableaux en anglais, espagnol et français, nettoyage de certains dossiers (les fichiers inutiles sont retirés
Kexin: De ma part, je fais le itrameur de anglais, français, et espagnol avec l'utilisation de site http://www.tal.univ-paris3.fr/trameur/iTrameur/. 

problème rencontre : 

D'abord, le script itrameur ne march pas bien sur mon Mac,  il présent erreur: 
RE error: illegal byte sequence
pour regler ce problème je consulte Internet et la solution trouvées : il faut ajouter  LC_CTYPE=C  devant sed pour Mac.
après le script marche bien et produit le corpus totale.
Après avoir testé à la fois dumps-text et contextes, j'ai constaté que le corpus produit par contextes était de meilleure qualité, j'ai donc choisi de continuer à utiliser le texte généré par contextes.

 Ensuite, sur itameur le pôle source doit toujours être un mot. Dans ce cas le mot en français «femme au foyer» et le mot en espagnol «ama de casa» ne pouvons d'être identifié parce que ce sont  les constructions de trois mots. Pendant le cours le prof me donner le conseil de remplacer  «femme au foyer» par «femme_au_foyer » pourque l'itrameur peut identifier le mot, mais quand je le effectuer  il y a encore le problème d'identifier le  pôle source. Ensuite j'essaie de mettre les mots ensemble en forme «femmeaufoyer» et «amadecasa», et cette fois ça marche sur itrameur. 
 
 Mais quand je re vérifie le cooccurrents, je trouve que il y a des mots outils qu’il nous n’intéresse pas : comme «le» «la» «une» «l’» en français ; «the»«or»«of» «A» en anglais ， après que je consulte Internet, je comprends qu’il faut effacer le stopword, cela est un étape de traiter le corpus dans le NLP.
 
# 6 janvier
 Kexin: 
 Afin d'éliminer les mots vides, j'utilise le programme python nltk. j'installe le stop liste de nltk, cela fonnction pour anglais, beaucoup de mots vides sont éliminés. 
 Mais pour français et espagnol, nitk n'est pas très efficace, il reste beaucoup de mot désagréable. Dans ce cas je trouve les autres liste de stopwords sur Internet mais ils ne fonctionnent non plus. 
 Pour le corpus chinois, il faut d'abord faire la segmention et puis éliminer les mots vide. j'ai essayé le script thulac donné par prof, mais ce script il me donne un text un peu bizzar, les mots sont separé mais il y a des "/"ajouté entre les mots séparés.
 Pour réglerce problàme, je chercher sur Internet et je trouve jieba pour segmentation et enlevé les stopwords en chinois. 

# 8 janvier 
Kexin: 
Problème de tableau. 
Quand je vérifiais le tableux sur notre page de site je trouve que en fait il y a des problème d’affichage dans le contexte d’espagnol et français: Le contenu du texte s'affiche sur la page, mais à l'extrême gauche de la page, il y a des caractère désagréable comme /dumps-text/cordances/. Donc le problème qu'on a rencontré dans itrameur c'est à cause du corpus total origine de context. 

Cela est à cause de egrep. 
En fait egrep n’est pas très efface  quand il cherche les mots avec espace, ici c’est le cas de « femme au foyer» et « ama de casa ». Cela est pour quoi notre script fonctionne pour trouver le mot anglais et chinois,  mais il y a le problème pour français et espagnol. 
 Pour règler ce problème, il faut qu’on déclarer le mot après grep: 
En français : 
NB_OCC=$(grep -E -o "[Ff]emmes? au foyer" ./dumps-text/$basename-$lineno.txt | wc -l)
grep -E -A2 -B2 "[Ff]emmes? au foyer" ./dumps-text/$basename-$lineno.txt > ./contextes/$basename-$lineno.txt
En espagnol : 
NB_OCC=$(grep -E -o "[Aa]mas? de casa" ./dumps-text/$basename-$lineno.txt | wc -l)
grep -E -A2 -B2 "[Aa]mas? de casa" ./dumps-text/$basename-$lineno.txt > ./contextes/$basename-$lineno.txt

Après ce changement, les contextes fonctionnent bien. 


















