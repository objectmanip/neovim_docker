FROM debian:bullseye

COPY ./.env /usr/src/app/.env

RUN . /usr/src/app/.env && \
    export USERNAME=$(echo $USERNAME | tr -d '\n\r' | xargs) && \
    export PASSWORD=$(echo $PASSWORD | tr -d '\n\r' | xargs) && \
    echo "USERNAME is: $USERNAME" && \
    useradd -m -s /bin/bash $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    adduser $USERNAME sudo

# Update the package list and install openssh-server
RUN apt-get update && \
    apt-get install -y --fix-missing wget curl npm cmake openssh-server git build-essential

RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz && \
    rm -rf /opt/nvim && \
    tar -C /opt -xzf nvim-linux64.tar.gz && \
    chmod +x /opt/nvim-linux64/bin/nvim && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim

RUN ssh-keygen -A

RUN mkdir /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    echo 'UsePAM no' >> /etc/ssh/sshd_config

# Create the necessary directories for Neovim configuration and data
RUN mkdir -p /home/$USERNAME/.config/nvim /home/$USERNAME/.local/share/nvim

COPY ./nvim /home/objectmanip/.config/nvim

RUN chown $USERNAME:$USERNAME -R /home/$USERNAME/.config/nvim && \
#    chown $USERNAME:$USERNAME -R /home/$USERNAME/.local/share/nvim && \
    chmod -R 777 /home/$USERNAME/.config/nvim && \
#    chmod -R 777 /home/$USERNAME/.local/share/nvim && \
    git config --global --add safe.directory '*'


ENV PATH="/opt/nvim-linux64/bin:${PATH}"

EXPOSE 22

# Keep the container running
CMD ["/usr/sbin/sshd", "-D"]
