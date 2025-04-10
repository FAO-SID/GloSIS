<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>BKD</sld:Name>
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
             <sld:ColorMapEntry quantity="1.36" color="#f4e7d3" opacity="1" label="1.36 - 1.39"/>
             <sld:ColorMapEntry quantity="1.39" color="#e4d5c2" opacity="1" label="1.39 - 1.42"/>
             <sld:ColorMapEntry quantity="1.42" color="#d3c2b0" opacity="1" label="1.42 - 1.45"/>
             <sld:ColorMapEntry quantity="1.45" color="#c2b09e" opacity="1" label="1.45 - 1.48"/>
             <sld:ColorMapEntry quantity="1.48" color="#b19d8c" opacity="1" label="1.48 - 1.52"/>
             <sld:ColorMapEntry quantity="1.52" color="#a08b7b" opacity="1" label="1.52 - 1.55"/>
             <sld:ColorMapEntry quantity="1.55" color="#8f7869" opacity="1" label="1.55 - 1.58"/>
             <sld:ColorMapEntry quantity="1.58" color="#7e6657" opacity="1" label="1.58 - 1.61"/>
             <sld:ColorMapEntry quantity="1.61" color="#6d5345" opacity="1" label="1.61 - 1.64"/>
             <sld:ColorMapEntry quantity="1.64" color="#5c4033" opacity="1" label="1.64 - 1.68"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>