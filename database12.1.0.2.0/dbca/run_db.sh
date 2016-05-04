ORACLE_HOME=/opt/oracle/app/product/12.1.0/dbhome
ORACLE_BASE=/opt/oracle/app
ORACLE_SID=orcl

export ORACLE_HOME ORACLE_SID

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


tail -f $ORACLE_BASE/diag/rdbms/$ORACLE_SID/*/trace/alert_$ORACLE_SID.log
wait
