####################################
# Software only install Oracle 12c #
####################################

FROM vercapi/oracle_minion

# Oracle environment variables
ENV ORACLE_BASE=/opt/oracle/app \
    ORACLE_HOME=/opt/oracle/app/product/12.1.0/dbhome \
    ORACLE_SID=ORCL \
    ORACLE_PDB=ORCLPDB1


# System environment variables
ENV PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

# Preparing destionatino directories
RUN mkdir -p /opt/oracle && \
    mkdir -p /opt/oracle/oraInventory && \
    mkdir -p /home/oracle/stage && \
    mkdir -p /home/oracle/config && \
    mkdir -p /home/oracle/scripts

# Supply Installation files
COPY linuxamd64_12102_database_1of2.zip /home/oracle/stage
COPY linuxamd64_12102_database_2of2.zip /home/oracle/stage


# Install Oracle database install basic dependencies and oracle DB dependecies
#RUN yum -y upgrade && yum -y install yum-utils wget.x86_64 bzip2.x86_64 \
#    kernel-uek-devel-3.8.13-98.1.2.el7uek.x86_64 unzip make sudo \
#    libaio glibc compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel \
#    libgcc libstdc++ libstdc++-devel unixODBC unixODBC-devel mksh
RUN yum -y install oracle-rdbms-server-12cR1-preinstall unzip wget tar openssl sudo && \
    yum clean all

# Create the oracle user and groups and ensure we don't require a tty to run sudo (for saltstack)
#RUN groupadd oinstall
RUN usermod -G wheel,oinstall oracle
RUN echo 'oracle ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \ 
    sed -i.bak '/Defaults    requiretty/d' /etc/sudoers && \
    sed -i.bak '/Defaults   !visiblepw/d' /etc/sudoers

# Install response file
COPY db.rsp /home/oracle/config/

# Fix rights for the oracle user
RUN chown -R oracle:oinstall /home/oracle/ && \
    chown -R oracle:oinstall /opt/oracle/oraInventory && \
    chown -R oracle:oinstall /opt/oracle

# Start the software only install
WORKDIR /home/oracle/stage
USER oracle
RUN unzip linuxamd64_12102_database_1of2.zip
RUN unzip linuxamd64_12102_database_2of2.zip
RUN rm linuxamd64_12102_database_1of2.zip && rm linuxamd64_12102_database_2of2.zip
WORKDIR /home/oracle/stage/database
RUN ./runInstaller -ignoreSysPrereqs -ignorePrereq -waitforcompletion -silent -force -responseFile /home/oracle/config/db.rsp
RUN rm -rf /home/oracle/stage/database
USER root
RUN /opt/oracle/oraInventory/orainstRoot.sh
RUN /opt/oracle/app/product/12.1.0/dbhome/root.sh

USER oracle

# Files we use after software only installation
# Config for listener
COPY listener.ora /home/oracle/config
# dbca script
COPY create_db.sh /home/oracle/scripts
# Startup script
COPY run.sh /home/oracle/scripts
# DBCA response file
COPY dbca.rsp /home/oracle/config

#Change permissions for the  DBCA and run scripts
USER root
RUN chown -R oracle:oinstall /home/oracle/scripts/
RUN chmod u+x /home/oracle/scripts/*.sh
USER oracle

# For DB and enterprise manager
EXPOSE 1521 5500

CMD /home/oracle/scripts/run.sh
