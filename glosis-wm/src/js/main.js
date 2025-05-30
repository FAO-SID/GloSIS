import 'ol/ol.css';
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import XYZ from 'ol/source/XYZ';
import { ScaleLine, defaults as defaultControls, Attribution } from 'ol/control';
import { fromLonLat } from 'ol/proj';
import Overlay from 'ol/Overlay';
import { fetchLayerInfo, createLayerConfig } from './layers';
import ImageLayer from 'ol/layer/Image';
import ImageWMS from 'ol/source/ImageWMS';
import { transform, transformExtent } from 'ol/proj';

// Create popup overlay for feature information
const popup = new Overlay({
    element: document.getElementById('popup'),
    positioning: 'center-center',
    offset: [-105, 5],
    autoPan: {
        animation: {
            duration: 250
        }
    }
});

// Create legend container
const legendContainer = document.createElement('div');
legendContainer.id = 'legend';
legendContainer.className = 'legend-container';
document.body.appendChild(legendContainer);

// Function to update legend
function updateLegend(layer) {
    const legendContainer = document.getElementById('legend');
    const legendContent = legendContainer.querySelector('.legend-content');
    
    if (!layer || !layer.getVisible()) {
        legendContainer.style.display = 'none';
        return;
    }

    const layerId = layer.getSource().getParams().LAYERS;
    const legendUrl = `http://localhost:8082/?map=/etc/mapserver/${layerId}.map&SERVICE=WMS&VERSION=1.1.1&LAYER=${layerId}&REQUEST=getlegendgraphic&FORMAT=image/png`;
    
    legendContainer.style.display = 'block';
    legendContent.innerHTML = `<img src="${legendUrl}" alt="Legend" />`;
}

// Base maps configuration
const baseMaps = {
    'Base Maps': [
        {
            id: 'esri-imagery',
            name: 'ESRI Imagery',
            layer: new TileLayer({
                source: new XYZ({
                    url: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    attributions: 'Tiles © Esri'
                })
            })
        },
        {
            id: 'osm',
            name: 'OpenStreetMap',
            layer: new TileLayer({
                source: new XYZ({
                    url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    attributions: '© OpenStreetMap contributors'
                })
            })
        },
        {
            id: 'topo',
            name: 'Open TopoMap',
            layer: new TileLayer({
                source: new XYZ({
                    url: 'https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png',
                    attributions: '© OpenStreetMap contributors, © OpenTopoMap'
                })
            })
        }
    ]
};

// Initialize map
const map = new Map({
    target: 'map',
    controls: defaultControls({
        zoom: false, // Disable default zoom control
        attribution: false, // Keep attribution control
        rotate: true // Keep rotate control if it exists
    }).extend([
        new ScaleLine({
            target: 'scale-line'
        })
    ]),
    view: new View({
        center: fromLonLat([120, 12]), // Philippines center
        zoom: 6
    })
});

// Add popup overlay to map
map.addOverlay(popup);

// Handle popup closer
document.getElementById('popup-closer').onclick = () => {
    popup.setPosition(undefined);
};

