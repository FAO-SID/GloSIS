// Import OpenLayers styles
import 'ol/ol.css';

// Import OpenLayers modules
import {Map, View} from 'ol';
import TileLayer from 'ol/layer/Tile';
import OSM from 'ol/source/OSM';
import ImageLayer from 'ol/layer/Image';
import ImageWMS from 'ol/source/ImageWMS';
import LayerSwitcher from 'ol-layerswitcher';
import 'ol-layerswitcher/dist/ol-layerswitcher.css';
import {defaults as defaultControls} from 'ol/control';
import LayerGroup from 'ol/layer/Group';
import Overlay from 'ol/Overlay';
import { transform, transformExtent } from 'ol/proj';
import { register } from 'ol/proj/proj4';
import proj4 from 'proj4';
import { Control } from 'ol/control';

// Register EPSG:32651 (UTM zone 51N) projection
proj4.defs('EPSG:32651', '+proj=utm +zone=51 +datum=WGS84 +units=m +no_defs');
register(proj4);

// Create base layer
const osmLayer = new TileLayer({
  source: new OSM(),
  title: 'OpenStreetMap',
  type: 'base',
  visible: true
});

// Create Open TopoMap layer
const topoLayer = new TileLayer({
  source: new OSM({
    url: 'https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png',
    attributions: '© OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap (CC-BY-SA)'
  }),
  title: 'Open TopoMap',
  type: 'base',
  visible: false
});

// Create ESRI World Imagery layer
const esriImageryLayer = new TileLayer({
  source: new OSM({
    url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    attributions: '© Esri, Maxar, Earthstar Geographics, CNES/Airbus DS, USDA FSA, USGS, Aerogrid, IGN, and the GIS User Community'
  }),
  title: 'ESRI World Imagery',
  type: 'base',
  visible: false
});

// Create NASA Blue Marble layer
const nasaBlueMarbleLayer = new TileLayer({
  source: new OSM({
    url: 'https://gibs.earthdata.nasa.gov/wmts/epsg3857/best/BlueMarble_ShadedRelief_Bathymetry/default/{Time}/{TileMatrixSet}/{z}/{y}/{x}.jpg',
    attributions: '© NASA Blue Marble, Next Generation'
  }),
  title: 'NASA Blue Marble',
  type: 'base',
  visible: false
});

// Create WMS sources for all layers
const clayWMSSource = new ImageWMS({
  url: 'http://localhost:8082/',
  params: {
    'MAP': '/etc/mapserver/PH-GSNM-CLAY-2023-0-30.map',
    'LAYERS': 'PH-GSNM-CLAY-2023-0-30',
    'TRANSPARENT': true,
    'FORMAT': 'image/png'
  },
  ratio: 1,
  serverType: 'mapserver'
});

const ecWMSSource = new ImageWMS({
  url: 'http://localhost:8082/',
  params: {
    'MAP': '/etc/mapserver/PH-GSAS-ECX-2020-0-30.map',
    'LAYERS': 'PH-GSAS-ECX-2020-0-30',
    'TRANSPARENT': true,
    'FORMAT': 'image/png'
  },
  ratio: 1,
  serverType: 'mapserver'
});

const phWMSSource = new ImageWMS({
  url: 'http://localhost:8082/',
  params: {
    'MAP': '/etc/mapserver/PH-GSAS-PHX-2020-0-30.map',
    'LAYERS': 'PH-GSAS-PHX-2020-0-30',
    'TRANSPARENT': true,
    'FORMAT': 'image/png'
  },
  ratio: 1,
  serverType: 'mapserver'
});

const gsocWMSSource = new ImageWMS({
  url: 'http://localhost:8082/',
  params: {
    'MAP': '/etc/mapserver/GSOC.map',
    'LAYERS': 'GSOC',
    'TRANSPARENT': true,
    'FORMAT': 'image/png'
  },
  ratio: 1,
  serverType: 'mapserver'
});

// Create layers
const clayLayer = new ImageLayer({
  source: clayWMSSource,
  title: 'Clay Content 0-30cm (2023)',
  visible: true
});

