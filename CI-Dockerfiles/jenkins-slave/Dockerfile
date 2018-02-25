FROM centos:centos7
MAINTAINER jtoledog <jptgjuanpablo@gmail.com>

RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
ADD ./start.sh /start.sh
RUN mkdir /var/run/sshd

RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' 

RUN chmod 755 /start.sh
EXPOSE 22
RUN ./start.sh

# Maven Install
RUN yum install -y maven git
ADD settings.xml /usr/share/maven/conf/

# Java Install
RUN yum install -y java-1.8.0-openjdk-devel
#RUN echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile

ENTRYPOINT ["/usr/sbin/sshd", "-D"]