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
docker-compose exec pycsw-db psql -U glosis -d pycsw -c "\dt"
curl "http://localhost:8001/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&resulttype=hits&elementsetname=full"




# [SQL: INSERT INTO records (identifier, typename, schema, mdsource, insert_date, xml, anytext, metadata, metadata_type, language, type, title, title_alternate, abstract, edition, keywords, keywordstype, themes, parentidentifier, relation, time_begin, time_end, topicategory, resourcelanguage, creator, publisher, contributor, organization, securityconstraints, accessconstraints, otherconstraints, date, date_revision, date_creation, date_publication, date_modified, format, source, crs, geodescode, denominator, distancevalue, distanceuom, wkt_geometry, vert_extent_min, vert_extent_max, servicetype, servicetypeversion, operation, couplingtype, operateson, operatesonidentifier, operatesoname, degree, classification, conditionapplyingtoaccessanduse, lineage, responsiblepartyrole, specificationtitle, specificationdate, specificationdatetype, platform, instrument, sensortype, cloudcover, bands, links, contacts, anytext_tsvector, wkb_geometry) VALUES (%(identifier)s, %(typename)s, %(schema)s, %(mdsource)s, %(insert_date)s, %(xml)s, %(anytext)s, %(metadata)s, %(metadata_type)s, %(language)s, %(type)s, %(title)s, %(title_alternate)s, %(abstract)s, %(edition)s, %(keywords)s, %(keywordstype)s, %(themes)s, %(parentidentifier)s, %(relation)s, %(time_begin)s, %(time_end)s, %(topicategory)s, %(resourcelanguage)s, %(creator)s, %(publisher)s, %(contributor)s, %(organization)s, %(securityconstraints)s, %(accessconstraints)s, %(otherconstraints)s, %(date)s, %(date_revision)s, %(date_creation)s, %(date_publication)s, %(date_modified)s, %(format)s, %(source)s, %(crs)s, %(geodescode)s, %(denominator)s, %(distancevalue)s, %(distanceuom)s, %(wkt_geometry)s, %(vert_extent_min)s, %(vert_extent_max)s, %(servicetype)s, %(servicetypeversion)s, %(operation)s, %(couplingtype)s, %(operateson)s, %(operatesonidentifier)s, %(operatesoname)s, %(degree)s, %(classification)s, %(conditionapplyingtoaccessanduse)s, %(lineage)s, %(responsiblepartyrole)s, %(specificationtitle)s, %(specificationdate)s, %(specificationdatetype)s, %(platform)s, %(instrument)s, %(sensortype)s, %(cloudcover)s, %(bands)s, %(links)s, %(contacts)s, %(anytext_tsvector)s, %(wkb_geometry)s)]
# [parameters: {'identifier': '32afbc7a-ebeb-11ef-bc12-6b4a6fcd8b5e', 'typename': 'gmd:MD_Metadata', 'schema': 'http://www.isotc211.org/2005/gmd', 'mdsource': 'local', 'insert_date': '2025-04-07T17:16:17Z', 'xml': '<gmd:MD_Metadata xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gmd="http://www.isotc211.org/2005/gmd" ... (21408 characters truncated) ... n          </gmd:statement>\n        </gmd:LI_Lineage>\n      </gmd:lineage>\n    </gmd:DQ_DataQuality>\n  </gmd:dataQualityInfo>\n</gmd:MD_Metadata>', 'anytext': '  32afbc7a-ebeb-11ef-bc12-6b4a6fcd8b5e               Andrew B. Flores    Departement of Agriculture - Bureau of Soils and Water Management    Science ... (2201 characters truncated) ... 23/GLOSIS.PH-GSNM-CLAY-2023.D-30-60.tif    WWW:LINK-1.0-http--link    Download 30-60                           https://doi.org/10.4060/cc1717en      ', 'metadata': None, 'metadata_type': 'application/xml', 'language': 'eng', 'type': 'dataset', 'title': 'Soil clay content (Philippines - 250 m)', 'title_alternate': None, 'abstract': 'Percent clay derived from soil samples collected from 0-30, 30-60 and 60-100 cm depth', 'edition': None, 'keywords': 'soil,digital soil mapping,clay,texture,Soil science,Philippines', 'keywordstype': 'theme', 'themes': '[{"keywords": [{"name": "Soil science", "url": null}], "type": "discipline", "thesaurus": {"title": "Discipline", "url": null, "date": null, "datetyp ... (12 characters truncated) ... {"keywords": [{"name": "Philippines", "url": null}], "type": "place", "thesaurus": {"title": "Region", "url": null, "date": null, "datetype": null}}]', 'parentidentifier': None, 'relation': None, 'time_begin': '1960-01-01', 'time_end': '2020-12-31', 'topicategory': 'geoscientificInformation', 'resourcelanguage': 'eng', 'creator': None, 'publisher': None, 'contributor': 'Departement of Agriculture - Bureau of Soils and Water Management', 'organization': 'Departement of Agriculture - Bureau of Soils and Water Management', 'securityconstraints': None, 'accessconstraints': 'copyright', 'otherconstraints': 'Creative Commons Attribution 4.0', 'date': '2023-12-01', 'date_revision': None, 'date_creation': '2023-12-01', 'date_publication': '2023-12-01', 'date_modified': '2023-12-01', 'format': 'GeoTIFF,OGC:WMTS,WWW:LINK-1.0-http--link', 'source': None, 'crs': 'urn:ogc:def:crs:EPSG::32651', 'geodescode': None, 'denominator': None, 'distancevalue': '250.0', 'distanceuom': 'm', 'wkt_geometry': 'POLYGON((116.50 4.60, 116.50 21.10, 126.60 21.10, 126.60 4.60, 116.50 4.60))', 'vert_extent_min': None, 'vert_extent_max': None, 'servicetype': '', 'servicetypeversion': None, 'operation': None, 'couplingtype': None, 'operateson': None, 'operatesonidentifier': None, 'operatesoname': None, 'degree': None, 'classification': None, 'conditionapplyingtoaccessanduse': None, 'lineage': None, 'responsiblepartyrole': 'metadataProvider', 'specificationtitle': None, 'specificationdate': None, 'specificationdatetype': None, 'platform': None, 'instrument': None, 'sensortype': None, 'cloudcover': None, 'bands': None, 'links': '[{"name": "Web Map Tile Service (self hosted)", "description": null, "protocol": "OGC:WMTS", "url": "http://localhost:8082/?map=/etc/mapserver/PH-GSN ... (1392 characters truncated) ... 6&WIDTH=762&HEIGHT=1228&LAYERS=PH-GSNM-CLAY-2023-0-30&STYLES=&FORMAT=image%2Fpng&DPI=96&MAP_RESOLUTION=96&FORMAT_OPTIONS=dpi%3A96&TRANSPARENT=TRUE"}]', 'contacts': '[{"name": "Andrew B. Flores", "name_url": "", "organization": "Departement of Agriculture - Bureau of Soils and Water Management", "organization_url" ... (163 characters truncated) ... n", "region": null, "postcode": "1128", "country": "Philippines", "email": "andrew.flores@bswm.da.gov.ph", "onlineresource": null, "role": "author"}]', 'anytext_tsvector': None, 'wkb_geometry': None}]
# (Background on this error at: https://sqlalche.me/e/14/gkpj)
# (psycopg2.errors.UniqueViolation) duplicate key value violates unique constraint "records_pkey"
# DETAIL:  Key (identifier)=(32afbc81-ebeb-11ef-bc12-6b4a6fcd8b5e) already exists.


