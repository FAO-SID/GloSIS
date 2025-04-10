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

docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/initdb/init-01.sql glosis-db:/tmp/init-01.sql
docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/versions/glosis-db_latest.sql glosis-db:/tmp/init-02.sql
docker cp /home/carva014/Work/Code/FAO/GloSIS/glosis-db/initdb/init-03.sql glosis-db:/tmp/init-03.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-01.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-02.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-03.sql


####################
#    pyCSW (md)    #
####################

# load records
# conda activate db
# python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/table2xml.py
# python /home/carva014/Work/Code/FAO/GloSIS-private/Metadata/export.py
# cp /home/carva014/Downloads/FAO/SIS/PH/Processed/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records
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
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&CRS=EPSG:28992&BBOX=-40000,300000,300000,650000&WIDTH=500&HEIGHT=500&LAYERS=LGN6&STYLES=default&FORMAT=image/png
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.1.1&LAYER=LGN6&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=537861,6757475,734631,6932972&CRS=EPSG:3857&WIDTH=1073&HEIGHT=957&LAYERS=LGN6&STYLES=default&FORMAT=image/png&QUERY_LAYERS=LGN6&INFO_FORMAT=text/html&I=389&J=589

# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/GSOC.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/GSOC.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&CRS=EPSG:4326&BBOX=-60,-180,85,180&WIDTH=800&HEIGHT=400&LAYERS=GSOC&STYLES=default&FORMAT=image/png
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/GSOC.map&SERVICE=WMS&VERSION=1.1.1&LAYER=GSOC&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/GSOC.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=537861,6757475,734631,6932972&CRS=EPSG:3857&WIDTH=1073&HEIGHT=957&LAYERS=GSOC&STYLES=default&FORMAT=image/png&QUERY_LAYERS=GSOC&INFO_FORMAT=text/html&I=389&J=589
# QGIS add WMS layer
http://localhost:8082/?map=/etc/mapserver/GSOC.map