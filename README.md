# GloSIS - Global Soil Information System

Here's a recommended structure for your project that will make it maintainable and easy to use:

## Project Structure

```
GloSIS/
├── docker-compose.yml          # Main composition file
├── README.md                   # Project documentation
├── .env                        # Environment variables
│
├── glosis-api/                 # API service (TODO)
│   ├── Dockerfile              # API container definition
│   ├── src/                    # Your API source code
│   └── requirements.txt        # Python/Node dependencies if applicable
│
├── glosis-db/                  # Database service (DONE)
│   ├── initdb/                 # Initialization scripts
│   │   ├── 01_schema.sql       # Database schema
│   │   └── 02_data.sql         # Sample data
│   └── pgdata/                 # Persistent data (added to .gitignore)
│
├── glosis-md/                  # GeoNetwork metadata catalog (TODO)
│   └── config/                 # Custom configuration files
│
├── glosis-wm/                  # Web mapping (DONE)
│   ├── Dockerfile              # Web mapping container definition
│   ├── src/                    # Your OpenLayers code
│   └── public/                 # Static assets
│
└── glosis-ws/                  # MapServer (DONE)
    └── data/                   # Mapfiles and data
        ├── mapfiles/           # Your .map configuration files
        └── data/               # Spatial data files
```

## Docker Compose File

Here's a sample `docker-compose.yml` that ties everything together:

```yaml
version: '3.8'

services:
  # Database Service
  db:
    image: postgis/postgis:15-3.3
    container_name: sdi_db
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - ./db/initdb:/docker-entrypoint-initdb.d
      - db_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped

  # API Service
  api:
    build: ./api
    container_name: sdi_api
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DB_NAME: ${DB_NAME}
    ports:
      - "5000:5000"
    restart: unless-stopped

  # Metadata Catalog (GeoNetwork)
  md:
    image: geonetwork:latest
    container_name: sdi_md
    depends_on:
      - db
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_PORT=5432
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=${DB_NAME}
    volumes:
      - ./md/config:/etc/geonetwork
    ports:
      - "8080:8080"
    restart: unless-stopped

  # MapServer
  ws:
    image: camptocamp/mapserver:latest
    container_name: sdi_ws
    depends_on:
      - db
    volumes:
      - ./ws/data:/mapserver_data
    ports:
      - "8081:80"
    restart: unless-stopped

  # Web Mapping (OpenLayers)
  wm:
    build: ./wm
    container_name: sdi_wm
    depends_on:
      - api
      - ws
    ports:
      - "8082:80"
    restart: unless-stopped

volumes:
  db_data:
```

## Environment File (`.env`)

Create a `.env` file in your project root:

```
DB_USER=sdi_user
DB_PASSWORD=strong_password
DB_NAME=sdi_db
```

## Implementation Steps

1. **Database Setup**:
   - Create schema and data initialization scripts in `db/initdb/`
   - These will run automatically when the container starts

2. **API Service**:
   - Create a Dockerfile in `api/` based on your tech stack (Python/Node/etc.)
   - Implement endpoints that connect to PostGIS

3. **GeoNetwork**:
   - Customize configuration in `md/config/` as needed
   - GeoNetwork will automatically connect to your PostGIS database

4. **MapServer**:
   - Place your mapfiles in `ws/data/mapfiles/`
   - Add spatial data to `ws/data/data/`

5. **Web Mapping**:
   - Build your OpenLayers application in `wm/src/`
   - Configure it to connect to your API and MapServer services

## Deployment Instructions

1. Build and start all services:
   ```bash
   docker-compose up -d --build
   ```

2. Access services:
   - API: `http://localhost:5000`
   - GeoNetwork: `http://localhost:8080`
   - MapServer: `http://localhost:8081`
   - Web Mapping: `http://localhost:8082`

## Best Practices

1. **Version Control**: Add `db/pgdata/` to your `.gitignore`
2. **Documentation**: Clearly document in README.md how to:
   - Set up the environment
   - Add new data
   - Configure services
3. **Security**: Use proper secrets management for production
4. **Monitoring**: Consider adding health checks to services
5. **Updates**: Regularly update your container images

This structure provides a clean separation of concerns, makes each component independently maintainable, and allows for easy scaling or replacement of individual services.