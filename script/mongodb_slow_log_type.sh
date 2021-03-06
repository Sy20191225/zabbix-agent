#!/bin/bash
#usage:
#sh mongodb_slow_log_type.sh DATABASE COMMAND|WRITE PORT
#参数1:数据库名称，yotta metabase
#参数2:日志信息所属分类，COMMAND WRITE
#参数3:日志信息类型，{#COMMAND_NAME} {#WRITE_NAME}
#参数4:MongoDB服务端口，默认27017

source /srv/zabbix-agent/script/fun_check_stat_file.sh

DATABASE="$1"
METRIC="$2"
TYPE="$3"
PORT="${4:-27017}"

STAT_FILE="/srv/zabbix-agent/var/mongodblog${PORT}.stats"

CHECK_STAT_FILE_FLAG=`fun_check_stat_file ${STAT_FILE} 300`;

if [ ${CHECK_STAT_FILE_FLAG} -ne 1 ] ;then
    exit;
fi;


command_num() {
    COMMANDNUM=$(grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|awk -vtype="command" -vtypes="${TYPE}" '$5==type && $8==types'|awk -F '[. ]' -vdataname="${DATABASE}" '$8==dataname'|wc -l)
    echo ${COMMANDNUM}
}

write_num() {
    WRITENUM=$(grep ${METRIC} ${STAT_FILE}|grep -v "MongoDB Shell"|awk -F '[. ]' -vdataname="${DATABASE}" '$10==dataname'|awk -vtype="${TYPE}" '$5==type'|wc -l)
    echo ${WRITENUM}
}


case ${METRIC} in
    COMMAND)
        command_num
    ;;

    WRITE)
        write_num
    ;;

    *)
    exit 1
esac
