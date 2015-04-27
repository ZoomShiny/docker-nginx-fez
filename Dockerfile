FROM uqlibrary/docker-nginx:latest


RUN yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm


RUN \
  yum install --enablerepo=epel-testing -y perl-Image-ExifTool && \
  yum install -y \
    ImageMagick \
    poppler-utils \
    graphviz && \
  yum clean all

EXPOSE 80 81