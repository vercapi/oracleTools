
p_oracle_sid=$(cat <<'BABEL_TABLE'
orcl
BABEL_TABLE
)
p_oracle_home=$(cat <<'BABEL_TABLE'
/opt/oracle/app/product/12.1.0/dbhome
BABEL_TABLE
)
p_persistent_data=$(cat <<'BABEL_TABLE'
/opt/oracle/oraInventory
BABEL_TABLE
)
p_oracle_base=$(cat <<'BABEL_TABLE'
/opt/oracle/app
BABEL_TABLE
)
#rm db_install.dbt && cp db_install.dbt.orig db_install.dbt
rm run_db.sh && cp run_db.sh.orig run_db.sh

sed -i "s/{{ db_create_file_dest }}/\/opt\/oracle\/oraInventory\/$p_oracle_sid/" ./db_install.dbt
sed -i "s/{{ oracle_base }}/\/opt\/oracle\/app/" ./db_install.dbt
sed -i "s/{{ database_name }}/$p_oracle_sid/" ./db_install.dbt

sed -i "s/{{oracle_home}}/$(echo $p_oracle_home | sed 's,/,\\/,g')/" ./run_db.sh
sed -i "s/{{oracle_sid}}/$p_oracle_sid/" ./run_db.sh
sed -i "s/{{oracle_base}}/$(echo $p_oracle_base | sed 's,/,\\/,g')/" ./run_db.sh

docker build --build-arg ORACLE_HOME=$p_oracle_home --build-arg ORACLE_SID=$p_oracle_sid --build-arg ORACLE_BASE=$p_oracle_base -t vercapi/orcl_121 .