const ecLayer = new ImageLayer({
  source: ecWMSSource,
  title: 'Electrical Conductivity 0-30cm (2020)',
  visible: false
});

const phLayer = new ImageLayer({
  source: phWMSSource,
  title: 'pH 0-30cm (2020)',
  visible: false
});

const gsocLayer = new ImageLayer({
  source: gsocWMSSource,
  title: 'Global Soil Organic Carbon',
  visible: false
});

// Create layer groups
const baseLayerGroup = new LayerGroup({
  title: 'Base Maps',
  fold: 'open',
  layers: [esriImageryLayer, topoLayer, osmLayer ]
});

// Create opacity control class
class OpacityControl extends Control {
  constructor() {
    const element = document.createElement('div');
    element.className = 'ol-opacity-control ol-unselectable ol-control';
    
    const slider = document.createElement('input');
    slider.type = 'range';
    slider.min = '0';
    slider.max = '100';
    slider.value = '100';
    slider.className = 'opacity-slider';
    
    const label = document.createElement('span');
    label.textContent = 'Opacity: ';
    label.className = 'opacity-label';
    
    element.appendChild(label);
    element.appendChild(slider);
    
    super({
      element: element
    });
    
    this.slider = slider;
  }
}

const soilLayerGroup = new LayerGroup({
  title: 'Soil Properties',
  fold: 'open',
  layers: [clayLayer, ecLayer, phLayer, gsocLayer]
});

// Create layer switcher
const layerSwitcher = new LayerSwitcher({
  tipLabel: 'Layers',
  reverse: true,
  groupSelectStyle: 'children'
});

// Create opacity control
const opacityControl = new OpacityControl();

// Create the map with all controls
const map = new Map({
  target: 'map',
  layers: [baseLayerGroup, soilLayerGroup],
  view: new View({
    center: [13420489, 1202490],
    zoom: 6,
    projection: 'EPSG:3857'
  }),
  controls: defaultControls().extend([
    layerSwitcher,
    opacityControl
  ])
});

// Add opacity control functionality
opacityControl.slider.addEventListener('input', function() {
  const opacity = parseFloat(this.value) / 100;
  soilLayerGroup.getLayers().forEach(layer => {
    layer.setOpacity(opacity);
  });
});

// Create popup overlay
const popup = new Overlay({
  element: document.createElement('div'),
  positioning: 'bottom-center',
  offset: [0, -10],
  stopEvent: false
});

popup.getElement().className = 'pixel-popup';
map.addOverlay(popup);

// Add styles
const styles = `
  .ol-opacity-control {
    top: 85px;
    left: 8px;
    background-color: rgba(255,255,255,0.8);
    padding: 5px;
    border-radius: 4px;
    box-shadow: 0 1px 5px rgba(0,0,0,0.2);
  }
  .opacity-slider {
    width: 100px;
    margin: 0 5px;
    vertical-align: middle;
  }
  .opacity-label {
    font-size: 12px;
    color: #333;
  }
  .pixel-popup {
    position: absolute;
    background-color: white;
    padding: 8px 12px;
    border-radius: 4px;
    border: 1px solid #cccccc;
    font-size: 13px;
    z-index: 1000;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    white-space: nowrap;
    pointer-events: auto;
  }
  .pixel-popup .close-button {
    position: absolute;
    top: 2px;
    right: 2px;
    padding: 0;
    width: 16px;
    height: 16px;
    font-size: 14px;
    font-weight: bold;
    line-height: 14px;
    border: none;
    background: transparent;
    color: #999;
    cursor: pointer;
  }
  .pixel-popup .close-button:hover {
    color: #666;
  }
  .pixel-popup .info-row {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    line-height: 1.6;
    margin-top: 2px;
  }
  .pixel-popup .label {
    color: #000;
    font-weight: normal;
  }
  .pixel-popup .value {
    font-weight: bold;
  }
  .map-legend {
    position: absolute;
    bottom: 20px;
    right: 10px;
    background-color: white;
    box-shadow: 0 1px 5px rgba(0,0,0,0.4);
    border-radius: 4px;
    padding: 10px;
    z-index: 1000;
    min-width: 150px;
  }
  .legend-title {
    font-weight: bold;
    margin-bottom: 8px;
  }
  .legend-image {
    display: block;
    max-width: 100%;
  }
`;

