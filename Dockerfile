FROM ubuntu:14.04
MAINTAINER jaz <jaz@live.in>

RUN apt-get update && \
	apt-get clean  && \
	apt-get install -y wget curl git vim && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
  
RUN apt-get update && \
	apt-get clean  && \
	apt-get install -y nginx  php5-fpm php5-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mv /etc/php5/fpm/php.ini /etc/php5/fpm/php1.ini && \
  	mv /etc/nginx/sites-available/default  /etc/nginx/sites-available/default1

COPY php.ini /etc/php5/fpm/
COPY default /etc/nginx/sites-available/
COPY tz.php /usr/share/nginx/html/

RUN apt-get update && \
	apt-get clean  && \
	apt-get install -y openssh-server  --no-install-recommends && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
	
RUN mkdir /var/run/sshd && \
	echo 'root:root' | chpasswd && \
	sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \ 
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN cd /root && \
	echo "#!/bin/bash" > run.sh && \
	echo "service nginx restart" >> run.sh && \
	echo "service php5-fpm restart" >> run.sh && \
	echo "/usr/sbin/sshd -D" >> run.sh && \
	chmod +x run.sh
	 

EXPOSE 22
EXPOSE 80
EXPOSE 443

CMD ["/root/run.sh"]
