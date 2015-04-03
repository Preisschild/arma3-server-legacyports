FROM ubuntu

MAINTAINER "Diego Marangoni" <diegomarangoni@me.com>

RUN apt-get update && apt-get install -y lib32gcc1 lib32stdc++6 wget

RUN cd /root \
	&& wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz \
	&& tar -zxvf steamcmd_linux.tar.gz \
	&& rm -f steamcmd_linux.tar.gz

RUN /root/steamcmd.sh +login anonymous +quit
RUN echo 233780 > steam_appid.txt

VOLUME /arma3
VOLUME /server/profiles

ENV STEAM_USERNAME=username
ENV STEAM_PASSWORD=password

ENV VALIDATE=1

COPY main.cfg /server/
COPY basic.cfg /server/

COPY docker-entrypoint.sh /

EXPOSE 2302 2303 2304 2305

ENTRYPOINT ["/docker-entrypoint.sh"]

WORKDIR /arma3

CMD ["./arma3server", "-ip=0.0.0.0", "-port=2302", "-profiles=/server/profiles", "-config=/server/main.cfg", "-cfg=/server/basic.cfg", "-name=default"]
