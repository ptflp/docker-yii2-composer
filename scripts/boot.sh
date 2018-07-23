#!/bin/bash
set -e
# Apache gets grumpy about PID files pre-existing
rm -f /run/apache2.pid
rm -f /run/apache2/apache2.pid
rm -f /var/run/apache2/apache2.pid
pinit="/var/www/project-init.bash"
file="/var/www/vendor/autoload.php"
if [ -f "$file" ]
then
	echo "project installed"
else
	if [ -f "$pinit" ]; then
		sleep 21
		cd /var/www/
		dos2unix $pinit
		chmod +x $pinit
		bash $pinit
	fi
fi
exec apache2 -DFOREGROUND