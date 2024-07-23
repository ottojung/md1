#! /bin/sh

ID="$MIYKA_FETCHER_ARG_ID"
NAME="$MIYKA_FETCHER_ARG_NAME"
DEST="$MIYKA_FETCHER_ARG_DESTINATION"

if test -z "$ID"
then
	echo "Expected MIYKA_FETCHER_ARG_ID environment variable to be set." 1>&2
	exit 1
fi

if ! test -z "$NAME"
then
	echo "Did not expect MIYKA_FETCHER_ARG_NAME environment variable to be set." 1>&2
	exit 1
fi

if test -z "$DEST"
then
	echo "Expected MIYKA_FETCHER_ARG_DESTINATION environment variable." 1>&2
	exit 1
fi

if test -z "$MD1_CONFIGURATION"
then
	MD1_CONFIGURATION="$HOME/.config/miyka/md1.csv"
fi

if ! test -f "$MD1_CONFIGURATION"
then
	echo "ERROR: Configuration file at '$MD1_CONFIGURATION' does not exist." 1>&2
	exit 1
fi

if test $(cat -- "$MD1_CONFIGURATION" | wc -l) = 0
then
	echo "ERROR: no downloaders defined in '$MD1_CONFIGURATION'." 1>&2
	exit 1
fi

cat -- "$MD1_CONFIGURATION" | while IFS= read LINE
do
	SCRIPT="$(echo "$LINE" | awk -F ',' '{ print $1 }')"
	case "$SCRIPT" in
		/*)
			SCRIPT_FULLPATH="$SCRIPT"
			;;
		*)
			SCRIPT_FULLPATH="${MD1_CONFIGURATION%/*}/$SCRIPT"
			;;
	esac

	if ! test -f "$SCRIPT_FULLPATH"
	then
		echo "WARN: Download script at '$SCRIPT_FULLPATH' does not exist." 1>&2
		continue
	fi

	if "$SCRIPT_FULLPATH" "$ID" "$DEST"
	then
		exit 0
	else
		echo "WARN: Failed to fetch with '$SCRIPT_FULLPATH'." 1>&2
		rm -rf -- "$DEST"
		continue
	fi
done

if ! test -d "$DEST"
then
	echo "ERROR: Failed to fetch with any available scripts." 1>&2
	exit 1
fi
