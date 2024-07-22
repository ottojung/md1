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

CONFIGURATION="$HOME/.config/miyka/md1.csv"

if ! test -f "$CONFIGURATION"
then
	echo "ERROR: Configuration file at '$CONFIGURATION' does not exist." 1>&2
	exit 1
fi

cat -- "$CONFIGURATION" | while IFS= read LINE
do
	SCRIPT="$(echo "$LINE" | awk -F ',' '{ print $1 }')"
	if "$SCRIPT" "$ID" "$DEST"
	then
		exit 0
	else
		echo "WARN: Failed to fetch with '$SCRIPT'." 1>&2
		continue
	fi
done

echo "ERROR: Failed to fetch with any available scripts." 1>&2
exit 1
