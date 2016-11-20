
#!/bin/bash
# Simply run the database
function runDB() {
    echo 'Starting DB'
    lsnrctl start
    sqlplus / as sysdba <<EOF
    startup;
EOF

    tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
    childPID=$!
    wait $childPID

}

function checkDBExists() {
   # No entry in oratab, DB doesn't exist yet
   if [ "`grep $ORACLE_SID /etc/oratab`" == "" ]; then
      echo 0;
   else
      echo 1;
   fi;
}

function explain() {
    echo "use --run or --create"
}

# We always want to start the minion
#sudo salt-minion &

echo "Running script"
# Create database on first run, otherwise run it
if [ "`checkDBExists`" == "0" ]; then
    echo "building database"
    /home/oracle/scripts/create_db.sh
else
    echo "DB already exists, starting"
    runDB "$@"
fi;
