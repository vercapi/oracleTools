FROM vercapi/oracle_minion

# Install Oracle database install basic dependencies
RUN yum -y upgrade && yum -y install yum-utils wget.x86_64 bzip2.x86_64 kernel-uek-devel-3.8.13-98.1.2.el7uek.x86_64

# Create the oracle user
RUN useradd -ms /bin/bash oracle

# All DB dependecies as described in the documentation
RUN yum -y upgrade && yum -y install libaio glibc compat-libstdc++-33 elfutils-libelf-devel gcc-c++ libaio-devel libgcc libstdc++ libstdc++-devel unixODBC unixODBC-devel mksh

USER oracle

# Provide install files
RUN mkdir -p /home/oracle/stage
COPY linuxamd64_12102_database_1of2.zip /home/oracle/stage
COPY linuxamd64_12102_database_2of2.zip /home/oracle/stage
RUN unzip linuxamd64_12102_database_1of2.zip && unzip linuxamd64_12102_database_2of2.zip

# Copy the response file
COPY db.rps /home/oracle/

# Run the installer in the installer directory
WORKDIR /home/oracle/stage
RUN ./runInstaller -ignorePrereq -silent -responseFile /home/oracle/db.rsp

# Run the post install scripts as root
USER root
RUN /opt/oracle/app/oraInventory/orainstRoot.sh:
RUN /opt/oracle/app/oracle/product/11.2.0/dbhome_1/root.sh
