#!/bin/sh

mkdir -p /etc/nipap/
envtpl --allow-missing --keep-template /usr/local/share/nipap/nipap.conf.dist -o /etc/nipap/nipap.conf
/bin/bash /nipap/wait-for-it.sh -t 60 $DB_HOST:$DB_PORT -- sleep 5

/usr/local/bin/nipap-passwd create-database
if [ -n "$NIPAP_USERNAME" -a -n "$NIPAP_PASSWORD" ]; then
	echo "Creating user '$NIPAP_USERNAME'"
	/usr/local/bin/nipap-passwd add --username $NIPAP_USERNAME --name "NIPAP user" --password $NIPAP_PASSWORD
fi
echo "Starting nipap daemon.."
exec /usr/local/bin/nipapd --debug --foreground --auto-install-db --auto-upgrade-db --no-pid-file
