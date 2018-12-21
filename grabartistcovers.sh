#!/bin/bash

#testing curl. Grabs miles davis records and saves all jpgs
echo 'What artist are you seraching for? Ex: miles davis'
read artist
#calls the website discogs for artist and saves to a temp file
file="discogs.html"
file2="temp_links.txt"
file3="temp_names.txt"
file4="joined.txt"

artist_name=$(echo $artist | sed 's/ /\+/g'| tr [:upper:] [:lower:])
echo "Downloading $artist data"
echo $(curl https://www.discogs.com/search/?q=${artist_name}&type=all) > $file
fmt $file | grep -A3 "class\=\"thumbnail_center\"" | grep "alt" | cut -c 6- | sed 's/\".*//g' | sed 's/ /_/g' | nl > $file3
fmt $file | grep -A3 "class\=\"thumbnail_center\"" | grep "^data\-src" | cut -c 10- | sed 's/\"//g' | nl > $file2
rm $file
join $file2 $file3 | cut -c 3- | sed 's/^\s//g' > $file4
rm $file2 $file3
dir=$( echo $artist_name | sed 's/\+/_/')
echo "Making directory $dir"
mkdir $dir
while IFS= read -r src
do 
	txt="temp.txt"
	#breaks the name out the column and saves it as filename
	filename=$(echo $src | sed 's/^h.*\s//g')
	link=$(echo $src | sed 's/\s.*//g')
	#saves albumcovers donwloaded as a jpeg
	echo "Downloading $filename"
	curl ${link} > "./${dir}/${filename}.jpg"
done < $file4
rm $file4
exit