// Add styles to document
const styleSheet = document.createElement('style');
styleSheet.textContent = styles;
document.head.appendChild(styleSheet);

// Function to get the active layer name
function getActiveLayerName() {
  const layers = [
    { layer: clayLayer, name: 'PH-GSNM-CLAY-2023-0-30' },
    { layer: ecLayer, name: 'PH-GSAS-ECX-2020-0-30' },
    { layer: phLayer, name: 'PH-GSAS-PHX-2020-0-30' },
    { layer: gsocLayer, name: 'GSOC' }
  ];
  
  const activeLayer = layers.find(l => l.layer.getVisible());
  console.log('Active layer:', activeLayer); // Debug log
  return activeLayer ? activeLayer.name : null;
}

// Function to get proper formatting for each layer
function formatLayerValue(layerName, value) {
  switch (layerName) {
    case 'PH-GSNM-CLAY-2023-0-30':
      return {
        label: 'Clay Content:',
        value: `${value.toFixed(1)}%`
      };
    case 'PH-GSAS-ECX-2020-0-30':
      return {
        label: 'El. Conductivity:',
        value: `${value.toFixed(2)} dS/m`
      };
    case 'PH-GSAS-PHX-2020-0-30':
      return {
        label: 'pH:',
        value: value.toFixed(1)
      };
    case 'GSOC':
      return {
        label: 'Soil Org. Carbon:',
        value: `${value.toFixed(1)} t/ha`
      };
    default:
      return {
        label: 'Value:',
        value: value.toFixed(1)
      };
  }
}

// Replace the pointermove handler with a click handler
map.on('singleclick', function(evt) {
  const activeLayerName = getActiveLayerName();
  if (!activeLayerName) {
    popup.setPosition(undefined);
    return;
  }

  const coordinate = evt.coordinate;
  const pixel = evt.pixel;
  const [lon, lat] = transform(coordinate, 'EPSG:3857', 'EPSG:4326');

  // Get the correct layer name for the WMS request
  let queryLayerName = activeLayerName;  // Use the same name for all layers

  // Construct GetFeatureInfo URL
  const url = new URL('http://localhost:8082/');
  const params = new URLSearchParams({
    map: `/etc/mapserver/${activeLayerName}.map`,
    SERVICE: 'WMS',
    VERSION: '1.3.0',
    REQUEST: 'GetFeatureInfo',
    LAYERS: queryLayerName,
    QUERY_LAYERS: queryLayerName,
    INFO_FORMAT: 'application/vnd.ogc.gml',
    I: Math.round(pixel[0]),
    J: Math.round(pixel[1]),
    CRS: 'EPSG:4326',
    STYLES: '',
    FORMAT: 'image/png',
    WIDTH: map.getSize()[0].toString(),
    HEIGHT: map.getSize()[1].toString(),
    FEATURE_COUNT: 1
  });

  // Add bbox parameter
  const mapSize = map.getSize();
  const extent = map.getView().calculateExtent(mapSize);
  const transformedExtent = transformExtent(extent, 'EPSG:3857', 'EPSG:4326');
  const bbox = [
    transformedExtent[1],
    transformedExtent[0],
    transformedExtent[3],
    transformedExtent[2]
  ].join(',');
  params.append('BBOX', bbox);

  const requestUrl = url.toString() + '?' + params.toString();
  
  fetch(requestUrl)
    .then(response => response.text())
    .then(text => {
      try {
        if (text.includes('ServiceException')) {
          popup.setPosition(undefined);
          return;
        }
        
        if (text.includes('value_list')) {
          const valueMatch = text.match(/<value_list>([^<]+)<\/value_list>/);
          if (valueMatch && valueMatch[1]) {
            const value = parseFloat(valueMatch[1]);
            if (!isNaN(value)) {
              const formattedValue = formatLayerValue(queryLayerName, value);
              popup.getElement().innerHTML = `
                <button class="close-button">&times;</button>
                <div class="info-row">
                  <span class="label">${formattedValue.label}</span><span class="value">${formattedValue.value}</span>
                </div>
                <div class="info-row">
                  <span class="label">Lon:</span><span class="value">${lon.toFixed(6)}</span>
                </div>
                <div class="info-row">
                  <span class="label">Lat:</span><span class="value">${lat.toFixed(6)}</span>
                </div>
              `;
              
              // Add click handler to close button
              const closeButton = popup.getElement().querySelector('.close-button');
              if (closeButton) {
                closeButton.addEventListener('click', () => {
                  popup.setPosition(undefined);
                });
              }
              
              popup.setPosition(coordinate);
            } else {
              popup.setPosition(undefined);
            }
          }
        } else {
          popup.setPosition(undefined);
        }
      } catch (e) {
        console.log('Parse error:', e);
        popup.setPosition(undefined);
      }
    })
    .catch(error => {
      console.error('Fetch error:', error);
      popup.setPosition(undefined);
    });
});