// Add click handler for feature information
map.on('singleclick', async (evt) => {
    // Get the visible WMS layers
    const visibleLayers = map.getLayers().getArray().filter(layer => {
        return layer instanceof ImageLayer && 
               layer.getVisible() && 
               layer.getSource() instanceof ImageWMS;
    });

    if (visibleLayers.length === 0) {
        popup.setPosition(undefined);
        return;
    }

    // Get the view resolution and projection
    const viewResolution = map.getView().getResolution();
    const viewProjection = map.getView().getProjection();
    const coordinate = evt.coordinate;

    // Transform coordinates to EPSG:4326 (lat/lon)
    const coordinate4326 = transform(coordinate, viewProjection, 'EPSG:4326');
    // Format coordinates to 3 decimal places
    const lon = coordinate4326[0].toFixed(2);
    const lat = coordinate4326[1].toFixed(2);

    const mapSize = map.getSize();
    const extent = map.getView().calculateExtent(mapSize);
    const bbox4326 = transformExtent(extent, viewProjection, 'EPSG:4326');

    // Create a promise for each layer's feature info request
    const featureInfoPromises = visibleLayers.map(async (layer) => {
        const source = layer.getSource();
        const layerName = layer.get('name');
        
        if (!layerName) {
            console.warn('Layer name not found for layer:', layer);
            return null;
        }

        // Get the layer ID from the source params
        const layerId = source.getParams().LAYERS;
        
        // Log layer information for debugging
        console.log('Layer info:', {
            layerName: layerName,
            layerId: layerId,
            sourceParams: source.getParams()
        });

        // Use OpenLayers' built-in getGetFeatureInfoUrl method
        const url = source.getFeatureInfoUrl(
            evt.coordinate,
            viewResolution,
            viewProjection,
            {
                'INFO_FORMAT': 'text/html',
                'FEATURE_COUNT': 1,
                'QUERY_LAYERS': layerId,
                'VERSION': '1.3.0'
            }
        );

        if (!url) {
            console.warn('Could not generate GetFeatureInfo URL for layer:', layerName);
            return null;
        }

        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error('Network response was not ok');
            
            // Get the content type from the response
            const contentType = response.headers.get('content-type');
            
            let data;
            if (contentType && contentType.includes('application/json')) {
                data = await response.json();
            } else if (contentType && contentType.includes('text/html')) {
                const text = await response.text();
                data = {
                    type: 'FeatureCollection',
                    features: [{
                        type: 'Feature',
                        properties: {
                            'Content': text
                        }
                    }]
                };
            } else if (contentType && contentType.includes('text/plain')) {
                const text = await response.text();
                // Parse the plain text response into a structured format
                const properties = {};
                text.split('\n').forEach(line => {
                    const [key, value] = line.split(':').map(s => s.trim());
                    if (key && value) {
                        properties[key] = value;
                    }
                });
                data = {
                    type: 'FeatureCollection',
                    features: [{
                        type: 'Feature',
                        properties: properties
                    }]
                };
            } else {
                // For other formats, get the text content
                const text = await response.text();
                data = {
                    type: 'FeatureCollection',
                    features: [{
                        type: 'Feature',
                        properties: {
                            'Content': text
                        }
                    }]
                };
            }
            
            return {
                layer: layer,
                data: data
            };
        } catch (error) {
            console.error('Error fetching feature info:', error);
            return null;
        }
    });

    // Wait for all feature info requests to complete
    const featureInfoResults = await Promise.all(featureInfoPromises);
    
    // Filter out failed requests and empty results
    const validResults = featureInfoResults.filter(result => 
        result && result.data && 
        ((result.data.features && result.data.features.length > 0) || 
         (result.data.properties && Object.keys(result.data.properties).length > 0))
    );

    if (validResults.length === 0) {
        popup.setPosition(undefined);
        return;
    }

    // Create popup content
    const popupContent = document.getElementById('popup-content');
    popupContent.innerHTML = '';

    validResults.forEach(result => {
        const layerName = result.layer.get('name') || 'Unknown Layer';
        const features = result.data.features || [result.data];

        const layerDiv = document.createElement('div');
        layerDiv.className = 'feature-info-layer';
        
        const layerHeader = document.createElement('h3');
        layerHeader.textContent = layerName;
        layerDiv.appendChild(layerHeader);

        features.forEach(feature => {
            const featureDiv = document.createElement('div');
            featureDiv.className = 'feature-info-item';
            
            if (feature.properties) {
                if (feature.properties.Content) {
                    // Parse the content string
                    const content = feature.properties.Content;
                    const valueMatch = content.match(/Value:\s*([\d.]+)/);
                    
                    // Get unit from layer source parameters
                    const unit = result.layer.get('unit');
                    
                    if (valueMatch) {
                        const valueDiv = document.createElement('div');
                        valueDiv.className = 'feature-info-property';
                        const roundedValue = parseFloat(valueMatch[1]).toFixed(2);
                        valueDiv.innerHTML = `<strong>Value:</strong> ${roundedValue}${unit ? ' ' + unit : ''}`;
                        featureDiv.appendChild(valueDiv);
                    }
                    
                    // Add coordinates in EPSG:4326
                    const coordsDiv = document.createElement('div');
                    coordsDiv.className = 'feature-info-property';
                    coordsDiv.innerHTML = `<strong>Coords (lon, lat):</strong> ${lon}, ${lat}`;
                    featureDiv.appendChild(coordsDiv);
                } else {
                    Object.entries(feature.properties).forEach(([key, value]) => {
                        if (value !== null && value !== undefined) {
                            const propertyDiv = document.createElement('div');
                            propertyDiv.className = 'feature-info-property';
                            propertyDiv.innerHTML = `<strong>${key}:</strong> ${value}`;
                            featureDiv.appendChild(propertyDiv);
                        }
                    });
                }
            }
            
            layerDiv.appendChild(featureDiv);
        });

        popupContent.appendChild(layerDiv);
    });

    // Show popup
    popup.setPosition(coordinate);
});

