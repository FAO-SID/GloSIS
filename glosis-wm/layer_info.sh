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
