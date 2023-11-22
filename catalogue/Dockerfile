FROM    node
RUN     useradd -m -d /app roboshop
USER    roboshop
WORKDIR /app
ADD     package.json .
ADD     server.js .
RUN     npm install
CMD     ["node", "server.js"]