// Function to create layer group UI
function createLayerGroupUI(groupName, layers) {
    const groupDiv = document.createElement('div');
    groupDiv.className = 'layer-group';
    
    // Add collapsed class for specific groups
    if (['Base Maps', 'Soil Profiles', 'Salt-Affected Soils', 'Organic Carbon Sequestration Potential'].includes(groupName)) {
        groupDiv.classList.add('collapsed');
    }
    
    const header = document.createElement('div');
    header.className = 'layer-group-header';
    header.textContent = groupName;
    header.onclick = () => groupDiv.classList.toggle('collapsed');
    
    const content = document.createElement('div');
    content.className = 'layer-group-content';
    
    layers.forEach(layer => {
        const layerDiv = document.createElement('div');
        layerDiv.className = 'layer-item';
        
        const input = document.createElement('input');
        input.type = groupName === 'Base Maps' ? 'radio' : 'checkbox';
        input.name = groupName === 'Base Maps' ? 'baseMap' : 'overlayLayer';
        input.id = layer.id;
        
        const label = document.createElement('label');
        label.htmlFor = layer.id;
        label.textContent = layer.name;
        label.title = layer.name; // Add tooltip
        
        if (layer.metadata_url || layer.download_url) {
            const icons = document.createElement('div');
            icons.className = 'layer-icons';
            
            if (layer.metadata_url) {
                const metadataIcon = document.createElement('img');
                metadataIcon.src = '../public/img/metadata-icon.svg';
                metadataIcon.title = 'View Metadata';
                metadataIcon.onclick = () => window.open(layer.metadata_url);
                icons.appendChild(metadataIcon);
            }
            
            if (layer.download_url) {
                const downloadIcon = document.createElement('img');
                downloadIcon.src = '../public/img/download-icon.svg';
                downloadIcon.title = 'Download Layer';
                downloadIcon.onclick = () => window.open(layer.download_url);
                icons.appendChild(downloadIcon);
            }
            
            layerDiv.appendChild(icons);
        }
        
        layerDiv.appendChild(input);
        layerDiv.appendChild(label);
        content.appendChild(layerDiv);
        
        // Handle layer visibility
        input.onchange = () => {
            // Close any open popup
            popup.setPosition(undefined);
            
            if (groupName === 'Base Maps') {
                baseMaps['Base Maps'].forEach(baseLayer => {
                    baseLayer.layer.setVisible(baseLayer.id === layer.id);
                });
                // Hide legend for base maps
                updateLegend(null);
            } else {
                // For non-profile layers, uncheck all other non-profile layers
                if (groupName !== 'Soil Profiles') {
                    document.querySelectorAll('input[name="overlayLayer"]').forEach(checkbox => {
                        if (checkbox.id !== layer.id && !checkbox.closest('.layer-group').querySelector('.layer-group-header').textContent.includes('Soil Profiles')) {
                            checkbox.checked = false;
                            const layerToHide = findLayerById(checkbox.id);
                            if (layerToHide) {
                                layerToHide.setVisible(false);
                            }
                        }
                    });
                }
                layer.layer.setVisible(input.checked);
                // Update legend
                updateLegend(input.checked ? layer.layer : null);

                // Collapse other group layers when a new layer is selected
                if (input.checked) {
                    document.querySelectorAll('.layer-group').forEach(otherGroup => {
                        const otherGroupHeader = otherGroup.querySelector('.layer-group-header');
                        if (otherGroupHeader && otherGroupHeader.textContent !== groupName) {
                            otherGroup.classList.add('collapsed');
                        }
                    });
                }
            }
        };
    });
    
    groupDiv.appendChild(header);
    groupDiv.appendChild(content);
    return groupDiv;
}

