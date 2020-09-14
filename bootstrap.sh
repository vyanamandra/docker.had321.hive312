#!/bin/bash

#Script /etc/runOnce.sh will run only once. 
# After that it would be removed from this script.
#  Note: This is only for precaution if someone executes this script manually
/etc/runOnce.sh

/usr/sbin/sshd 

## replace config
: ${EXTRA_CONF_DIR:=/config/hive}

if [ -d "$EXTRA_CONF_DIR" ]; then
	cp $EXTRA_CONF_DIR/* /usr/local/hive/conf
fi

/etc/hadoop_bootstrap.sh
/etc/hive_bootstrap.sh


if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
