#################################
#            Docker             #
#################################


# dockerhub
https://hub.docker.com/r/camptocamp/mapserver/tags


# docker comands
docker images
docker image rm XXXXXXXXXX
docker ps --all
docker container stop XXXXXXXXXX
docker container rm XXXXXXXXXX


# add in folder /home/carva014/Work/Code/GRP_LGN/geoserver_data_processing/mapserver/data/ one geotiff and it's respective map file
# in this example, I added LGN6.tif, LGN6.map and getfeatureinfo_template.tmpl.


docker ps --all
docker logs XXXXXXXXXX


# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&CRS=EPSG:28992&BBOX=-40000,300000,300000,650000&WIDTH=500&HEIGHT=500&LAYERS=LGN6&STYLES=default&FORMAT=image/png
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.1.1&LAYER=LGN6&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/LGN6.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=537861,6757475,734631,6932972&CRS=EPSG:3857&WIDTH=1073&HEIGHT=957&LAYERS=LGN6&STYLES=default&FORMAT=image/png&QUERY_LAYERS=LGN6&INFO_FORMAT=text/html&I=389&J=589

