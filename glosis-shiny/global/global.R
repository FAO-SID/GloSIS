options(shiny.maxRequestSize = 100*1024^2)  # 100MB

# Load packages
lapply(c("shiny","shinydashboard","shinycssloaders","RPostgres","DBI","DT","shinyjs","readxl","dplyr", "jsonlite", "digest", "utils","tidyr"), library, character.only = TRUE)

# Load PostgreSQL credentials
source("credentials.R")
source("fill_tables.R") 
# Define the path to the SQL file
#sql_file_path <- file.path("/srv/shiny-server/init-scripts/ISO_28258_v_stable.sql")
#sql_file_path <- file.path("../../init-scripts/glosis-db_latest.sql")
sql_file_path <- file.path("/srv/shiny-server/init-scripts/glosis-db_latest.sql")

# Function to create tables in the database
createTables <- function(database_name, host_name, port_number, user_name, password_name) {
  


  # Download the SQL file
  message("Downloading SQL file...")
  tryCatch({
    download.file(sql_file_url, destfile = sql_file_path, mode = "wb")
    message("SQL file downloaded successfully.")
  }, error = function(e) {
    message("Error downloading SQL file: ", e$message)
    return(FALSE) # Exit early if download fails
  })
  

  # Connect to the database (postgres) to manage roles
  con <- tryCatch({
    message("Connecting to Database...")
    dbConnect(RPostgres::Postgres(),
              dbname = "postgres",
              host = host_name,
              port = port_number,
              user = user_name,
              password = password_name)
  }, error = function(cond) {
    message("Unable to connect to the database.")
    return(NULL)
  })
  
  if (is.null(con)) {
    return(FALSE)
  }
  
  # Ensure the role 'glosis' exists
  tryCatch({
    dbExecute(con, "DO $$ BEGIN
      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'glosis') THEN
        CREATE ROLE glosis LOGIN PASSWORD 'glosis';
      END IF;
    END $$;")
    message("Role 'glosis' ensured.")
  }, error = function(e) {
    message("Error creating role 'glosis': ", e$message)
    dbDisconnect(con)
    return(FALSE)
  })
  
  # Ensure the role 'glosis_r' exists
  tryCatch({
    dbExecute(con, "DO $$ BEGIN
      IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'glosis_r') THEN
        CREATE ROLE glosis_r LOGIN PASSWORD 'glosis';
      END IF;
    END $$;")
    message("Role 'glosis_r' ensured.")
  }, error = function(e) {
    message("Error creating role 'glosis_r': ", e$message)
    dbDisconnect(con)
    return(FALSE)
  })
  
  dbDisconnect(con)
  
  # Now connect to the target database and execute the SQL file
  psql_command <- sprintf(
    "PGPASSWORD=%s psql -U %s -h %s -p %s -d %s -f %s",
    password_name,
    user_name,
    host_name,
    as.character(port_number),
    database_name,
    sql_file_path
  )
  
  tryCatch({
    message("Executing SQL file...")
    system(psql_command, intern = TRUE, ignore.stdout = FALSE, ignore.stderr = FALSE)
    message("Database tables created successfully.")
  }, error = function(e) {
    message("Error executing SQL file: ", e$message)
    return(FALSE)
  })
  
  return(TRUE)
}

# Function to create and connect to a database
createDatabase <- function(database_name, host_name, port_number, user_name, password_name) {

  # Connect to the default "postgres" database
  con <- tryCatch({
    dbConnect(RPostgres::Postgres(),
              dbname = "postgres",
              host = host_name,
              port = port_number,
              user = user_name,
              password = password_name)
  }, error = function(e) {
    message("Unable to connect to the database server: ", e$message)
    return(NULL)
  })
  
  if (is.null(con)) {
    return(list(con = NULL, message = "Failed to connect to the PostgreSQL server."))
  }
  
  # Check if the database exists
  dbExists <- dbGetQuery(con, sprintf("SELECT 1 FROM pg_database WHERE datname = '%s'", database_name))
  
  messageContent <- "" # Initialize status message
  backgroundColor <- "" # Initialize background color
  backgroundBorder <- "" # Initialize background border
  
  if (nrow(dbExists) == 0) {
    # Create the database if it doesn't exist
    dbCreateStatement <- sprintf("CREATE DATABASE \"%s\";", database_name)
    tryCatch({
      dbExecute(con, dbCreateStatement)
      message(sprintf("Database '%s' created successfully.", database_name))
      messageContent <- sprintf("Database '%s' created", database_name)
      backgroundColor <- "darkorange"
      backgroundBorder <- "yellow"
    }, error = function(e) {
      message("Error creating database: ", e$message)
      dbDisconnect(con)
      return(list(con = NULL, message = sprintf("Error creating database '%s'.", database_name)))
    })
  } else {
    message(sprintf("The database '%s' already exists.", database_name))
    messageContent <- sprintf("The database '%s' already exists", database_name)
    backgroundColor <- "dodgerblue"
    backgroundBorder <- "white"
  }
  
  # Disconnect from the "postgres" database
  dbDisconnect(con)
  
  # Connect to the new database
  newCon <- tryCatch({
    dbConnect(RPostgres::Postgres(),
              dbname = database_name,
              host = host_name,
              port = port_number,
              user = user_name,
              password = password_name)
  }, error = function(e) {
    message("Unable to connect to the new database: ", e$message)
    return(NULL)
  })
  
  if (is.null(newCon)) {
    return(list(con = NULL, message = sprintf("Failed to connect to the database '%s'.", database_name)))
  }
  
  # Create tables in the new database
  tryCatch({
    createTables(database_name, host_name, port_number, user_name, password_name)
    message("Tables created or verified successfully.")
  }, error = function(e) {
    message("Error creating tables: ", e$message)
    return(list(con = newCon, message = "Failed to create tables."))
  })
  
  return(list(con = newCon, message = messageContent, backcolor = backgroundColor, backborder = backgroundBorder))
}


