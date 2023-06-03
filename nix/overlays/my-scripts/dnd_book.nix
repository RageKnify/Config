{ prev, final }:
prev.writeShellScriptBin "dnd_book.sh" ''
  BOOK_DIRECTORY="/home/jp/documents/dnd/books/"
  if [ -d "$BOOK_DIRECTORY" ] ; then
    cd $BOOK_DIRECTORY
    book=$(${final.coreutils}/bin/ls -1 *.pdf | \
        ${final.rofi}/bin/rofi -dmenu -p "Choose the book to open" \
        -matching fuzzy -i \
        -theme $XDG_DATA_HOME/rofi/themes/calc )
    if [ -n "$book" ] && [ -f "$book" ] ; then
      ${final.zathura}/bin/zathura $book;
    fi
  fi
''
