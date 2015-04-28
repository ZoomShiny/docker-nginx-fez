FROM uqlibrary/docker-nginx:latest


RUN yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN yum install -y http://dl.atrpms.net/all/atrpms-repo-7-7.el7.x86_64.rpm
RUN rpm --import http://packages.atrpms.net/RPM-GPG-KEY.atrpms

RUN \
  yum install --enablerepo=epel-testing -y perl-Image-ExifTool && \
  yum install -y \
    ImageMagick \
    poppler-utils \
    ffmpeg \
    graphviz

RUN wget -O /usr/local/src/jhove.tar.gz http://downloads.sourceforge.net/project/jhove/jhove/JHOVE%201.11/jhove-1_11.tar.gz
RUN wget -O /usr/local/src/yamdi.tar.gz http://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz
RUN cd /usr/local/src && tar xvzf yamdi.tar.gz
RUN cd /usr/local/src && tar xvzf jhove.tar.gz

RUN yum group install -y "Development Tools"

# Compile yamdi, move it, chmod it, clean up
RUN cd /usr/local/src/yamdi-1.9 && gcc yamdi.c -o yamdi -O2 -Wall && mv yamdi /usr/bin/yamdi && chmod +x /usr/bin/yamdi && cd .. && rm -rf yamdi-1.9 && rm -f yamdi.tar.gz

#Install Java for Jhove
RUN yum install -y java-1.8.0-openjdk-headless
RUN mv /usr/local/src/jhove /usr/local/jhove && rm -f /usr/local/src/jhove.tar.gz

RUN yum group remove -y "Development Tools"
RUN yum clean all

COPY jhove /usr/local/jhove/
RUN chmod +x /usr/local/jhove/jhove

EXPOSE 80 81