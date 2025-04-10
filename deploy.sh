#################################
#            Docker             #
#################################


# docker comands
# docker images
# docker image rm XXXXXXXXXX
# docker ps --all
# docker container stop XXXXXXXXXX
# docker container rm XXXXXXXXXX
# docker logs XXXXXXXXXX


# To remove all existing images, containers and databases, run the following commands in your docker-compose.yml folder
docker stop $(docker ps -q)
docker rm $(docker ps -aq)
docker rmi $(docker images -q) --force
docker network prune -f
docker volume prune -f
docker system prune -a --volumes -f
docker-compose up --build


####################
#  PostgreSQL (db) #
####################

# copy sql scripts to db container
docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/initdb/init-01.sql glosis-db:/tmp/init-01.sql
docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_latest.sql glosis-db:/tmp/init-02.sql
docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/initdb/init-03.sql glosis-db:/tmp/init-03.sql

# execute sql scripts
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-01.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-02.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-03.sql


####################
#    pyCSW (md)    #
####################

# load records
cp /home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/PH/output/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records
docker-compose exec glosis-md ls -l /records
docker-compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# verify if records were loaded
docker-compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title;"

# custumization - https://docs.pycsw.org/en/latest/configuration.html
docker-compose exec glosis-md sed -i 's/pycsw website/Philippines SIS metadata/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org\/img\/pycsw-logo-vertical.png/https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g' pycsw/pycsw/ogc/api/templates/_base.html


####################
#  MapServer (ws)  #
####################

# copy geotiffs and map files
cp /home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/PH/output/*.tif /home/carva014/Work/Code/FAO/GloSIS/glosis-ws/data/
cp /home/carva014/Work/Code/FAO/GloSIS/glosis-datacube/PH/output/*.map /home/carva014/Work/Code/FAO/GloSIS/glosis-ws/data/

# Test WMS
# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=4.584249999999999936%2C116.5172270000000054%2C21.22970700000000122%2C126.8480870000000067&CRS=EPSG%3A4326&WIDTH=567&HEIGHT=914&LAYERS=PH-GSAS-ECX-2020-0-30&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.1.1&LAYER=PH-GSAS-ECX-2020-0-30&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=1.16625995882351496%2C116.25895549999999901%2C24.6476970411764853%2C127.10635850000001312&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1288&LAYERS=PH-GSAS-ECX-2020-0-30&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-GSAS-ECX-2020-0-30&INFO_FORMAT=text%2Fhtml&I=282&J=429
# QGIS add WMS layer
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map
