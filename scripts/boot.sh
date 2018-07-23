#!/bin/bash
set -e
# Apache gets grumpy about PID files pre-existing
rm -f /run/apache2.pid
rm -f /run/apache2/apache2.pid
rm -f /var/run/apache2/apache2.pid
file="/var/www/project-init.bash"
if [ -f "$file" ]
then
	if [[ $INIT != 1 ]]; then
		sleep 21
		cd /var/www/
		bash /var/www/project-init.bash
	fi
else
	echo "$file not found."
fi
export INIT=1
exec apache2 -DFOREGROUND