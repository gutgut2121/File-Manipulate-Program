#! /bin/bash

if [ $# -eq 0 ]
        then echo "No file provided" 1>&2
        exit 1
elif [ ! -e $HOME/recyclebin/$1 ]
        then echo "File does not exist" 1>&2
        exit 1
fi

path=$(cat "$HOME/.restore.info" | grep "$1" | cut -d: -f2)


if [ -e $path ]
then echo "Do you want to overwrite? y/n"
     read overwrite
     if [[ $overwrite =~ ^[^(y|Y)] ]]
     then exit 1
     fi
fi

mv $HOME/recyclebin/$1 $path


cat "$HOME/.restore.info" | grep "$1" > delStorage.txt

grep -vf delStorage.txt $HOME/.restore.info > tmpFile

mv tmpFile $HOME/.restore.info

exit 0
