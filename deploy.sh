#!/bin/bash

# working dir 
PROJECT_DIR="/home/carva014/Work/Code/FAO"      # << EDIT THIS LINE!

# date
DATE=`date +%Y-%m-%d_%H-%M`


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
docker cp $PROJECT_DIR/GloSIS/glosis-db/initdb/init-01.sql glosis-db:/tmp/init-01.sql
docker cp $PROJECT_DIR/GloSIS/glosis-db/versions/glosis-db_latest.sql glosis-db:/tmp/init-02.sql
docker cp $PROJECT_DIR/GloSIS/glosis-db/initdb/init-03.sql glosis-db:/tmp/init-03.sql

# execute sql scripts
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-01.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-02.sql
docker exec -it glosis-db psql -d glosis -U glosis -f /tmp/init-03.sql

# profile data for Philipines
docker exec -it glosis-db psql -d glosis -U glosis -c "

    DROP TABLE IF EXISTS core.philippines_profiles;

    CREATE TABLE IF NOT EXISTS core.philippines_profiles (
    id integer,
    dataset_code text,
    profile_code text,
    positional_uncertainty text,
    longitude float,
    latitude float,
    geom GEOMETRY(POINT, 4326)
    );

    INSERT INTO core.philippines_profiles (id, dataset_code, profile_code, positional_uncertainty, longitude, latitude) VALUES
    (1318205, 'US-NCSS', '82P0402', 'Over 10 km', 124.016666666667, 12.9833333333333),
    (1457072, 'US-NCSS', '84P0052', 'Over 10 km', 121.45, 14.4333333333333),
    (1422402, 'US-NCSS', '84P0054', 'Over 10 km', 121.3, 14.1666666666667),
    (1248816, 'US-NCSS', '84P0056', 'Over 10 km', 121.3, 14.1666666666667),
    (1491676, 'US-NCSS', '84P0058', 'Over 10 km', 121.3, 14.1666666666667),
    (1631115, 'US-NCSS', '84P0059', 'Over 10 km', 121.083333333333, 15.7),
    (1422401, 'US-NCSS', '84P0060', 'Over 10 km', 120.966666666667, 15.3),
    (1179035, 'US-NCSS', '84P0062', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1144119, 'US-NCSS', '84P0063', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1665858, 'US-NCSS', '84P0064', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1631114, 'US-NCSS', '84P0065', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1561341, 'US-NCSS', '84P0066', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1352905, 'US-NCSS', '84P0067', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1248815, 'US-NCSS', '84P0068', 'Over 10 km', 120.583333333333, 15.4833333333333),
    (1283561, 'US-NCSS', '84P0069', 'Over 10 km', 124.016666666667, 12.9833333333333),
    (1526537, 'US-NCSS', '84P0072', 'Over 10 km', 123.283333333333, 13.6166666666667),
    (1422403, 'US-NCSS', '84P0077', 'Over 10 km', 120.6, 18.05),
    (1248814, 'US-NCSS', '84P0078', 'Over 10 km', 120.5, 14.5),
    (1387751, 'US-NCSS', '85P0588', '1 km - 10 km', 123.0291672, 11.1972217999999),
    (1596075, 'US-NCSS', '85P0589', '1 km - 10 km', 122.8874969, 11.0569448),
    (1387753, 'US-NCSS', '85P0590', '1 km - 10 km', 122.4777756, 10.9138889),
    (1422387, 'US-NCSS', '85P0591', '1 km - 10 km', 123.1138916, 10.6466665),
    (1526538, 'US-NCSS', '85P0592', 'Over 10 km', 123.020835899999, 10.7666664),
    (1561328, 'US-NCSS', '85P0593', '1 km - 10 km', 123.0611115, 10.4083328),
    (1491657, 'US-NCSS', '85P0594', '1 km - 10 km', 122.9111099, 10.5319442999999),
    (1387752, 'US-NCSS', '85P0595', '1 km - 10 km', 123.395835899999, 10.4916668),
    (1179026, 'US-NCSS', '85P0596', '1 km - 10 km', 123.3874969, 10.4916668),
    (1665859, 'US-NCSS', '85P0597', 'Over 10 km', 123.994445799999, 10.4333334),
    (1213976, 'US-NCSS', '85P0598', '1 km - 10 km', 123.5055542, 10.1138887),
    (1422388, 'US-NCSS', '85P0599', '1 km - 10 km', 123.8458328, 10.2569447),
    (1318206, 'US-NCSS', '85P0600', 'Over 10 km', 125, 11.4833336),
    (1457058, 'US-NCSS', '85P0601', '1 km - 10 km', 124.7991638, 10.2608336999999),
    (1387763, 'US-NCSS', '85P0602', 'Over 10 km', 124.75, 10.3833331999999),
    (1248818, 'US-NCSS', '85P0603', 'Over 10 km', 124.7750015, 10.9833336),
    (1248819, 'US-NCSS', '85P0604', 'Over 10 km', 125.0513916, 11.333333),
    (1526552, 'US-NCSS', '87P0487', '1 km - 10 km', 121.133331299999, 15.9611111),
    (1387754, 'US-NCSS', '87P0488', '1 km - 10 km', 124.8125, 10.6875),
    (1530205, 'US-NCSS', '94P0496', 'Circa 100 m', 120.6263885, 13.4855556),
    (1634743, 'US-NCSS', '94P0499', 'Circa 100 m', 125.099670399999, 8.0139446),
    (1182749, 'US-NCSS', '94P0504', 'Circa 100 m', 125.1045532, 8.0398054),
    (1565060, 'US-NCSS', '94P0507', 'Circa 100 m', 125.098586999999, 8.0069447),
    (1182761, 'US-NCSS', '94P0724', 'Circa 100 m', 120.626113899999, 13.4872227),
    (1252425, 'US-NCSS', '94P0725', 'Circa 100 m', 120.6263885, 13.4855556),
    (1492108, 'WD-ISIS', 'PH001', 'Over 10 km', 123.286388888889, 13.6666666666667),
    (1492115, 'WD-ISIS', 'PH003', '1 km - 10 km', 120.948611111111, 15.2130555555556),
    (1144575, 'WD-ISIS', 'PH004', '1 km - 10 km', 120.866666666667, 15.2825),
    (1388176, 'WD-ISIS', 'PH005', '1 km - 10 km', 120.936944444444, 15.2497222222222),
    (1631573, 'WD-ISIS', 'PH006', '1 km - 10 km', 121.261944444444, 14.1602777777778),
    (1483250, 'WD-Mangroves', 'ACA14 Average', 'Circa 100 m', 118.730674743652, 10.043023109436),
    (1448627, 'WD-Mangroves', 'BST14 Bugtong-ato Interior', 'Circa 100 m', 122.958114624023, 11.0699043273926),
    (1413986, 'WD-Mangroves', 'BST14 Bugtong-ato Landward', 'Circa 100 m', 122.957847595215, 11.070348739624),
    (1448626, 'WD-Mangroves', 'BST14 Bugtong-ato Seaward', 'Circa 100 m', 122.958305358887, 11.0695056915283),
    (1448624, 'WD-Mangroves', 'BST14 Pedada Interior', 'Circa 100 m', 122.141075134277, 11.8242969512939),
    (1587845, 'WD-Mangroves', 'BST14 Pedada Landward', 'Circa 100 m', 122.141052246094, 11.8238258361816),
    (1622783, 'WD-Mangroves', 'BST14 Pedada Seaward', 'Circa 100 m', 122.141082763672, 11.8247756958008),
    (1319020, 'WD-WISE', 'PH0001', 'Over 10 km', 121.4, 14.2666666666667),
    (1179896, 'WD-WISE', 'PH0003', 'Over 10 km', 120.916666666667, 14.0833333333333),
    (1144949, 'WD-WISE', 'PH0004', 'Over 10 km', 123.2, 13.6),
    (1493021, 'WD-WISE', 'PH0005', 'Over 10 km', 123.286388888889, 13.6666666666667),
    (1562135, 'WD-WISE', 'PH0006', 'Over 10 km', 120.916666666667, 14.1666666666667),
    (1145490, 'WD-WISE', 'PH0007', '1 km - 10 km', 120.866666666667, 15.2825),
    (1319022, 'WD-WISE', 'PH0008', 'Over 10 km', 124.016666666667, 12.9833333333333),
    (1632405, 'WD-WISE', 'PH0009', '1 km - 10 km', 121.261944444444, 14.1602777777778),
    (1493028, 'WD-WISE', 'PH0010', '1 km - 10 km', 120.948611111111, 15.2130555555556),
    (1389024, 'WD-WISE', 'PH0011', '1 km - 10 km', 120.936944444444, 15.2497222222222),
    (1284384, 'WD-WISE', 'PH0013', 'Over 10 km', 123.4, 13.4333333333333),
    (1388546, 'WD-WISE', 'PH0014', 'Over 10 km', 124, 13),
    (1249628, 'WD-WISE', 'PH0015', 'Over 10 km', 123.7, 13.1666666666667),
    (1284385, 'WD-WISE', 'PH0016', 'Over 10 km', 120.9, 14.1166666666667),
    (1284386, 'WD-WISE', 'PH0017', 'Over 10 km', 123.7, 13.1666666666667),
    (1666632, 'WD-WISE', 'PH0018', 'Over 10 km', 120.916666666667, 14.2),
    (1492509, 'WD-WISE', 'PH0019', 'Over 10 km', 121.3, 14.1666666666667),
    (1249629, 'WD-WISE', 'PH0020', 'Over 10 km', 120.5, 14.5),
    (1284387, 'WD-WISE', 'PH0021', 'Over 10 km', 124.016666666667, 12.9833333333333),
    (1353728, 'WD-WISE', 'PH0023', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1249630, 'WD-WISE', 'PH0024', 'Over 10 km', 120.583333333333, 15.4833333333333),
    (1179897, 'WD-WISE', 'PH0025', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1423208, 'WD-WISE', 'PH0026', 'Over 10 km', 120.966666666667, 15.3),
    (1423209, 'WD-WISE', 'PH0027', 'Over 10 km', 121.3, 14.1666666666667),
    (1249631, 'WD-WISE', 'PH0028', 'Over 10 km', 121.3, 14.1666666666667),
    (1562136, 'WD-WISE', 'PH0029', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1631879, 'WD-WISE', 'PH0030', 'Over 10 km', 120.516666666667, 15.9666666666667),
    (1144950, 'WD-WISE', 'PH0032', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1144880, 'WD-WISE', 'PH0033', '1 km - 10 km', 120.581944444444, 16.0497222222222),
    (1249568, 'WD-WISE', 'PH0034', '1 km - 10 km', 121.450277777778, 14.44),
    (1457936, 'WD-WISE', 'PH0036', 'Over 10 km', 121.45, 14.4333333333333),
    (1423210, 'WD-WISE', 'PH0037', 'Over 10 km', 120.6, 18.05),
    (1388485, 'WD-WISE', 'PH0038', '1 km - 10 km', 121.3875, 16.0622222222222),
    (1527324, 'WD-WISE', 'PH0039', 'Over 10 km', 123.283333333333, 13.6166666666667),
    (1527266, 'WD-WISE', 'PH0040', '1 km - 10 km', 121.208333333333, 14.5538888888889),
    (1666633, 'WD-WISE', 'PH0041', 'Over 10 km', 120.316666666667, 15.7333333333333),
    (1666576, 'WD-WISE', 'PH0042', '1 km - 10 km', 120.890555555556, 15.6725),
    (1457937, 'WD-WISE', 'PH0044', 'Over 10 km', 123.3, 13.5666666666667),
    (1631880, 'WD-WISE', 'PH0047', 'Over 10 km', 121.083333333333, 15.7),
    (1249633, 'WD-WISE', 'PH0048', 'Over 10 km', 122.966666666667, 10.6166666666667),
    (1492511, 'WD-WISE', 'PH0049', 'Over 10 km', 122.95, 10.6333333333333),
    (1249653, 'WD-WISE', 'PH0050', 'Over 10 km', 120.216666666667, 15),
    (1214810, 'WD-WISE', 'PH0051', 'Over 10 km', 120.233333333333, 15),
    (1562156, 'WD-WISE', 'PH0052', 'Over 10 km', 122.983333333333, 10.6333333333333),
    (1666634, 'WD-WISE', 'PH0053', 'Over 10 km', 120.216666666667, 15),
    (1179899, 'WD-WISE', 'PH0054', 'Over 10 km', 122.95, 10.6333333333333),
    (1457879, 'WD-WISE', 'PH0055', '1 km - 10 km', 124.7991638, 10.2608336999999),
    (1596843, 'WD-WISE', 'PH0056', '1 km - 10 km', 122.8874969, 11.0569448),
    (1562079, 'WD-WISE', 'PH0057', '1 km - 10 km', 123.0611115, 10.4083328),
    (1423140, 'WD-WISE', 'PH0058', '1 km - 10 km', 123.1138916, 10.6466665),
    (1214757, 'WD-WISE', 'PH0059', '1 km - 10 km', 123.5055542, 10.1138887),
    (1388486, 'WD-WISE', 'PH0060', '1 km - 10 km', 123.0291672, 11.1972217999999),
    (1319023, 'WD-WISE', 'PH0061', 'Over 10 km', 125, 11.4833336),
    (1388547, 'WD-WISE', 'PH0062', 'Over 10 km', 124.75, 10.3833331999999),
    (1388487, 'WD-WISE', 'PH0063', '1 km - 10 km', 123.395835899999, 10.4916668),
    (1179842, 'WD-WISE', 'PH0064', '1 km - 10 km', 123.3874969, 10.4916668),
    (1249634, 'WD-WISE', 'PH0065', 'Over 10 km', 124.7750015, 10.9833336),
    (1388488, 'WD-WISE', 'PH0066', '1 km - 10 km', 122.4777756, 10.9138889),
    (1666635, 'WD-WISE', 'PH0067', 'Over 10 km', 123.994445799999, 10.4333334),
    (1249635, 'WD-WISE', 'PH0068', 'Over 10 km', 125.0513916, 11.333333),
    (1527325, 'WD-WISE', 'PH0069', 'Over 10 km', 123.020835899999, 10.7666664),
    (1492443, 'WD-WISE', 'PH0070', '1 km - 10 km', 122.9111099, 10.5319442999999),
    (1423141, 'WD-WISE', 'PH0071', '1 km - 10 km', 123.8458328, 10.2569447),
    (1388489, 'WD-WISE', 'PH0072', '1 km - 10 km', 124.8125, 10.6875),
    (1527407, 'WD-WISE', 'PH0073', '1 km - 10 km', 121.133331299999, 15.9611111);
    
    UPDATE core.philippines_profiles SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);"