plot_table.names <- c("project_name","site_code","plot_code","profile_code",
                             "plot_type","n_layers","date","longitude","latitude","altitude","positional_accuracy","extent","map_sheet_code",
                             "TemperatureRegime","MoistureRegime","KoeppenClass","CurrentWeatherConditions","PastWeatherConditions",
                             "Landuse","Vegetation","Croptype","BareSoilAbundance","TreeDensity","ForestAbundance",
                             "GrassAbundance","ShrubAbundace","HumanInfluence","PavedAbundance",
                             "SurfaceAge","ParentMaterialClass","Lithology","MajorLandForm",
                             "ComplexLandform","Position","SlopeForm","SlopeGradient",
                             "SlopeOrientation","SlopePathway","RockOutcropsCover","RockOutcropsDistance",
                             "FragmentsCover","FragmentsSize","ErosionClass","ErosionDegree",
                             "ErosionAreaAffected","ErosionActivityPeriod","SealingThickness","SealingConsistence" ,      
                             "CracksWidth","CracksDepth","CracksDistance","SaltCover",           
                             "SaltThickness","BleachedSandCover","PresenceOfWater","MoistureConditions",    
                             "DrainageClass","ExternalDrainageClass","GroundwaterDepth","GroundwaterQuality",       
                             "FloodDuration","FloodFrequency") 
profile_table.names <- c("profile_code","descriptionStatus","soilGroupWRB","soilClassificationWRB","SoilSpecifierWRB","SupplementaryQualifierWRB","soilPhase","soilOrderUSDA","soilSuborderUSDA","formativeElementUSDA","SoilDepthtoBedrock","EffectiveSoilDepth")

element_table.names  <- c("profile_code","element_code","type","order_element","upper_depth","lower_depth",               
                                 "horizon_code","BoundaryDistinctness","BoundaryTopography",             
                                 "SoilTexture","SandfractionTexture","FieldTexture",                    
                                 "Rockabundance","Rocksize","RockShape",
                                 "Rockweathering","RockPrimary","RockNature",
                                 "PeaDescomposition","AeromorphicForest","ColourMoist",
                                 "ColourDry","MottlesColour","MottlesAbundance",
                                 "MottlesSize","MottlesContrast","MottlesBoundary",
                                 "RedoxPotential","ReducingConditions","CarbonateContent",
                                 "CarbonateForms","GypsumContent","GypsumForms",
                                 "SaltContent","FieldPH","SoilOdour",
                                 "AndicCharacteristics","OrganicMatter","StructureGrade",
                                 "StructureType","StructureSize","ConsistenceDry",
                                 "ConsistenceMoist","ConsistenceWet","Stickiness",                       
                                 "Plasticity","Moisture","BulkDensity",
                                 "PeatDrainage","PeatVolume","PeatBulkDensity",
                                 "PorosityAbundance","PorosityType","PorositySize",
                                 "PoreAbundance","CoatingsAbundance","CoatingsContrast",
                                 "CoatingsNature","CoatingsForm","CoatingsLocation",
                                 "Cementation/compactionContinuity","Cementation/compactionStructure","Cementation/compactionNature",
                                 "Cementation/compactionDegree","MineralConcentrationsAbundance","MineralConcentrationsKind",
                                 "MineralConcentrationsSize","MineralConcentrationsShape","MineralConcentrationsHardness",
                                 "MineralConcentrationsNature","MineralConcentrationsColour","RootsSize",
                                 "RootsAbundance","BiologicalAbundance","BiologicalKind",
                                 "ArtefactAbundance","ArtefactKind","ArtefactSize",
                                 "ArtefactHardness","ArtefactWeathering","ArtefactColour")
