 
FROM sonarqube:8.6-community
USER root
RUN apk add --no-cache wget curl java-cacerts jq nodejs
RUN ln -sf /etc/ssl/certs/java/cacerts /opt/java/openjdk/lib/security/cacerts
ADD ./plugins /tmp/plugins
RUN rm -rf ./extensions/plugins/* && \
    cat /tmp/plugins/plugin-list.txt && \
    chmod +x /tmp/plugins/install-plugins.sh && \
    ls /tmp/plugins -l && \
    apk --no-cache add dos2unix && \ 
    dos2unix /tmp/plugins/install-plugins.sh  && \
    dos2unix /tmp/plugins/plugin-list.txt && \
    /tmp/plugins/install-plugins.sh
WORKDIR /opt/sonarqube
COPY ./start-with-profile.sh .
ADD ./rules /tmp/rules
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
RUN chown -R sonarqube:sonarqube . && chmod +x start-with-profile.sh && \
    dos2unix ./start-with-profile.sh
CMD ["./start-with-profile.sh"]