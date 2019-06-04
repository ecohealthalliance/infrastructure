FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN mkdir /root/.ssh/
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCflM2SNW9LntS6lnR/YgtDX4echsa1TScfzEacbC8yKDtXWuFVl/y74oFMRWyU8Cye/1L4dJHe2mw/pMIfxs80dWphF8Lo+L3HRNvfeGQr4sbf7DE/QdOPkU4EUYtOtxh+DnOjU2d7iPTRii7iVzGcq384JPo97ilceu4Nid+JQ4MYVu4csR8GhcXW9ztUi2O9FMIvee6H+khIwgmwZxifgttrDeUo23cXRUik8tP2bzpGjMkBzanQOX+4W2pdazW7teN6gGmVi4WVw2mPJm51aTys2PWz15fJAcBeEyBtIngVWnD3MAJzDLW39T+piI3TskrPyarnwpEGSuX4JnYF jenkins@kirby" >> /root/.ssh/authorized_keys
RUN chmod 0700 /root/.ssh
RUN chmod 0600 /root/.ssh/authorized_keys

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

# Change host key directory so it can be mounted as a persistent volume
RUN sed -i -E 's@^HostKey \/etc\/ssh\/(.+)$@HostKey \/etc\/ssh\/host_keys\/\1@g' /etc/ssh/sshd_config
RUN mkdir /etc/ssh/host_keys/
RUN cp /etc/ssh/ssh_host_* /etc/ssh/host_keys/

CMD ["/usr/sbin/sshd", "-D"]