// Close popup when clicking elsewhere on the map
map.on('click', function(evt) {
  const clickedFeatures = map.getFeaturesAtPixel(evt.pixel);
  if (!clickedFeatures) {
    popup.setPosition(undefined);
  }
});

// Close popup when panning starts
map.on('movestart', function() {
  popup.setPosition(undefined);
});

// Optional: Add cursor change when hovering over the map
map.on('pointermove', function(evt) {
  const pixel = map.getEventPixel(evt.originalEvent);
  const hit = map.hasFeatureAtPixel(pixel);
  map.getTargetElement().style.cursor = hit ? 'pointer' : '';
});

// Function to hide all soil layers except the one specified
function showOnlySoilLayer(activeLayer) {
  [clayLayer, ecLayer, phLayer, gsocLayer].forEach(layer => {
    layer.setVisible(layer === activeLayer);
  });
}

// Add event listeners for radio button behavior
clayLayer.on('change:visible', function(e) {
  if (e.target.getVisible()) {
    showOnlySoilLayer(clayLayer);
    updateLegend('PH-GSNM-CLAY-2023-0-30');
  }
});

ecLayer.on('change:visible', function(e) {
  if (e.target.getVisible()) {
    showOnlySoilLayer(ecLayer);
    updateLegend('PH-GSAS-ECX-2020-0-30');
  }
});

phLayer.on('change:visible', function(e) {
  if (e.target.getVisible()) {
    showOnlySoilLayer(phLayer);
    updateLegend('PH-GSAS-PHX-2020-0-30');
  }
});

gsocLayer.on('change:visible', function(e) {
  if (e.target.getVisible()) {
    showOnlySoilLayer(gsocLayer);
    updateLegend('GSOC');
  }
});

// Function to update legend
function updateLegend(layerName) {
  const legendImg = document.getElementById('legend-img');
  const baseUrl = 'http://localhost:8082/';
  
  const params = new URLSearchParams({
    map: `/etc/mapserver/${layerName}.map`,
    SERVICE: 'WMS',
    VERSION: '1.1.1',
    LAYER: layerName,
    REQUEST: 'getlegendgraphic',
    FORMAT: 'image/png',
    _t: new Date().getTime() // Add timestamp to prevent caching
  });
  
  legendImg.src = `${baseUrl}?${params.toString()}`;
}

// Initial legend setup
updateLegend('PH-GSNM-CLAY-2023-0-30');

