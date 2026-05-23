#File
FROM ubuntu:latest AS BUILD_IMAGE
RUN apt update && apt install wget unzip -y
RUN wget https://www.tooplate.com/zip-templates/2156_graphite_creative.zip
RUN unzip 2156_graphite_creative.zip && cd 2156_graphite_creative && tar -czf graph.tgz * && mv graph.tgz /root/graph.tgz

FROM ubuntu:latest
LABEL "project"="Shop"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install apache2 git wget -y
COPY --from=BUILD_IMAGE /root/graph.tgz /var/www/html/
RUN cd /var/www/html/ && tar xzf graph.tgz
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
VOLUME /var/log/apache2
WORKDIR /var/www/html/
EXPOSE 80

# Build Image
docker build -t  webapp   .
docker images

# Run container from our Image
docker run -P -d webapp
docker ps

