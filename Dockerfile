FROM ubuntu
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install vim git tmux
RUN useradd -ms /bin/bash lemon
USER lemon
WORKDIR /home/lemon/code/bash
