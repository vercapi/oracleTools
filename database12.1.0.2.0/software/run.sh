
# Simply run the database
function runDB {
    lsnrctl start
    sqlplus / as sysdba <<EOF
    startup;
EOF

}

function checkDBExists {
   # No entry in oratab, DB doesn't exist yet
   if [ "`grep $ORACLE_SID /etc/oratab`" == "" ]; then
      echo 0;
   else
      echo 1;
   fi;
}

# We always want to start the minion
sudo salt-minion

while [[ $# -gt 1 ]]
do
    key="$1"

    case $key in
        --create)
            if [ "`checkDBExists`" == "0" ]; then
                ./createDB.sh
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
            help
            ;;
    esac
done
