#/bin/sh
cp "$1" "$2" "$3"
cd "$3"
P="$(basename $1)"
patch -p1 < "$P"
rm "$P"
