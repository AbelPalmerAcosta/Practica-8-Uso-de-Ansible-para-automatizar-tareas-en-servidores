
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar SSH, Sudo y Python
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio necesario para SSH
RUN mkdir -p /var/run/sshd

# Crear usuario ansible y establecer contraseña
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

# Dar permisos sudo sin contraseña
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" \
    > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Permitir autenticación SSH mediante contraseña
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config && \
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' \
    /etc/ssh/sshd_config

EXPOSE 22

# Generar claves SSH e iniciar el servidor
CMD ["/bin/bash", "-c", "ssh-keygen -A && exec /usr/sbin/sshd -D"]
