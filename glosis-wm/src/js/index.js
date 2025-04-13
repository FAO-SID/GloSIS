import 'ol/ol.css';
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import ImageLayer from 'ol/layer/Image';
import VectorLayer from 'ol/layer/Vector';
import OSM from 'ol/source/OSM';
import XYZ from 'ol/source/XYZ';
import ImageWMS from 'ol/source/ImageWMS';
import VectorSource from 'ol/source/Vector';
import GeoJSON from 'ol/format/GeoJSON';
import { fromLonLat } from 'ol/proj';
import { ScaleLine, defaults as defaultControls } from 'ol/control';
import { LayerSwitcher } from './layer-switcher';
import { createEmptyLayer } from './layer-utils';

// Main configuration
const config = {
  initialCenter: fromLonLat([122.5, 13.0]), // Philippines
  initialZoom: 6,
  maxZoom: 18,
  minZoom: 4
};

// Layer groups definition
const layerGroups = [
  {
    id: 'soil_profiles',
    name: 'Soil Profiles',
    expanded: false
  },
  {
    id: 'soil_nutrients',
    name: 'Soil Nutrients',
    expanded: false
  },
  {
    id: 'salt_affected_soils',
    name: 'Salt-Affected Soils',
    expanded: false
  },
  {
    id: 'organic_carbon',
    name: 'Organic Carbon Sequestration Potential',
    expanded: false
  },
  {
    id: 'base_maps',
    name: 'Base Maps',
    expanded: true
  }
];

// Layer data structure
let layerData = {
  base_maps: [],
  soil_profiles: [],
  soil_nutrients: [],
  salt_affected_soils: [],
  organic_carbon: []
};

// Selected layers tracking
let selectedLayers = {
  baseMap: null,
  contentLayer: null,
  profileLayer: null
};

// Simple CSV parser function
function parseCSV(csvText) {
  const lines = csvText.split('\n');
  const headers = lines[0].split(',');
  
  return lines.slice(1).filter(line => line.trim() !== '').map(line => {
    const values = line.split(',');
    const record = {};
    
    headers.forEach((header, index) => {
      record[header] = values[index];
    });
    
    return record;
  });
}

// Initialize the map
const initMap = () => {
  // Create basemap layers
  const osmLayer = new TileLayer({
    source: new OSM(),
    title: 'OpenStreetMap',
    type: 'base',
    visible: true,
    group: 'base_maps'
  });
  
  const esriImageryLayer = new TileLayer({
    source: new XYZ({
      url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      attributions: 'Tiles © Esri'
    }),
    title: 'ESRI Imagery Map',
    type: 'base',
    visible: false,
    group: 'base_maps'
  });
  
  const terrainLayer = new TileLayer({
    source: new XYZ({
      url: 'https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=6170aad10dfd42a38d4d8c709a536f38',
      attributions: 'Maps © Thunderforest'
    }),
    title: 'Open Terrain Map',
    type: 'base',
    visible: false,
    group: 'base_maps'
  });
  
  // Add base layers to layer data
  layerData.base_maps = [esriImageryLayer, osmLayer, terrainLayer];
  selectedLayers.baseMap = osmLayer;
  
  // Create the map
  const map = new Map({
    target: 'map',
    layers: [osmLayer, esriImageryLayer, terrainLayer],
    view: new View({
      center: config.initialCenter,
      zoom: config.initialZoom,
      maxZoom: config.maxZoom,
      minZoom: config.minZoom
    }),
    controls: defaultControls({
      zoom: false, // We'll add custom zoom controls
      attribution: true,
      rotate: false
    })
  });
  
  // Set up zoom controls
  document.getElementById('zoom-in').addEventListener('click', () => {
    const view = map.getView();
    const zoom = view.getZoom();
    view.animate({
      zoom: zoom + 1,
      duration: 250
    });
  });
  
  document.getElementById('zoom-out').addEventListener('click', () => {
    const view = map.getView();
    const zoom = view.getZoom();
    view.animate({
      zoom: zoom - 1,
      duration: 250
    });
  });
  
  // Set up layer panel toggling
  const layerPanel = document.getElementById('layer-switcher');
  const collapseBtn = document.getElementById('collapse-btn');
  
  collapseBtn.addEventListener('click', () => {
    layerPanel.classList.toggle('collapsed');
    if (layerPanel.classList.contains('collapsed')) {
      collapseBtn.innerHTML = '&#9654;';  // Right arrow
    } else {
      collapseBtn.innerHTML = '&#9664;';  // Left arrow
    }
  });
  
  return map;
};

