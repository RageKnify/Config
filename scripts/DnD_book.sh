#!/bin/sh

cd /home/jp/Documents/DnD/Books/
book=$(ls -1 *.pdf | dmenu -i -l 10 -p "Which book to open?" )
echo -n $book
if [ -n "$book" ] && [ -f "$book" ] ; then
	zathura $book;
fi
