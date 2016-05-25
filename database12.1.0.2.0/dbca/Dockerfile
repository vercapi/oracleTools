####################################
# Database creation for Oracle 12c #
####################################

FROM vercapi/oracle_software121

ARG ORACLE_HOME
ARG ORACLE_SID
ARG ORACLE_BASE

USER root
COPY db_install.dbt /home/oracle
RUN chown oracle:oinstall /home/oracle/db_install.dbt

USER oracle
# Run the dbca script
RUN $ORACLE_HOME/bin/dbca -silent -createdatabase -templatename /home/oracle/db_install.dbt -gdbname $ORACLE_SID -sid $ORACLE_SID -syspassword oracle -systempassword oracle -dbsnmppassword oracle

# Provide listener config
USER root
COPY listener.ora $ORACLE_HOME/network/admin/
RUN chown oracle:oinstall $ORACLE_HOME/network/admin/listener.ora

# Provide the script for starting the DB
COPY run_db.sh /home/oracle/
RUN chown oracle:oinstall /home/oracle/run_db.sh

USER oracle

RUN export ORACLE_HOME
RUN export ORACLE_SID

EXPOSE 1521

CMD sh /home/oracle/run_db.sh
