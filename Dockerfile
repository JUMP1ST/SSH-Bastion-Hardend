FROM ubuntu:20.04

# Suppress interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server libpam-ldapd nscd rsyslog auditd ca-certificates && \
    mkdir /var/run/sshd && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    update-ca-certificates

# Copy necessary configuration files
COPY ldap.conf /etc/ldap/ldap.conf
COPY nslcd.conf /etc/nslcd.conf
COPY nsswitch.conf /etc/nsswitch.conf
COPY rsyslog.conf /etc/rsyslog.conf
COPY pam.d/sshd /etc/pam.d/sshd

# Expose SSH port
EXPOSE 22

# Run services with SSH on-demand
CMD ["bash", "-c", "service rsyslog start && service nscd start && /usr/sbin/sshd -D"]
