FROM    maven
RUN     useradd -m -d /app roboshop
USER    roboshop
WORKDIR /app
COPY    src src
COPY    pom.xml pom.xml
RUN     mvn clean package
CMD     ["java", "-Xmx2500m", "-jar", "target/shipping-1.0.jar" ]
