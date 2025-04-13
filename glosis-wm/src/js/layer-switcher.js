/**
 * Layer Switcher component for OpenLayers
 */
export class LayerSwitcher {
  constructor(options) {
    this.map = options.map;
    this.layerGroups = options.layerGroups || [];
    this.layerData = options.layerData || {};
    this.selectedLayers = options.selectedLayers || {
      baseMap: null,
      contentLayer: null,
      profileLayer: null
    };
    this.target = options.target || document.body;
    
    this.init();
  }
  
  init() {
    this.render();
    this.attachEvents();
  }
  
  render() {
    // Clear any existing content
    this.target.innerHTML = '';
    
    // Create a container for each layer group
    this.layerGroups.forEach(group => {
      const groupEl = this.createLayerGroup(group);
      this.target.appendChild(groupEl);
    });
  }
  
  createLayerGroup(group) {
    const groupContainer = document.createElement('div');
    groupContainer.className = 'layer-group';
    groupContainer.id = `group-${group.id}`;
    
    // Create group header
    const groupHeader = document.createElement('div');
    groupHeader.className = 'group-header';
    groupHeader.innerHTML = `
      <span class="group-name">${group.name}</span>
      <span class="group-toggle">${group.expanded ? '▼' : '▶'}</span>
    `;
    groupContainer.appendChild(groupHeader);
    
    // Create group content
    const groupContent = document.createElement('div');
    groupContent.className = `group-content ${group.expanded ? 'expanded' : ''}`;
    
    // Add layers to the group content
    if (this.layerData[group.id]) {
      this.layerData[group.id].forEach(layer => {
        const layerItem = this.createLayerItem(layer, group.id);
        groupContent.appendChild(layerItem);
      });
    }
    
    groupContainer.appendChild(groupContent);
    return groupContainer;
  }
  
  createLayerItem(layer, groupId) {
    const layerItem = document.createElement('div');
    layerItem.className = 'layer-item';
    layerItem.dataset.layerId = layer.get('title');
    layerItem.dataset.groupId = groupId;
    
    // Get layer properties
    const properties = layer.get('properties') || {};
    const title = layer.get('title');
    const propertyName = properties.property_name || '';
    const metadataUrl = properties.metadata_url || '';
    const downloadUrl = properties.download_url || '';
    
    // Create layer info section
    const layerInfo = document.createElement('div');
    layerInfo.className = 'layer-info';
    
    // Create radio/checkbox input based on layer group
    const inputType = (groupId === 'base_maps' || 
                       (groupId !== 'soil_profiles' && groupId !== 'base_maps')) 
                       ? 'radio' : 'checkbox';
    const inputName = (groupId === 'base_maps') ? 'baseMap' : 
                      (groupId === 'soil_profiles') ? 'profileLayer' : 'contentLayer';
    
    const input = document.createElement('input');
    input.type = inputType;
    input.name = inputName;
    input.value = title;
    input.id = `layer-${groupId}-${title.replace(/\s+/g, '-').toLowerCase()}`;
    input.checked = layer.getVisible();
    
    const label = document.createElement('label');
    label.htmlFor = input.id;
    label.textContent = title;
    
    layerInfo.appendChild(input);
    layerInfo.appendChild(label);
    
    // Create tooltip with property name
    if (propertyName) {
      const tooltip = document.createElement('div');
      tooltip.className = 'layer-tooltip';
      tooltip.textContent = propertyName;
      layerItem.appendChild(tooltip);
    }
    
    // Create layer actions section
    const layerActions = document.createElement('div');
    layerActions.className = 'layer-actions';
    
    // Add metadata button if URL exists
    if (metadataUrl) {
      const metadataBtn = document.createElement('button');
      metadataBtn.className = 'metadata-btn';
      metadataBtn.innerHTML = '<span title="View Metadata">ℹ️</span>';
      metadataBtn.dataset.url = metadataUrl;
      layerActions.appendChild(metadataBtn);
    }
    
    // Add download button if URL exists
    if (downloadUrl) {
      const downloadBtn = document.createElement('button');
      downloadBtn.className = 'download-btn';
      downloadBtn.innerHTML = '<span title="Download Data">📥</span>';
      downloadBtn.dataset.url = downloadUrl;
      layerActions.appendChild(downloadBtn);
    }
    
    layerItem.appendChild(layerInfo);
    layerItem.appendChild(layerActions);
    
    return layerItem;
  }
  
  attachEvents() {
    // Toggle group expansion
    this.target.querySelectorAll('.group-header').forEach(header => {
      header.addEventListener('click', (e) => {
        const groupContent = header.nextElementSibling;
        const groupToggle = header.querySelector('.group-toggle');
        
        groupContent.classList.toggle('expanded');
        
        if (groupContent.classList.contains('expanded')) {
          groupToggle.textContent = '▼';
        } else {
          groupToggle.textContent = '▶';
        }
      });
    });
    
    // Layer selection
    this.target.querySelectorAll('.layer-item input').forEach(input => {
      input.addEventListener('change', (e) => {
        const layerId = e.target.value;
        const groupId = e.target.closest('.layer-item').dataset.groupId;
        const checked = e.target.checked;
        
        this.handleLayerSelection(layerId, groupId, checked);
      });
    });
    
    // Metadata button click
    this.target.querySelectorAll('.metadata-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        const url = btn.dataset.url;
        if (url) {
          window.open(url, '_blank');
        }
      });
    });
    
    // Download button click
    this.target.querySelectorAll('.download-btn').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.stopPropagation();
        const url = btn.dataset.url;
        if (url) {
          window.open(url, '_blank');
        }
      });
    });
  }
  
  handleLayerSelection(layerId, groupId, checked) {
    // Get all layers in the group
    const groupLayers = this.layerData[groupId];
    if (!groupLayers) return;
    
    // Find the selected layer
    const selectedLayer = groupLayers.find(layer => layer.get('title') === layerId);
    if (!selectedLayer) return;
    
    // Handle base maps
    if (groupId === 'base_maps') {
      // Turn off all base maps
      groupLayers.forEach(layer => {
        layer.setVisible(layer === selectedLayer);
      });
      
      this.selectedLayers.baseMap = selectedLayer;
    } 
    // Handle soil profiles
    else if (groupId === 'soil_profiles') {
      selectedLayer.setVisible(checked);
      
      if (checked) {
        this.selectedLayers.profileLayer = selectedLayer;
      } else if (this.selectedLayers.profileLayer === selectedLayer) {
        this.selectedLayers.profileLayer = null;
      }
    } 
    // Handle other content layers
    else {
      // Turn off all content layers (except profiles)
      Object.entries(this.layerData).forEach(([gId, layers]) => {
        if (gId !== 'base_maps' && gId !== 'soil_profiles') {
          layers.forEach(layer => {
            const shouldBeVisible = (gId === groupId && layer === selectedLayer && checked);
            layer.setVisible(shouldBeVisible);
          });
        }
      });
      
      if (checked) {
        this.selectedLayers.contentLayer = selectedLayer;
      } else {
        this.selectedLayers.contentLayer = null;
      }
    }
    
    // Set opacity for newly selected layer based on current slider value
    const opacitySlider = document.getElementById('opacity-slider');
    if (opacitySlider && checked) {
      const opacity = parseFloat(opacitySlider.value);
      selectedLayer.setOpacity(opacity);
    }
  }
} 