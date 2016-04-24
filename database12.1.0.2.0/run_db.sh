export ORACLE_HOME=/opt/oracle/app/product/12.1.0/dbhome
export ORACLE_SID=orcl
PERSISTENT_DATA=/opt/oracle/oraInventory

start_database() {
	$ORACLE_HOME/bin/sqlplus / as sysdba << EOF
	startup
	exit
EOF
}

start_listener() {
    $ORACLE_HOME/bin/lsnrctl start
}

start_listener
start_database


 x#tail -f /u01/app/oracle/diag/rdbms/$(hostname)/*/trace/alert_$(hostname).log &
#tail -f /dev/null
wait
