FROM hagb/docker-easyconnect:7.6.7

COPY forward_ports.sh /usr/local/bin/forward_ports.sh

RUN sed -i '34i source /usr/local/bin/forward_ports.sh' /usr/local/bin/start.sh
