# Verwenden Sie das Debian-Image als Basis
FROM mcr.microsoft.com/devcontainers/base:bookworm

# Setzen Sie Build-Argumente
ARG SSH_USER
ARG SSH_PASSWORD

# Setzen Sie Umgebungsvariablen
ENV SSH_USER=${SSH_USER}
ENV SSH_PASSWORD=${SSH_PASSWORD}

# Installieren Sie Git
RUN apt-get update \
    && apt-get install -y git

# Installieren Sie Abhängigkeiten für den Bau von Python
RUN apt-get update \
    && apt-get install -y wget build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev tk-dev

# Python 3.9 von der Quelle herunterladen und installieren
RUN wget https://www.python.org/ftp/python/3.9.0/Python-3.9.0.tgz \
    && tar xzf Python-3.9.0.tgz \
    && cd Python-3.9.0 \
    && ./configure --enable-optimizations \
    && make altinstall

# Installieren Sie pip und wheel
RUN python3.9 -m ensurepip \
    && python3.9 -m pip install --upgrade pip \
    && python3.9 -m pip install wheel

# Installieren Sie den OpenSSH-Server
RUN apt-get update \
    && apt-get install -y openssh-server

# Erstellen Sie das Verzeichnis für den SSH-Daemon
RUN mkdir /var/run/sshd

# Generieren Sie SSH-Host-Schlüssel
RUN ssh-keygen -A

# Debugging: Zeigen Sie die generierten SSH-Schlüssel an

RUN ls -l /etc/ssh/ssh_host_*



# Setzen Sie die Shell auf bash
SHELL ["/bin/bash", "-c"]

# Setzen Sie das Arbeitsverzeichnis
WORKDIR /home/vscode

# Erstellen Sie den Benutzer und setzen Sie das Passwort
RUN echo '$SSH_USER:$SSH_PASSWORD' | envsubst | chpasswd
#RUN useradd -m -s /bin/bash $SSH_USER && echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
# Erlauben Sie root-Login über SSH
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Debugging: Zeigen Sie die SSH-Konfigurationsdatei an

RUN cat /etc/ssh/sshd_config


# Expose the SSH port
EXPOSE 22

# Starten Sie den SSH-Daemon und halten Sie den Container aktiv
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/bin/bash", "-c", "ls -l /etc/ssh/ssh_host_* && /usr/sbin/sshd -D"]


# Setzen Sie den Benutzer (entfernen oder kommentieren Sie diese Zeile, um als root zu arbeiten)
#USER vscode
