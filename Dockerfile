FROM centos:7.2.1511

RUN yum -y install epel-release
RUN yum -y install python-pip java-1.8.0-openjdk-devel wget

RUN pip install awscli

RUN wget -q -P / http://mirror.dkd.de/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && mkdir /maven/ && tar xzvf /apache-maven-3.3.9-bin.tar.gz -C /maven/ --strip-components=1

ENV MAVEN_HOME=/maven
ENV PATH=/maven/bin/:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

RUN groupadd -g 497 jenkins
RUN adduser -u 498 -g 497 -s /bin/false -d /var/lib/jenkins -c 'Jenkins Continuous Integration Server' jenkins
USER jenkins

