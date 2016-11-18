
#!/bin/bash
# Simply run the database
function runDB() {
    echo 'Starting DB'
    lsnrctl start
    sqlplus / as sysdba <<EOF
    startup;
EOF

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

while [[ $# -ge 1 ]]
do
    key="$1"

    case $key in
        --create)
            if [ "`checkDBExists`" == "0" ]; then
                /home/oracle/scripts/create_db.sh
            else
                echo "DB already exists"
            fi;
            shift
            ;;
        --run)
            if [ "`checkDBExists`" == "1" ]; then
                runDB "$@"
            else
                echo "No DB exists already"
            fi;
            shift
            ;;
        *)
            explain
            ;;
    esac
    shift
done
