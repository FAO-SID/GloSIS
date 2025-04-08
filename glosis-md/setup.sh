#!/bin/bash
# https://docs.pycsw.org/en/latest/docker.html
# https://github.com/geopython/pycsw/blob/master/docker/compose/docker-compose.scale.yml


cd ~/Work/Code/FAO/GloSIS/glosis-md

# load records
mkdir records
python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/table2xml.py
python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/export.py
cp /home/carva014/Downloads/FAO/SIS/PH/Processed/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records

# start pycsw
docker compose up # http://localhost:8001/

# delete records
docker-compose exec pycsw pycsw-admin.py delete-records --config /etc/pycsw/pycsw.yml -y

# load records
docker-compose exec pycsw ls -l /records
docker-compose exec pycsw pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# verify if records were loaded
docker-compose exec pycsw-db psql -U glosis -d pycsw -c "SELECT identifier, title FROM public.records ORDER BY title;"

# custumization - https://docs.pycsw.org/en/latest/configuration.html
docker-compose exec pycsw sed -i 's/pycsw website/Philippines SIS metadata/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec pycsw sed -i 's/https:\/\/pycsw.org\/img\/pycsw-logo-vertical.png/https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec pycsw sed -i 's/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g' pycsw/pycsw/ogc/api/templates/_base.html

# access pycsw container
docker exec -it pycsw /bin/bash

# notes
# RUN sed -i -e 's#${jdbc.database}?${jdbc.connectionProperties}#${jdbc.database}#g' $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-db/postgres.xml
# COPY ./lib/jdk8/java.security $JAVA_HOME/jre/lib/security/java.security


