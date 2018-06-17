FROM centos:centos7.5.1804

RUN yum install -y epel-release

RUN yum install -y clamav-server \
  clamav-data \
  clamav-update \
  clamav-filesystem \
  clamav \
  clamav-scanner-systemd \
  clamav-devel \
  clamav-lib \
  clamav-server-systemd

# 1. Remove example line.
# 2. Remove user so it runs as root.
# 3. Set port number.
# 4. Turn on logging.
# 5. Display time in log messages.
# 6. Run in foreground so container does not stop.
RUN cp /usr/share/clamav/template/clamd.conf /etc/clamd.conf \
 && sed -i '/^Example/d' /etc/clamd.conf \
 && sed -i '/^User/d' /etc/clamd.conf \
 && sed -i 's/^#TCPSocket 3310/TCPSocket 3310/' /etc/clamd.conf \
 && sed -i 's/^#LogFile .*$/LogFile \/tmp\/clamd.log/' /etc/clamd.conf \
 && sed -i 's/^#LogTime/LogTime/' /etc/clamd.conf \
 && sed -i 's/^#LogVerbose yes/LogVerbose yes/' /etc/clamd.conf \
 && sed -i 's/^#StreamMaxLength 10M/StreamMaxLength 50M/' /etc/clamd.conf \
 && sed -i 's/^#Foreground yes$/Foreground yes/g' /etc/clamd.conf

RUN yum list clamav \
 && yum update clamav

RUN freshclam

EXPOSE 3310

# av daemon bootstrapping
ADD bootstrap.sh /
CMD ["/bootstrap.sh"]
