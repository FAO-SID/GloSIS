# Set working directory
$PROJECT_DIR = "C:\Users\luis\Desktop\GloSIS-main"

# Navigate to the project folder
Set-Location "$PROJECT_DIR"


####################
#      Docker      #
####################

# Clean up Docker
docker ps -q | ForEach-Object { docker stop $_ }
docker ps -aq | ForEach-Object { docker rm $_ }
docker images -q | ForEach-Object { docker rmi $_ -f }
docker network prune -f
docker volume prune -f
docker system prune -a --volumes -f

# Remove old DB volume content
Remove-Item -Path "$PROJECT_DIR/glosis-db/volume/*" -Recurse -Force -ErrorAction SilentlyContinue


####################
#     glosis-db    #
####################

# Build and run glosis-db container
docker compose up --build glosis-db -d

# Wait for the PostgreSQL server to be ready
Write-Host "Waiting for glosis-db PostgreSQL to start..."
while ($true) {
    $readyCheck = docker exec glosis-db pg_isready -U glosis -d glosis 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "glosis-db PostgreSQL is ready."
        break
    }
    Start-Sleep -Seconds 1
}

# Copy SQL scripts to glosis-db container
docker cp "$PROJECT_DIR\glosis-db\initdb\init-01.sql" glosis-db:/tmp/init-01.sql
docker cp "$PROJECT_DIR\glosis-db\versions\glosis-db_latest.sql" glosis-db:/tmp/init-02.sql
docker cp "$PROJECT_DIR\glosis-db\initdb\init-03.sql" glosis-db:/tmp/init-03.sql

# Execute SQL scripts inside the container
Start-Sleep -Seconds 10
docker exec -i glosis-db psql -d glosis -U glosis -f /tmp/init-01.sql
docker exec -i glosis-db psql -d glosis -U glosis -f /tmp/init-02.sql
docker exec -i glosis-db psql -d glosis -U glosis -f /tmp/init-03.sql


####################
#      Docker      #
####################

# Build and start Docker shiny containers
docker compose up --build glosis-shiny -d
# update Global.R script to glosis-db container
docker cp "$PROJECT_DIR\glosis-shiny\global\global.R" glosis-shiny:/srv/shiny-server/iso28258/global.R

# Build and start other Docker containers
docker compose up --build glosis-wm -d
docker compose up --build glosis-ws -d
docker compose up --build glosis-md -d


####################
#     glosis-md    #
####################

# Load records
docker-compose exec glosis-md ls -l /records
docker-compose exec glosis-md pycsw-admin.py load-records -c /etc/pycsw/pycsw.yml -p /records -r -y

# Verify records loaded
docker-compose exec glosis-db psql -U glosis -d glosis -c "SELECT identifier, title FROM pycsw.records ORDER BY title LIMIT 5;"

# Customize pyCSW UI
docker-compose exec glosis-md sed -i 's/pycsw website/Philippines SIS metadata/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org\/img\/pycsw-logo-vertical.png/https:\/\/www.bswm.da.gov.ph\/wp-content\/uploads\/BAGONG-PILIPINAS.png/g' pycsw/pycsw/ogc/api/templates/_base.html
docker-compose exec glosis-md sed -i 's/https:\/\/pycsw.org/http:\/\/localhost:8001\/collections\/metadata:main\/items/g' pycsw/pycsw/ogc/api/templates/_base.html

