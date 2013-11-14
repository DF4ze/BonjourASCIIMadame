#!/bin/sh

# Chemin et nom du fichier image à générer
filepath=$HOME/Desktop/Images
fileprefix=$filepath/bonjourmadame
todaywp=$fileprefix$(date +%y-%m-%d-%H-%M).jpg

# Récupération
wget http://www.bonjourmadame.fr  #| grep -Eo "(http://www.bonjourmadame.fr/photo/[^\"]+)|(http://[0-9]+.media.tumblr.com/tumblr[^\"]+)" | head -n 1 > /root/Desktop/Images/bonjourmadame.jpg #| wget -q -i - -O $todaywp
cat index.html | grep -Eo "(http://www.bonjourmadame.fr/photo/[^\"]+)|(<a class=\"photo-url\" href=\"http://[0-9]+.media.tumblr.com/[^\"]+)" > bjrMme_prsq_img.txt
#cat bjrMme_prsq_img.txt | grep -Eo "http://[0-9]+.media.tumblr.com/[^\"]+" > bjrMme_juste_img.txt
cat bjrMme_prsq_img.txt | grep -Eo "http://[0-9]+.media.tumblr.com/[^\"]+" | wget -q -i - -O $todaywp

# Nettoyage des fichiers temp.
rm index.html*
rm bjrMme_prsq_img.txt


## Génération du ASCII Art
cd $filepath

# Récup la largeur de l'image /!\ necessite l'installation du paquet "imagemagick"
largeur=$(convert $todaywp -print "%w\n" /dev/null 2>&1)
hauteur=$(convert $todaywp -print "%h\n" /dev/null 2>&1)

# tableau en croix : On veut une largeur MAX ... on va définir la hauteur
largeurascii=120
hauteurascii=$((($largeurascii*$largeur)/$hauteur))
# mais comme ce ne sont pas des carres qui s'affiche mais des rectangles... qui sont quasi 2 fois plus haut qu'ils ne sont large :
hauteurascii=hauteurascii/2 
#echo "Hauteur : " $hauteurascii" Largeur : " $largeurascii

# On transforme l'image en ASCII-Art
img2txt $todaywp -W $largeurascii -H $hauteurascii > bjrmme.txt

# On glisse tout ca dans le MOTD.
cp /root/Desktop/Images/bjrmme.txt /etc/motd
# avec une petite dedicace :)
echo "
Le MOTD qui fait dire \"Bonjour Madame\" =)
														By DF4ze" >> /etc/motd

echo ""
echo "-----==========--------"
echo "Mise a Jour avec succes"
echo "-----==========--------"
echo ""
cat /etc/motd




