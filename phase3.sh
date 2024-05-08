#! /bin/bash

# Create recyclebin directory
if [ ! -d $HOME/recyclebin ]
    then
        mkdir $HOME/recyclebin
fi

if [ $# -eq 0 ]
        then echo "No file provided" 1>&2
        exit 1
fi

inter=false
verb=false

while getopts :iv opt
do
        case $opt in
                i) inter=true;;
                v) verb=true;;
                *) echo Bad Option - $OPTARG
                   exit 1;;
        esac

        shift $(($OPTIND - 1))

done

for i in $*
do

if [[ $# -eq 1 && ! -e $1 ]]
        then echo "File does not exist" 1>&2
        exit 1
elif [[ $# -eq 1 && -d $1 ]]
        then echo "Directory name provied" 1>&2
        exit 1
elif echo $1 | grep "recycle"  > /dev/null && [ $# -eq 1 ]
        then echo "Attempting to delete recycle - operation aborted" 1>&2
        exit 1
fi

if [[ $# -gt 1 && ( ! -e $i || -d $i ) ]]
        then continue
fi

if echo $i | grep "recycle"  > /dev/null && [ $# -gt 1 ]
        then continue
fi


if $inter
   then echo "rm: remove regular file '$i'?"
         read choice
         if [[ $choice =~ ^[^(y|Y)] ]]
         then continue
         fi
fi


# Hadle fileName
fileName=$(basename $i)
inode=$(ls -i $i | cut -c1-7)
fileName_inode=$fileName"_"$inode

#echo $fileName_inode


if [ ! -e $HOME/.restore.info ]
    then
        touch $HOME/.restore.info
fi

path=$(readlink -f $i)
echo $fileName_inode:$path >> $HOME/.restore.info

#Move the file to recycle bin
mv $i $HOME/recyclebin/$fileName_inode


if $verb
   then echo "removed $i"
fi

done

exit 0
                  