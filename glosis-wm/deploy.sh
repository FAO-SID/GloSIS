#################################
#            Docker             #
#################################


# glosis-wm/
# ├── docker-compose.yml
# ├── Dockerfile
# ├── index.html
# ├── main.js
# └── package.json

# Set Up the Project
cd /home/carva014/Work/Code/FAO/glosis-sis/Apps/
mkdir glosis-wm
cd glosis-wm
docker-compose down
docker-compose up --build
# Access your map at http://localhost:1234




# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-PHX-2020-0-30.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/GSOC.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&CRS=EPSG:4326&BBOX=-60,-180,85,180&WIDTH=800&HEIGHT=400&LAYERS=GSOC&STYLES=default&FORMAT=image/png
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-PHX-2020-0-30.map&SERVICE=WMS&VERSION=1.1.1&LAYER=PH-GSAS-PHX-2020&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-PHX-2020-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=16.74384930440644581%2C121.73045139411715354%2C16.77798088331270066%2C121.75372956945258807&CRS=EPSG%3A4326&WIDTH=637&HEIGHT=934&LAYERS=PH-GSAS-PHX-2020&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-GSAS-PHX-2020&INFO_FORMAT=application%2Fvnd.ogc.gml&I=516&J=836
# QGIS add WMS layer
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-PHX-2020-0-30.map