// Make sure the legend container exists
document.addEventListener('DOMContentLoaded', function() {
  // Check if legend container exists
  let legendContainer = document.querySelector('.map-legend');
  if (!legendContainer) {
    console.log('Creating legend container');
    legendContainer = document.createElement('div');
    legendContainer.className = 'map-legend';
    legendContainer.innerHTML = `
      <div class="legend-title">Legend</div>
      <div id="legend-content">
        <img id="legend-img" class="legend-image" alt="Layer Legend" />
      </div>
    `;
    document.body.appendChild(legendContainer);
  }

  // Add explicit styles
  const styles = `
    .map-legend {
      position: absolute;
      bottom: 20px;
      right: 10px;
      background-color: white;
      box-shadow: 0 1px 5px rgba(0,0,0,0.4);
      border-radius: 4px;
      padding: 10px;
      z-index: 1000;
      min-width: 150px;
    }
    .legend-title {
      font-weight: bold;
      margin-bottom: 8px;
    }
    .legend-image {
      display: block;
      max-width: 100%;
    }
    .ol-control button {
      background-color: rgba(255, 255, 255, 0.9) !important;
      color: #666 !important;
      border: 1px solid #ccc !important;
    }
    .ol-control button:hover {
      background-color: #f4f4f4 !important;
      color: #333 !important;
    }
    .ol-zoom {
      background-color: transparent;
    }
    .ol-layerswitcher .panel {
      background-color: white !important;
    }
    .ol-layerswitcher .panel li.layer {
      margin: 5px 0;
    }
    .ol-layerswitcher button {
      background-color: white !important;
      color: #666 !important;
      border: 1px solid #ccc !important;
    }
    .ol-layerswitcher button:hover {
      background-color: #f4f4f4 !important;
    }
    .ol-layerswitcher .layergroup > .layer-switcher-fold {
      position: relative;
      cursor: pointer;
      display: inline-block !important;
      width: 16px;
      height: 16px;
      margin-right: 5px;
    }
    .ol-layerswitcher .layergroup {
      margin-top: 5px;
    }
    .ol-layerswitcher .panel li.layer label {
      display: inline-block;
      padding: 2px 0;
    }
    .opacity-control {
      display: inline-flex;
      align-items: center;
      margin-left: 10px;
    }
    .opacity-slider {
      width: 80px;
      margin-left: 5px;
      vertical-align: middle;
    }
    .opacity-label {
      font-size: 12px;
      color: #666;
    }
  `;
  
  const styleSheet = document.createElement('style');
  styleSheet.textContent = styles;
  document.head.appendChild(styleSheet);
});

// Add opacity control to layer switcher after it's rendered
layerSwitcher.on('render', function() {
  // Find the Soil Properties group element
  const labels = document.querySelectorAll('.layer-switcher .panel li.layer label');
  const soilGroupLabel = Array.from(labels).find(label => label.textContent.trim() === 'Soil Properties');
  const soilGroupElement = soilGroupLabel?.closest('li.layer');

  if (soilGroupElement && !soilGroupElement.querySelector('.opacity-control')) {
    const opacityControl = document.createElement('div');
    opacityControl.className = 'opacity-control';
    
    const label = document.createElement('span');
    label.textContent = 'Opacity: ';
    label.className = 'opacity-label';
    
    const slider = document.createElement('input');
    slider.type = 'range';
    slider.min = '0';
    slider.max = '100';
    slider.value = '100';
    slider.className = 'opacity-slider';
    
    opacityControl.appendChild(label);
    opacityControl.appendChild(slider);
    
    // Insert after the group title but before the layer list
    const groupList = soilGroupElement.querySelector('ul');
    if (groupList) {
      soilGroupElement.insertBefore(opacityControl, groupList);
    } else {
      soilGroupElement.appendChild(opacityControl);
    }
    
    slider.addEventListener('input', function() {
      const opacity = parseFloat(this.value) / 100;
      soilLayerGroup.getLayers().forEach(layer => {
        layer.setOpacity(opacity);
      });
    });
  }
});

// Add opacity slider functionality
opacityControl.slider.addEventListener('input', function() {
  const opacity = parseFloat(this.value) / 100;
  soilLayerGroup.getLayers().forEach(layer => {
    layer.setOpacity(opacity);
  });
});