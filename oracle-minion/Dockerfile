FROM oraclelinux:7.2

# Dependencies for saltstack
RUN rpm --import https://repo.saltstack.com/yum/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub
ADD ./saltstack.repo /etc/yum.repos.d/saltstack.repo
#RUN yum clean expire-cache
RUN yum -y update && yum -y install salt-minion

VOLUME ['/etc/salt/minion.d', '/etc/salt/pki/']

COPY minion /etc/salt/minion

CMD /usr/bin/salt-minion
