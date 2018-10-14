#!/usr/bin/env bash

echo "Making symbolic links for dotfiles, all in $HOME directory."

FILES=$(ls -1 | grep -v "README" | grep -v "install.sh")


for name in $FILES;do
    ln -s ./$name $HOME/.$name
    echo "Created link for: $HOME/.$name"
done

. $HOME/.bash_profile

echo "Done."
