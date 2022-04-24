#!/bin/bash

ZMMAILBOX="zmmailbox"

if [ "$1" == "" ] && [ "$2" == "" ] && [ "$3" == "" ] ; then

	echo ""
	echo "Usage: $0 <root directory for all mbox> <email address> <mailbox name>"
	echo ""
	echo "Example: $0 ./google_mbox test@test.com gmail"
	echo ""

else

	echo "Will searching all .mbox files under '$1' and"
	echo "import to mailbox '$3' of email '$2'"
	echo -n "Continue (y/N): "
	read YN
	if [ "$YN" == "Y" ] || [ "$YN" == "y" ]; then
		find $1 -name mail* -exec echo Import from {} \; -exec ${ZMMAILBOX} -t 0 -z -m $2 addMessage --noValidation /$3 {} \;
		MYERR=$?
		echo "Import finished (${MYERR})"
	else
		echo "Import finished (Nothing imported)"
	fi
fi

