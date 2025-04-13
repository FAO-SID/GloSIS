import TileLayer from 'ol/layer/Tile';
import ImageLayer from 'ol/layer/Image';
import VectorLayer from 'ol/layer/Vector';
import OSM from 'ol/source/OSM';
import VectorSource from 'ol/source/Vector';

/**
 * Create an empty layer for placeholder or testing purposes
 * @param {Object} options - Layer options
 * @returns {ol/layer/Layer} - Empty layer
 */
export const createEmptyLayer = (options = {}) => {
  const type = options.type || 'tile';
  const title = options.title || 'Empty Layer';
  const visible = options.visible !== undefined ? options.visible : false;
  
  switch (type) {
    case 'vector':
      return new VectorLayer({
        source: new VectorSource(),
        title: title,
        visible: visible,
        properties: options.properties || {}
      });
    
    case 'image':
      return new ImageLayer({
        source: new OSM(), // Using OSM as a placeholder
        title: title,
        visible: visible,
        properties: options.properties || {}
      });
      
    case 'tile':
    default:
      return new TileLayer({
        source: new OSM(), // Using OSM as a placeholder
        title: title,
        visible: visible, 
        properties: options.properties || {}
      });
  }
};

/**
 * Filter layers by group
 * @param {Array} layers - Array of layers
 * @param {String} groupId - Group identifier
 * @returns {Array} - Filtered layers
 */
export const getLayersByGroup = (layers, groupId) => {
  return layers.filter(layer => layer.get('group') === groupId);
};

/**
 * Find a layer by its title
 * @param {Array} layers - Array of layers
 * @param {String} title - Layer title
 * @returns {ol/layer/Layer|null} - Found layer or null
 */
export const findLayerByTitle = (layers, title) => {
  return layers.find(layer => layer.get('title') === title) || null;
};

/**
 * Get visible layers from a collection
 * @param {Array} layers - Array of layers
 * @returns {Array} - Visible layers
 */
export const getVisibleLayers = (layers) => {
  return layers.filter(layer => layer.getVisible());
};

/**
 * Toggle layer visibility
 * @param {ol/layer/Layer} layer - The layer to toggle
 * @returns {Boolean} - New visibility state
 */
export const toggleLayerVisibility = (layer) => {
  const currentVisibility = layer.getVisible();
  layer.setVisible(!currentVisibility);
  return !currentVisibility;
}; 