####################
#    pyCSW (md)    #
####################

# load records
# mv $PROJECT_DIR/GloSIS/glosis-datacube/PH/output/*.xml $PROJECT_DIR/GloSIS/glosis-md/records
docker-compose exec glosis-md ls -l /records
docker-compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# verify if records were loaded
docker-compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title;"

# custumization - https://docs.pycsw.org/en/latest/configuration.html
# docker-compose exec glosis-md sed -i 's/pycsw website/Philippines SIS metadata/g' pycsw/pycsw/ogc/api/templates/_base.html
# docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org\/img\/pycsw-logo-vertical.png/https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png/g' pycsw/pycsw/ogc/api/templates/_base.html
# docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g' pycsw/pycsw/ogc/api/templates/_base.html


####################
#  MapServer (ws)  #
####################

# copy geotiffs and map files
# mv $PROJECT_DIR/GloSIS/glosis-datacube/PH/output/*.tif $PROJECT_DIR/GloSIS/glosis-ws/data/
# mv $PROJECT_DIR/GloSIS/glosis-datacube/PH/output/*.map $PROJECT_DIR/GloSIS/glosis-ws/data/

# Test raster WMS
# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=4.584249999999999936%2C116.5172270000000054%2C21.22970700000000122%2C126.8480870000000067&CRS=EPSG%3A4326&WIDTH=567&HEIGHT=914&LAYERS=PH-GSAS-ECX-2020-0-30&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.1.1&LAYER=PH-GSAS-ECX-2020-0-30&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-30-100.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=1.16625995882351496%2C116.25895549999999901%2C24.6476970411764853%2C127.10635850000001312&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1288&LAYERS=PH-GSAS-ECX-2020-30-100&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-GSAS-ECX-2020-30-100&INFO_FORMAT=text%2Fhtml&I=282&J=429
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=1.16625995882351496%2C116.25895549999999901%2C24.6476970411764853%2C127.10635850000001312&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1288&LAYERS=PH-GSAS-ECX-2020-0-30&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-GSAS-ECX-2020-0-30&INFO_FORMAT=geojson&I=282&J=429
http://localhost:8082/?map=/etc/mapserver/PH-GSNM-BKD-2023-0-30.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&LAYERS=PH-GSNM-BKD-2023-0-30&STYLES=&FORMAT=image/png&QUERY_LAYERS=PH-GSNM-BKD-2023-0-30&INFO_FORMAT=text/html
# QGIS add WMS layer
http://localhost:8082/?map=/etc/mapserver/PH-GSAS-ECX-2020-0-30.map

