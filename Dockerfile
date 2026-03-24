FROM tomcat:10.1

RUN rm -rf /usr/local/tomcat/webapps/*

COPY QuanLyThongTin.war /usr/local/tomcat/webapps/ROOT.war

ENV PORT=10000

EXPOSE 10000

CMD sed -i 's/8080/'"$PORT"'/g' /usr/local/tomcat/conf/server.xml && catalina.sh run