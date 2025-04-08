#!/bin/bash
# https://docs.pycsw.org/en/latest/docker.html
# https://github.com/geopython/pycsw/blob/master/docker/compose/docker-compose.scale.yml


cd ~/Work/Code/FAO/GloSIS/glosis-md
mkdir records
docker compose up
# http://localhost:8001/

docker-compose exec pycsw ls -l /records

docker-compose exec pycsw pycsw-admin.py load-records --help
# Usage: pycsw-admin.py load-records [OPTIONS]

#   Load metadata records from directory or file into repository

# Options:
#   -v, --verbosity [ERROR|WARNING|INFO|DEBUG]
#                                   Verbosity
#   -c, --config PATH               Path to pycsw configuration  [required]
#   -p, --path PATH                 File or directory path to metadata records
#                                   [required]
#   -r, --recursive                 Bypass confirmation
#   -y, --yes                       Bypass confirmation
#   --help                          Show this message and exit.

#                         pycsw-admin.py load-records --config default.yml --path /path/to/records

# delete records
docker-compose exec pycsw pycsw-admin.py delete-records --config /etc/pycsw/pycsw.yml -y

# load records
python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/table2xml.py
python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/export.py
cp /home/carva014/Downloads/FAO/SIS/PH/Processed/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records
docker-compose exec pycsw pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# verify if records were loaded
docker-compose exec pycsw-db psql -U glosis -d pycsw -c "SELECT identifier, title FROM public.records ORDER BY title;"

# custumization - https://docs.pycsw.org/en/latest/configuration.html
docker-compose exec pycsw cp pycsw/default-sample.yml pycsw/default.yml
docker-compose exec pycsw sed -i 's/csw_harvest_pagesize: 50/csw_harvest_pagesize: 10/g' pycsw/default.yml






# RUN sed -i -e 's#${jdbc.database}?${jdbc.connectionProperties}#${jdbc.database}#g' $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-db/postgres.xml
# COPY ./lib/jdk8/java.security $JAVA_HOME/jre/lib/security/java.security



# https://docs.pycsw.org/en/latest/configuration.html
# pycsw.server.baseurl = http://localhost:8001/csw
# pycsw.server.maxrecords = 10
# pycsw.server.maxrecords = 10  

# https://docs.pycsw.org/en/latest/configuration.html
# pycsw.server.baseurl = http://localhost:8001/csw
# pycsw.server.maxrecords = 10
# pycsw.server.maxrecords = 10  

# table: the table name for metadata records (default is records). If you are using PostgreSQL with a DB schema other than public, qualify the table like myschema.table
docker-compose exec pycsw pycsw-admin.py update-config --config /etc/pycsw/pycsw.yml --key "pycsw.database.table" --value "pycsw.records"

docker exec -it pycsw /bin/bash