// Helper function to find layer by ID
function findLayerById(id) {
    for (const group of Object.values(layerGroups)) {
        for (const layer of group) {
            if (layer.id === id) {
                return layer.layer;
            }
        }
    }
    return null;
}

// Initialize layer groups
let layerGroups = { ...baseMaps };

// Load and initialize WMS layers
async function initializeLayers() {
    try {
        const layerInfo = await fetchLayerInfo();
        const wmsLayers = createLayerConfig(layerInfo);
        layerGroups = { ...layerGroups, ...wmsLayers };
        
        const layerGroupsContainer = document.getElementById('layer-groups');
        layerGroupsContainer.innerHTML = ''; // Clear existing content
        
        // Add all layer groups to the UI and map
        Object.entries(layerGroups).forEach(([groupName, layers]) => {
            const groupUI = createLayerGroupUI(groupName, layers);
            layerGroupsContainer.appendChild(groupUI);
            
            // Add all layers to map, including Soil Profiles
            layers.forEach(layer => {
                map.addLayer(layer.layer);
                layer.layer.setVisible(false);
                // Set default opacity for non-base map layers
                if (!baseMaps['Base Maps'].some(baseLayer => baseLayer.layer === layer.layer)) {
                    layer.layer.setOpacity(0.8);
                }
            });
        });
        
        // Select default base map
        const defaultBaseMap = document.getElementById('esri-imagery');
        if (defaultBaseMap) {
            defaultBaseMap.checked = true;
            defaultBaseMap.dispatchEvent(new Event('change'));
        }

        // Set default opacity in the opacity control
        const opacityControl = document.getElementById('opacity');
        opacityControl.value = 0.8;

        // Activate Bulk density (0-30) by default
        const bulkDensityLayer = document.querySelector('input[id="PH-GSNM-BKD-2023-0-30"]');
        if (bulkDensityLayer) {
            bulkDensityLayer.checked = true;
            bulkDensityLayer.dispatchEvent(new Event('change'));
        }
    } catch (error) {
        console.error('Error initializing layers:', error);
    }
}

// Initialize layers
initializeLayers();

// Layer switcher collapse functionality
const collapseBtn = document.getElementById('collapse-btn');
const layerSwitcher = document.getElementById('layer-switcher');

// Change button text to an arrow
collapseBtn.innerHTML = '◀';

collapseBtn.onclick = () => {
    layerSwitcher.classList.toggle('collapsed');
    // Update button text based on state
    collapseBtn.innerHTML = layerSwitcher.classList.contains('collapsed') ? '▶' : '◀';
};

// Opacity control
const opacityControl = document.getElementById('opacity');
opacityControl.oninput = (e) => {
    const opacity = parseFloat(e.target.value);
    const visibleLayers = map.getLayers().getArray().filter(layer => {
        // Only apply opacity to non-base map layers
        return layer.getVisible() && !baseMaps['Base Maps'].some(baseLayer => baseLayer.layer === layer);
    });
    visibleLayers.forEach(layer => layer.setOpacity(opacity));
};

// Zoom controls
document.getElementById('zoom-in').onclick = () => {
    const view = map.getView();
    view.animate({
        zoom: view.getZoom() + 1,
        duration: 250
    });
};

document.getElementById('zoom-out').onclick = () => {
    const view = map.getView();
    view.animate({
        zoom: view.getZoom() - 1,
        duration: 250
    });
}; 