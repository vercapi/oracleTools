export ORACLE_HOME=/opt/oracle/app/product/12.1.0/dbhome
export ORACLE_SID=orcl
PERSISTENT_DATA=/opt/oracle/oraInventory

create_pfile() {
	$ORACLE_HOME/bin/sqlplus -S / as sysdba << EOF
	set echo off pages 0 lines 200 feed off head off sqlblanklines off trimspool on trimout on
	spool $PERSISTENT_DATA/init_$(hostname).ora
	select 'spfile="'||value||'"' from v\$parameter where name = 'spfile';
	spool off
	exit
EOF
}


prepare_template() {
    sed -i "s/{{ db_create_file_dest }}/\/opt\/oracle\/oraInventory\/$ORACLE_SID/" /home/oracle/db_install.dbt
    sed -i "s/{{ oracle_base }}/\/opt\/oracle\/app/" /home/oracle/db_install.dbt
    sed -i "s/{{ database_name }}/$ORACLE_SID/" /home/oracle/db_install.dbt
}

create_database() {
    prepare_template
    
    # Actually create db
    $ORACLE_HOME/bin/dbca -silent -createdatabase -templatename /home/oracle/db_install.dbt -gdbname $ORACLE_SID -sid $ORACLE_SID -syspassword oracle -systempassword oracle -dbsnmppassword oracle

    create_pfile
}

create_database
