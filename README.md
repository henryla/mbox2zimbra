# mbox2zimbra
Import mbox, includes multi messages (emails), into Zimbra Email System

The scripts are focus on importing exported mbox from Google Mail.

# Prerequest
1. For linux...
2. Shall be admin of Zimbra.
3. Run the scripts as 'zimbra' user.
4. You might need enough space. ( at least, larger than the size of extract email x 2 )
5. Ability to modify the shall script. (Not necessary if scripts run without error. ^o^ )
6. Command 'csplit' and 'zmmailbox' shall be available.

# Preparation before import
1. Get the exported email from Google Mail.
2. Upload file to the Zimbra Server.
3. You may have to modifiy the scripts to fit your environment.
4. Create the sub-folder in the Zimbra's Email Web UI for importing. (The script will not automtically create the sub-folder.)

# What's the scripts do - split_mbox.sh
This script is for spliting the big, multi messages (emails) file into .mbox files. Each .mbox file contains only 1 email data.

During I was trying to import google's mbox into Zimbra, the date of email is not correct if I directly imported google's mbox. So I made a script by using csplit to split the multi messages into single message (1 email) files. And regarding the searching time for each directory, a directory only contains 3000 .mbox files. You could modify the script to inscreaing the number of files for each directory.

Command 'csplit' is used for splitting file by pattern "^From ". And each splited message is stored in .mbox file.

# What's the scripts do - import_mbox.sh
After splitting the big, multi messages (emails) file, this script can be used to import all .mbox files.

You may do the import by directly using command 'zmmailbox'. This script uses the same command for the same action.

If you split google's mbox by the script 'split_mbox.sh', this script could easily import all splited .mbox.

# Procedure for importing Google's exported mbox
1. Login as user 'zimbra'
2. Clone this project

        git clone https://github.com/henryla/mbox2zimbra

3. Get into this directory

        cd mbox2zimbra

4. Upload google's mbox file into this directory. We assume the file name is 'gmail_mbox'
5. Split mbox

        ./split_mbox.sh gmail_mbox

6. It might take time to finish the splitting.
7. After finishing splitting, you may see lots of directories named 'mailxxxx', where xxxx is 4 digits number.

        ls -l

8. Import into Zimbra Email System

        ./import_mbox.sh ./ <your email address> <path of your mbox folder>
        # Example: your email address test@gmail.com and your mbox folder is /Inbox/gmail
        ./import_mbox.sh ./ test@gmail.com Inbox/gmail

9. It will take very long time if you have very large mbox from Google Mail. It's recommanded to do this in background

        ./import_mbox.sh ./ test@gmail.com Inbox/gmail 2>&1 > import_mbox.log &

10. You can use 'ps' to check if above background command is finished.

        ps -ef | grep import_mbox.sh

11. Or you may check log file 'import_mbox.log'. If 'Import finished' occured, the import is finished.

        tail -f import_mbox.log
