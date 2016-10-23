
p_oracle_sid=$(cat <<'BABEL_TABLE'
orcl
BABEL_TABLE
)
p_template_file=$(cat <<'BABEL_TABLE'
db_install.dbt
BABEL_TABLE
)
# File locations
LSNR_LOC=$ORACLE_HOME/network/admin/listener.ora
DBCA_RSP_LOC=/home/oracle/config/dbca.rsp

# Actually configure the install file with the parameters
sed -i "s/{{ORACLE_SID}}/orcl/" $DBCA_RSP_LOC
sed -i "s/{{ORACLE_PWD}}/Welcome1/" $DBCA_RSP_LOC
sed -i "s/{{ORACLE_PDB}}/ORAPDB1/" $DBCA_RSP_LOC

# Install listener
mv /home/oracle/config/listener.ora $LSNR_LOC

# Configure the listener with the actual hostname (name of the container)
sed -i "s/{{hostname}}/$(hostname)/" $LSNR_LOC

# Start listener for dbca
echo "- Starting listener- "
lsnrctl start

# Run DBCA, output log on failure
echo "- Starting dbca -"
dbca -silent -createdatabase -responseFile $DBCA_RSP_LOC ||
  cat /opt/oracle/app/cfgtoollogs/dbca/${ORACLE_SID,,}/${$ORACLE_SID}.log
echo "- End dbca -"
