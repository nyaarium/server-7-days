FROM debian:bookworm


# Adjust the game version here
# ENV GAME_VERSION="xxx"


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
ENV LANGUAGE=en_US:en
ENV LC_ALL=C

RUN apt update && apt install -y \
	software-properties-common \
	&& apt autoremove --purge -y && apt clean

RUN apt update && apt install -y \
	ca-certificates \
	curl \
	gnupg \
	screen \
	wget \
	&& apt autoremove --purge -y && apt clean

RUN NODE_MAJOR=22 \
	&& curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
	&& echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
	&& apt update \
	&& apt install -y nodejs \
	&& apt clean && rm -rf /var/lib/apt/lists/*


############################
# App dependencies

RUN cd /usr/local/bin/ \
	&& apt update && apt install -y \
	lib32gcc-s1 \
	&& apt autoremove --purge -y && apt clean \
	&& wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
	&& tar -xvzf steamcmd_linux.tar.gz \
	&& rm steamcmd_linux.tar.gz \
	&& mv steamcmd.sh steamcmd \
	&& chmod 755 steamcmd \
	&& cd / \
	&& steamcmd +login anonymous +quit


############################
# Game server

COPY install.sh /root/install.sh
RUN chmod +x /root/install.sh \
	&& /root/install.sh \
	&& rm /root/install.sh


############################
# Monitor server

COPY monitor/ /monitor/
RUN cd /monitor \
	&& npm i express helmet moment moment-timezone


############################
# Docker server

COPY start-docker-server.sh /app/start-docker-server.sh
RUN chmod +x /app/start-docker-server.sh

WORKDIR /app
CMD ["/app/start-docker-server.sh"]
