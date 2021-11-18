FROM python:3.7
RUN pip install apache-airflow==1.10.15 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-1.10.15/constraints-3.7.txt" && pip install dbt==0.15
RUN pip install SQLAlchemy==1.3.23
RUN mkdir /project
COPY scripts_airflow/ /project/scripts/

# Installing Java runtime environments for the Deltek drivers
RUN apt update
RUN apt upgrade -y
RUN apt install default-jre default-jdk -y
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/bin/java

# Copy Deltek ODBC driver installaion files to container
RUN mkdir /deltek_odbc
COPY deltek_odbc/ /deltek_odbc/
#RUN /deltek_odbc/PROGRESS_DATADIRECT_HDP_ODBC_LINUX_64.bin -i silent -f /deltek_odbc/installer.properties

# I don't know what this does, but it looks important
RUN chmod +x /project/scripts/init.sh
ENTRYPOINT [ "/project/scripts/init.sh" ]