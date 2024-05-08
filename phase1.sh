#! /bin/bash

# Create recyclebin directory
if [ ! -d $HOME/recyclebin ]
    then
        mkdir $HOME/recyclebin
fi

if [ $# -eq 0 ]
        then echo "No file provided" 1>&2
        exit 1
elif [ ! -e $1 ]
        then echo "File does not exist" 1>&2
        exit 1
elif [ -d $1 ]
        then echo "Directory name provied" 1>&2
        exit 1
elif  echo $1 | grep "recycle"  > /dev/null
        then echo "Attempting to delete recycle - operation aborted" 1>&2
        exit 1
fi

# Hadle fileName
fileName=$(basename $1)
inode=$(ls -i $1 | cut -c1-7)
fileName_inode=$fileName"_"$inode

#echo $fileName_inode


if [ ! -e $HOME/.restore.info ]
    then
        touch $HOME/.restore.info
fi

path=$(readlink -f $1)
echo $fileName_inode:$path >> $HOME/.restore.info

#Move the file to recycle bin
mv $1 $HOME/recyclebin/$fileName_inode

exit 0
