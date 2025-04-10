<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>PXX</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="-1" color="#000000" opacity="0" label="No Data"/>
             <sld:ColorMapEntry quantity="2.82" color="#f4e7d3" opacity="1" label="2.82 - 7.32"/>
             <sld:ColorMapEntry quantity="7.32" color="#e4d5c2" opacity="1" label="7.32 - 11.83"/>
             <sld:ColorMapEntry quantity="11.83" color="#d3c2b0" opacity="1" label="11.83 - 16.33"/>
             <sld:ColorMapEntry quantity="16.33" color="#c2b09e" opacity="1" label="16.33 - 20.83"/>
             <sld:ColorMapEntry quantity="20.83" color="#b19d8c" opacity="1" label="20.83 - 25.34"/>
             <sld:ColorMapEntry quantity="25.34" color="#a08b7b" opacity="1" label="25.34 - 29.84"/>
             <sld:ColorMapEntry quantity="29.84" color="#8f7869" opacity="1" label="29.84 - 34.34"/>
             <sld:ColorMapEntry quantity="34.34" color="#7e6657" opacity="1" label="34.34 - 38.85"/>
             <sld:ColorMapEntry quantity="38.85" color="#6d5345" opacity="1" label="38.85 - 43.35"/>
             <sld:ColorMapEntry quantity="43.35" color="#5c4033" opacity="1" label="43.35 - 47.85"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>