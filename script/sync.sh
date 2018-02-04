#! /bin/sh

set -eu

files=$(find *.symlink -type f)

for srcfile in $files
do
	src=$(pwd)/$srcfile
	dest=$HOME/.$(basename $srcfile .symlink)

	if [[ -e $dest ]]
	then
		if [[ -L $dest ]] && [[ "$(readlink $dest)" -ef $src ]]
		then
			echo "$dest already symlinked to $srcfile"
		else
			(>&2 echo "$dest already exists (and is not a symlink to $srcfile). Skipped.")
		fi
	else
		echo "Symlinking $srcfile to $dest"
		ln -s $src $dest || (>&2 echo "Symlink failed!")
	fi
done
