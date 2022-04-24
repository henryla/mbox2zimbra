#!/bin/bash

if [ "$1" != "" ]; then

# path to big mbox file
SRC_PATH="$1"
# destination mbox file for each splited message
SPLIT_SUF="%04d.mbox"
# maximun 3000 for each directory for splited files
SPLIT_LOOP=3000
# last file which contains the remained un-splited messages
REMAIN_FILE="`expr $SPLIT_LOOP + 1`.mbox"
# filename of the remainied messages for next split
SRC_FILE="remain_mailbox"
# initial return value for csplit command
TF="0"
# Index of directory for splited files
DIRIDX=0

# If error, leave loop
while [ "$TF" = "0" ];
do

# prepare the name of the directory for splited files
SPLIT_PRE="mail`printf %04d $DIRIDX`/"
echo "Source: $SRC_PATH"
echo "Dest: $SPLIT_PRE"

# if directory exists, force removed all files in this directory
# if not exists, create directory
if [ -e $SPLIT_PRE ]; then
echo "Remove exists dir $SPLIT_PRE"
rm -f ${SPLIT_PRE}* 2>&1
else
mkdir -p $SPLIT_PRE 2>&1
fi

# We use csplit for spliting the all messagess into mbox files by pattern '^From '.
# Due to $SPLIT_LOOP is 3000, the last file 3001.mbox will contains the un-splited messages
csplit -n 4 --suppress-matched -k -f $SPLIT_PRE -b $SPLIT_SUF $SRC_PATH '/^From /' {$SPLIT_LOOP} 2>&1
# Set the return of above command in TF
TF="$?"
# increase the index of directory (for next directory)
DIRIDX=`expr $DIRIDX + 1`
# mv the last file from current directory into current execute directory in file name $SRC_FILE
mv ${SPLIT_PRE}${REMAIN_FILE} ./${SRC_FILE} 2>&1
# set remained messages file to SRC_PATH for next split process
SRC_PATH="${SRC_FILE}"

done

else

echo "Usage: $0 <path to big mbox file exported by Google Mail>"

fi
