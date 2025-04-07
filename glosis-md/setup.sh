#!/bin/bash
# https://docs.pycsw.org/en/latest/docker.html
# https://github.com/geopython/pycsw/blob/master/docker/compose/docker-compose.scale.yml


cd ~/Work/Code/FAO/GloSIS/glosis-md
mkdir records
cp /home/carva014/Downloads/FAO/SIS/PH/Processed/*.xml /home/carva014/Work/Code/FAO/GloSIS/glosis-md/records
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
docker-compose exec pycsw pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# /home/pycsw/pycsw/pycsw/core/repository.py:131: SAWarning: Did not recognize type 'geometry' of column 'wkb_geometry'
#   self.dataset = type(
# Traceback (most recent call last):
#   File "/home/pycsw/pycsw/pycsw/core/admin.py", line 82, in load_records
#     metadata_record = json.load(fh)
#   File "/usr/local/lib/python3.10/json/__init__.py", line 293, in load
#     return loads(fp.read(),
#   File "/usr/local/lib/python3.10/json/__init__.py", line 346, in loads
#     return _default_decoder.decode(s)
#   File "/usr/local/lib/python3.10/json/decoder.py", line 337, in decode
#     obj, end = self.raw_decode(s, idx=_w(s, 0).end())
#   File "/usr/local/lib/python3.10/json/decoder.py", line 355, in raw_decode
#     raise JSONDecodeError("Expecting value", s, err.value) from None
# json.decoder.JSONDecodeError: Expecting value: line 1 column 1 (char 0)

# During handling of the above exception, another exception occurred:

# Traceback (most recent call last):
#   File "/usr/local/bin/pycsw-admin.py", line 33, in <module>
#     sys.exit(load_entry_point('pycsw', 'console_scripts', 'pycsw-admin.py')())
#   File "/usr/local/lib/python3.10/site-packages/click/core.py", line 1161, in __call__
#     return self.main(*args, **kwargs)
#   File "/usr/local/lib/python3.10/site-packages/click/core.py", line 1082, in main
#     rv = self.invoke(ctx)
#   File "/usr/local/lib/python3.10/site-packages/click/core.py", line 1697, in invoke
#     return _process_result(sub_ctx.command.invoke(sub_ctx))
#   File "/usr/local/lib/python3.10/site-packages/click/core.py", line 1443, in invoke
#     return ctx.invoke(self.callback, **ctx.params)
#   File "/usr/local/lib/python3.10/site-packages/click/core.py", line 788, in invoke
#     return __callback(*args, **kwargs)
#   File "/usr/local/lib/python3.10/site-packages/click/decorators.py", line 33, in new_func
#     return f(get_current_context(), *args, **kwargs)
#   File "/home/pycsw/pycsw/pycsw/core/admin.py", line 430, in cli_load_records
#     load_records(
#   File "/home/pycsw/pycsw/pycsw/core/admin.py", line 84, in load_records
#     metadata_record = etree.parse(recfile, context.parser)
#   File "src/lxml/etree.pyx", line 3590, in lxml.etree.parse
#   File "src/lxml/parser.pxi", line 1958, in lxml.etree._parseDocument
#   File "src/lxml/parser.pxi", line 1984, in lxml.etree._parseDocumentFromURL
#   File "src/lxml/parser.pxi", line 1887, in lxml.etree._parseDocFromFile
#   File "src/lxml/parser.pxi", line 1200, in lxml.etree._BaseParser._parseDocFromFile
#   File "src/lxml/parser.pxi", line 633, in lxml.etree._ParserContext._handleParseResultDoc
#   File "src/lxml/parser.pxi", line 743, in lxml.etree._handleParseResult
#   File "src/lxml/parser.pxi", line 672, in lxml.etree._raiseParseError
#   File "/records/PH-GSNM-PHX-2023.xml", line 129
# lxml.etree.XMLSyntaxError: StartTag: invalid element name, line 129, column 135

# verify if records were loaded
docker-compose exec pycsw-db psql -U glosis -d pycsw -c "\dt"
curl "http://localhost:8001/csw?service=CSW&version=2.0.2&request=GetRecords&typenames=csw:Record&resulttype=hits&elementsetname=full"






