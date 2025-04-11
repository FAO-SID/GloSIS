# get overall layer info to build web-mapping interface
psql -h localhost -p 5432 -U xxxxxxx -d iso19139 -c "\copy (
        SELECT  p.project_name, 
                l.layer_id, 
                p2.property_id, 
                p2.name property_name, 
                p2.unit_id, 
                l.dimension_des, 
                'http://localhost:8001/collections/metadata:main/items/'||m.file_identifier metadata_url, 
                u.url download_url,
                'http://localhost:8082/?map=/etc/mapserver/'||l.layer_id||'.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap&BBOX=4.584249999999999936%2C116.5172270000000054%2C21.22970700000000122%2C126.8480870000000067&CRS=EPSG%3A4326&WIDTH=567&HEIGHT=914&LAYERS='||l.layer_id||'&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE' get_map_url,
                'http://localhost:8082/?map=/etc/mapserver/'||l.layer_id||'.map&SERVICE=WMS&VERSION=1.1.1&LAYER='||l.layer_id||'&REQUEST=getlegendgraphic&FORMAT=image/png' get_legend_url,
                'http://localhost:8082/?map=/etc/mapserver/'||l.layer_id||'.map&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetFeatureInfo&BBOX=1.16625995882351496%2C116.25895549999999901%2C24.6476970411764853%2C127.10635850000001312&CRS=EPSG%3A4326&WIDTH=595&HEIGHT=1288&LAYERS='||l.layer_id||'&STYLES=&FORMAT=image%2Fpng&QUERY_LAYERS='||l.layer_id||'&INFO_FORMAT=text%2Fhtml&I=282&J=429' get_feature_info_url
        FROM metadata.layer l
        LEFT JOIN metadata.mapset m ON m.mapset_id = l.mapset_id
        LEFT JOIN metadata.project p ON p.country_id = m.country_id AND p.project_id = m.project_id
        LEFT JOIN metadata.property p2 ON p2.property_id = m.property_id 
        LEFT JOIN metadata.url u ON u.mapset_id = m.mapset_id AND u.url_name = 'Download '||l.dimension_des
        ORDER BY p.project_name, l.layer_id
        ) 
TO '/home/carva014/Work/Code/FAO/GloSIS/glosis-wm/layer_info.csv' WITH CSV HEADER"


# generate random points in the philippines to simulate soil profile data
psql -h localhost -p 5432 -U xxxxxx -d glosis -c "
        DROP TABLE IF EXISTS glosis.philippines_random_points;

        CREATE TABLE IF NOT EXISTS glosis.philippines_random_points (
        id SERIAL PRIMARY KEY,
        geom GEOMETRY(POINT, 4326)
        );

        INSERT INTO glosis.philippines_random_points (geom)
        SELECT (ST_DumpPoints(ST_GeneratePoints(geom,2,2025))).geom
        FROM glosis.country_geom
        WHERE country_id = 'PH';"

psql -h localhost -p 5432 -U xxxxxx -d glosis -c "\copy (
        SELECT id, ST_Y(geom) AS latitude, ST_X(geom) AS longitude
        FROM glosis.philippines_random_points
        ) 
TO '/home/carva014/Work/Code/FAO/GloSIS/glosis-wm/philippines_random_coords.csv' WITH CSV HEADER"

psql -h localhost -p 5432 -U xxxxxx -d glosis -c "DROP TABLE IF EXISTS glosis.philippines_random_points"

psql -h localhost -p 5442 -U glosis -d glosis -c "
        DROP TABLE IF EXISTS core.philippines_random_points;
        CREATE TABLE IF NOT EXISTS core.philippines_random_points (
        id SERIAL PRIMARY KEY,
        latitude FLOAT,
        longitude FLOAT
        )"

psql -h localhost -p 5442 -U glosis -d glosis -c "\copy core.philippines_random_points FROM '/home/carva014/Work/Code/FAO/GloSIS/glosis-wm/philippines_random_coords.csv' WITH CSV HEADER"

psql -h localhost -p 5442 -U glosis -d glosis -c "
        ALTER TABLE core.philippines_random_points ADD COLUMN geom GEOMETRY(POINT, 4326);
        UPDATE core.philippines_random_points SET geom = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);"

# MAP
#     NAME "PH-random_points"
#     STATUS ON
#     EXTENT 116.258955 1.166260 127.106359 24.647697
#     UNITS DD
#     PROJECTION
#         "init=epsg:4326"
#     END

#     SYMBOL
#         NAME "dot"
#         TYPE ELLIPSE
#         POINTS
#             1 1
#         END
#         FILLED TRUE
#     END

#     WEB
#         METADATA
#             "wms_title" "PH-random_points"
#             "wms_enable_request" "*" 
#             "ows_srs" "EPSG:32651 EPSG:4326 EPSG:3857"
#             "wms_getfeatureinfo_formatlist" "text/plain,text/html,application/json,geojson,application/vnd.ogc.gml,gml"
#             "wms_feature_info_mime_type" "application/json"
#         END
#     END
#     LAYER
#         NAME "PH-random_points"
#         TYPE POINT
#         STATUS ON
#         CONNECTIONTYPE postgis
#         CONNECTION "user=glosis password=glosis dbname=glosis host=192.168.1.117 port=5442"
#         DATA "geom FROM core.philippines_random_points USING UNIQUE id"
#         METADATA
#             "wms_include_items" "all"
#             "gml_include_items" "all"
#             "wms_title" "PH-random_points"
#             "wms_srs" "EPSG:32651 EPSG:4326 EPSG:3857"
#             "wms_feature_info_mime_type" "application/json"
#         END
#         LABELCACHE ON
#         CLASS
#             NAME "Random Points"
#             STYLE
#                 SYMBOL "dot"
#                 COLOR 255 0 0
#                 SIZE 8
#             END
#             LABEL
#                 TEXT ([id])
#                 COLOR 0 0 0
#                 SIZE 6
#                 MAXSCALEDENOM 500000
#                 POSITION AUTO
#                 OFFSET 0 5
#                 PARTIALS FALSE
#                 MINDISTANCE 20
#                 BUFFER 5
#                 FORCE TRUE
#             END
#         END
#     END
# END

# Test WMS
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
cd /home/carva014/Work/Code/FAO/GloSIS/glosis-ws/data/
ls *GSAS*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSAS.vrt
rm filelist.txt
ls *GSOC*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSOC.vrt
rm filelist.txt
ls *GSNM*.tif > filelist.txt
gdalbuildvrt -input_file_list filelist.txt PH-GSNM.vrt
rm filelist.txt