// Load layer info from CSV
const loadLayerInfo = async () => {
  try {
    // Note: We no longer create sample layers here since they're created in initApp
    
    const response = await fetch('./layer_info.csv');
    if (!response.ok) {
      throw new Error(`Failed to fetch layer_info.csv: ${response.status} ${response.statusText}`);
    }
    
    const csvText = await response.text();
    console.log("CSV Text loaded:", csvText.substring(0, 100) + "...");
    
    // Parse CSV using our simple parser
    const records = parseCSV(csvText);
    console.log("Parsed records:", records.length);
    
    if (records.length === 0) {
      throw new Error("No records found in the CSV file");
    }
    
    // Process the records
    records.forEach(record => {
      const layer = createLayerFromRecord(record);
      if (layer) {
        const groupId = getGroupId(record.project_name);
        if (groupId && layerData[groupId]) {
          layerData[groupId].push(layer);
        }
      }
    });
    
    return true;
  } catch (error) {
    console.error('Error loading layer info:', error);
    return false;
  }
};

// Create sample layers for testing
const createSampleLayers = () => {
  // Sample soil profiles layer
  const soilProfilesLayer = new VectorLayer({
    source: new VectorSource(),
    title: 'Sample Soil Profiles',
    visible: true,
    properties: {
      property_name: 'Soil profiles',
      property_id: 'profiles',
      metadata_url: '#',
      download_url: '#'
    }
  });
  layerData.soil_profiles.push(soilProfilesLayer);
  
  // Sample soil nutrients layer - Using a different source for better visibility
  const soilNutrientsLayer = new TileLayer({
    source: new XYZ({
      url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
      attributions: 'Tiles © Esri'
    }),
    title: 'Sample Soil Nutrients',
    visible: true,
    opacity: 0.7,
    properties: {
      property_name: 'Bulk density',
      property_id: 'BKD',
      unit_id: 'g/cm3',
      dimension_des: '0-30',
      metadata_url: '#',
      download_url: '#'
    }
  });
  layerData.soil_nutrients.push(soilNutrientsLayer);
  
  // Sample salt-affected soils layer - Using a different source for better visibility
  const saltAffectedLayer = new TileLayer({
    source: new XYZ({
      url: 'https://server.arcgisonline.com/ArcGIS/rest/services/Ocean/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}',
      attributions: 'Tiles © Esri'
    }),
    title: 'Sample Salt-Affected Soils',
    visible: false,
    opacity: 0.7,
    properties: {
      property_name: 'Electrical conductivity',
      property_id: 'ECX',
      unit_id: 'dS m-1',
      dimension_des: '0-30',
      metadata_url: '#',
      download_url: '#'
    }
  });
  layerData.salt_affected_soils.push(saltAffectedLayer);
  
  // Sample organic carbon layer - Using a different source for better visibility
  const organicCarbonLayer = new TileLayer({
    source: new XYZ({
      url: 'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}',
      attributions: 'Tiles © Esri'
    }),
    title: 'Sample Organic Carbon',
    visible: false,
    opacity: 0.7,
    properties: {
      property_name: 'Organic Carbon Sequestration Potential',
      property_id: 'CORGADBAU',
      unit_id: 'tonnes C ha-1 yr-1',
      dimension_des: '0-30',
      metadata_url: '#',
      download_url: '#'
    }
  });
  layerData.organic_carbon.push(organicCarbonLayer);
};

