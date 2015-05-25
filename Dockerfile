FROM uqlibrary/docker-nginx:latest


RUN yum install -y http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm && \
  yum install -y http://dl.atrpms.net/all/atrpms-repo-7-7.el7.x86_64.rpm && \
  rpm --import http://packages.atrpms.net/RPM-GPG-KEY.atrpms && \
  yum install --enablerepo=epel-testing -y perl-Image-ExifTool && \
  yum install -y \
    ImageMagick \
    poppler-utils \
    ffmpeg && \
  wget -O /usr/local/src/jhove.tar.gz http://downloads.sourceforge.net/project/jhove/jhove/JHOVE%201.11/jhove-1_11.tar.gz && \
  wget -O /usr/local/src/yamdi.tar.gz http://downloads.sourceforge.net/project/yamdi/yamdi/1.9/yamdi-1.9.tar.gz && \
  wget -O /usr/local/src/graphviz.tar.gz http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz && \
  cd /usr/local/src && tar xvzf yamdi.tar.gz && \
  cd /usr/local/src && tar xvzf jhove.tar.gz && \
  cd /usr/local/src && tar xvzf graphviz.tar.gz && \
  yum group install -y "Development Tools" && \
  cd /usr/local/src/yamdi-1.9 && gcc yamdi.c -o yamdi -O2 -Wall && mv yamdi /usr/bin/yamdi && chmod +x /usr/bin/yamdi && cd .. && rm -rf yamdi-1.9 && rm -f yamdi.tar.gz && \
  yum install -y cairo-devel expat-devel freetype-devel gd-devel fontconfig-devel glib libpng zlib pango-devel pango && \
  cd /usr/local/src/graphviz-2.38.0 && ./configure && make && make install && ln -s /usr/local/bin/dot /usr/bin/dot && \
  yum install -y java-1.8.0-openjdk-headless && \
  mv /usr/local/src/jhove /usr/local/jhove && rm -f /usr/local/src/jhove.tar.gz && \
  yum group remove -y "Development Tools" && \
  yum autoremove -y && yum clean all

COPY jhove /usr/local/jhove/
RUN chmod +x /usr/local/jhove/jhove

EXPOSE 80 81