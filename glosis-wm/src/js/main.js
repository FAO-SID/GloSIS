import 'ol/ol.css';
import Map from 'ol/Map';
import View from 'ol/View';
import TileLayer from 'ol/layer/Tile';
import XYZ from 'ol/source/XYZ';
import { ScaleLine, defaults as defaultControls, Attribution } from 'ol/control';
import { fromLonLat } from 'ol/proj';
import { fetchLayerInfo, createLayerConfig } from './layers';

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
        center: fromLonLat([121.774017, 12.879721]), // Philippines center
        zoom: 6
    })
});

// Function to create layer group UI
function createLayerGroupUI(groupName, layers) {
    const groupDiv = document.createElement('div');
    groupDiv.className = 'layer-group';
    
    // Add collapsed class for specific groups
    if (['Base Maps', 'Soil Nutrients', 'Salt-Affected Soils', 'Organic Carbon Sequestration Potential'].includes(groupName)) {
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
            if (groupName === 'Base Maps') {
                baseMaps['Base Maps'].forEach(baseLayer => {
                    baseLayer.layer.setVisible(baseLayer.id === layer.id);
                });
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
        
        // Add all layer groups to the UI and map, handling Soil Profiles separately
        Object.entries(layerGroups).forEach(([groupName, layers]) => {
            const groupUI = createLayerGroupUI(groupName, layers);
            layerGroupsContainer.appendChild(groupUI);
            
            // Add layers to map, but skip Soil Profiles for now
            if (groupName !== 'Soil Profiles') {
                layers.forEach(layer => {
                    map.addLayer(layer.layer);
                    layer.layer.setVisible(false);
                });
            }
        });

        // Add Soil Profiles layers last to ensure they stay on top
        if (layerGroups['Soil Profiles']) {
            layerGroups['Soil Profiles'].forEach(layer => {
                map.addLayer(layer.layer);
                layer.layer.setVisible(true);
                // Also check the corresponding checkbox
                const checkbox = document.getElementById(layer.id);
                if (checkbox) {
                    checkbox.checked = true;
                }
            });
        }
        
        // Select default base map
        const defaultBaseMap = document.getElementById('esri-imagery');
        if (defaultBaseMap) {
            defaultBaseMap.checked = true;
            defaultBaseMap.dispatchEvent(new Event('change'));
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