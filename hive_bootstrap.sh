#!/bin/bash

## replace config
: ${EXTRA_CONF_DIR:=/config/hive}

if [ -d "$EXTRA_CONF_DIR" ]; then
	cp $EXTRA_CONF_DIR/* /usr/local/hive/conf
fi

# Start HMS
hive --hiveconf hive.log.dir=/logs/hive/hms --service metastore  &

# Start HS2
hive --hiveconf hive.log.dir=/logs/hive/hs2 --service hiveserver2  &

