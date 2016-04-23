FROM vercapi/oracle_minion

# Install Oracle database install basic dependencies
RUN yum -y upgrade && yum -y install yum-utils wget.x86_64 bzip2.x86_64 kernel-uek-devel-3.8.13-98.1.2.el7uek.x86_64 unzip make

# Create the oracle user and groups
RUN groupadd oinstall
RUN useradd -m -g oinstall -G oinstall,wheel oracle

# All DB dependecies as described in the documentation
RUN yum -y upgrade && yum -y install libaio glibc compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libgcc libstdc++ libstdc++-devel unixODBC unixODBC-devel mksh

# Provide install files
RUN mkdir -p /home/oracle/stage
COPY linuxamd64_12102_database_1of2.zip /home/oracle/stage
COPY linuxamd64_12102_database_2of2.zip /home/oracle/stage

WORKDIR /home/oracle/stage

# Ensure oracle user can has its time
RUN chown -R oracle /home/oracle/

# Prepare the install destination
RUN mkdir /opt/oracle && chown -R oracle:oinstall /opt/oracle

USER oracle
# Inventory location
RUN mkdir /opt/oracle/oraInventory

RUN unzip linuxamd64_12102_database_1of2.zip && unzip linuxamd64_12102_database_2of2.zip
RUN rm linuxamd64_12102_database_1of2.zip && rm linuxamd64_12102_database_2of2.zip

# Copy the response file
USER root
COPY db.rsp /home/oracle/
RUN chown oracle:oinstall /home/oracle/db.rsp

USER oracle

# Run the installer in the installer directory
WORKDIR /home/oracle/stage/database
RUN ./runInstaller -ignoreSysPrereqs -ignorePrereq -waitforcompletion -silent -responseFile /home/oracle/db.rsp

# Run the post install scripts as root
USER root
RUN /opt/oracle/oraInventory/orainstRoot.sh
RUN /opt/oracle/app/product/12.1.0/dbhome/root.sh

# Provide creation and startup scritps
COPY create_db.sh /home/oracle/
COPY db_install.dbt /home/oracle/
RUN chown -R oracle:oinstall /home/oracle/

USER oracle

RUN sh /home/oracle/create_db.sh

EXPOSE 1521