# Test profiles WMS
# GetCapabilities
http://localhost:8082/?map=/etc/mapserver/PH-random_points.map&SERVICE=WMS&REQUEST=GetCapabilities
# GetMap
http://localhost:8082?map=/etc/mapserver/PH-random_points.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=1.166260000000000074%2C116.6146860695027954%2C23.85647567931255963%2C127.1063589999999976&CRS=EPSG%3A4326&WIDTH=549&HEIGHT=1186&LAYERS=PH-random_points&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE
# GetLegendGraphic
http://localhost:8082/?map=/etc/mapserver/PH-random_points.map&SERVICE=WMS&VERSION=1.1.1&LAYER=PH-random_points&REQUEST=getlegendgraphic&FORMAT=image/png
# GetFeatureInfo
http://localhost:8082/?map=/etc/mapserver/PH-random_points.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=1.16625995882351496%2C116.25895549999999901%2C24.6476970411764853%2C127.10635850000001312&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1288&LAYERS=PH-random_points&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-random_points&INFO_FORMAT=text%2Fhtml&I=282&J=429
# QGIS add WMS layer
http://localhost:8082/?map=/etc/mapserver/PH-random_points.map

# create VRTs
cd $PROJECT_DIR/GloSIS/glosis-ws/data/
ls *GSAS*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSAS.vrt
rm filelist.txt
ls *GSOC*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSOC.vrt
rm filelist.txt
ls *GSNM*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSNM.vrt
rm filelist.txt

# Test VRT WMS
# VRT GetMap
http://localhost:8082?map=/etc/mapserver/PH-GSOC.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=11.50360938260532961%2C119.4691787884444949%2C17.66748659510531283%2C122.84315021570988335&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1087&LAYERS=PH-GSOC&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE
# VRT GetFeatureInfo
http://localhost:8082?map=/etc/mapserver/PH-GSOC.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=11.50360938260532961%2C119.4691787884444949%2C17.66748659510531283%2C122.84315021570988335&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1087&LAYERS=PH-GSOC&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS=PH-GSOC&INFO_FORMAT=text%2Fhtml&I=244&J=358


####################
#  PostgreSQL (db) #
####################

pg_dump -h localhost -p 5442 -U glosis -d glosis -Fc -v -f $PROJECT_DIR/GloSIS/glosis-db/backups/glosis_backup_${DATE}.backup

