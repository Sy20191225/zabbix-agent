#!/bin/bash
#监控 SERVER 进程

PRONAME=$1
PRONUM=$(ps -ef|grep "$PRONAME"|egrep -v 'grep|zabbix'|wc -l)

if [ ${PRONUM} -eq 0 ]; then
    echo 0
else
    echo 1
fi