// Create a layer from CSV record
const createLayerFromRecord = (record) => {
  if (!record || !record.layer_id) return null;
  
  console.log("Creating layer from record:", record.layer_id, record.project_name);
  
  // For soil profiles (points)
  if (record.project_name === 'Soil Profiles') {
    return new VectorLayer({
      source: new VectorSource({
        url: record.get_map_url,
        format: new GeoJSON()
      }),
      title: record.layer_id,
      visible: false,
      properties: {
        property_name: record.property_name,
        property_id: record.property_id,
        unit_id: record.unit_id,
        dimension_des: record.dimension_des,
        metadata_url: record.metadata_url,
        download_url: record.download_url,
        legendUrl: record.get_legend_url,
        getFeatureInfoUrl: record.get_feature_info_url
      }
    });
  } 
  // For all other WMS layers
  else {
    const wmsUrl = record.get_map_url.split('?')[0];
    console.log("WMS URL:", wmsUrl);
    
    return new ImageLayer({
      source: new ImageWMS({
        url: wmsUrl,
        params: {
          'LAYERS': record.layer_id,
          'FORMAT': 'image/png',
          'TRANSPARENT': true
        },
        ratio: 1,
        serverType: 'mapserver'
      }),
      title: record.layer_id,
      visible: false,
      properties: {
        property_name: record.property_name,
        property_id: record.property_id,
        unit_id: record.unit_id,
        dimension_des: record.dimension_des,
        metadata_url: record.metadata_url,
        download_url: record.download_url,
        legendUrl: record.get_legend_url,
        getFeatureInfoUrl: record.get_feature_info_url
      }
    });
  }
};

// Get group ID from project name
const getGroupId = (projectName) => {
  switch (projectName) {
    case 'Soil Profiles': return 'soil_profiles';
    case 'Soil Nutrients': return 'soil_nutrients';
    case 'Salt-Affected Soils': return 'salt_affected_soils';
    case 'Organic Carbon Sequestration Potential': return 'organic_carbon';
    default: return null;
  }
};

// Initialize layer switcher
const initLayerSwitcher = (map) => {
  const layerSwitcher = new LayerSwitcher({
    map: map,
    layerGroups: layerGroups,
    layerData: layerData,
    selectedLayers: selectedLayers,
    target: document.getElementById('layer-groups')
  });
  
  // Initialize opacity slider
  const opacitySlider = document.getElementById('opacity-slider');
  opacitySlider.addEventListener('input', (e) => {
    const opacity = parseFloat(e.target.value);
    
    // Apply opacity to selected content layer
    if (selectedLayers.contentLayer) {
      selectedLayers.contentLayer.setOpacity(opacity);
    }
    
    // Apply opacity to selected profile layer
    if (selectedLayers.profileLayer) {
      selectedLayers.profileLayer.setOpacity(opacity);
    }
  });
  
  return layerSwitcher;
};

// Main application initialization
const initApp = async () => {
  // Create sample layers first
  createSampleLayers();
  
  // Initialize map with the layers
  const map = initMap();
  
  // Load layer information from CSV
  const layersLoaded = await loadLayerInfo();
  if (!layersLoaded) {
    console.warn('Failed to load layer information from CSV, using sample layers only');
  }
  
  // Initialize layer switcher
  const layerSwitcher = initLayerSwitcher(map);
  
  // Make sure all layers are added to the map (including sample layers)
  Object.values(layerData).flat().forEach(layer => {
    if (!map.getLayers().getArray().includes(layer)) {
      console.log('Adding layer to map:', layer.get('title'));
      map.addLayer(layer);
    }
  });
  
  // Ensure at least the soil nutrients layer is shown by default
  const soilNutrientsLayers = layerData.soil_nutrients || [];
  if (soilNutrientsLayers.length > 0) {
    soilNutrientsLayers[0].setVisible(true);
    selectedLayers.contentLayer = soilNutrientsLayers[0];
  }
  
  // Debug output
  console.log('Available layers:', Object.values(layerData).flat().map(l => l.get('title')));
};

// Start the application
document.addEventListener('DOMContentLoaded', initApp); 