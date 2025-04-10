<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGRDSSM1</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 0.39"/>
             <sld:ColorMapEntry quantity="0.39" color="#e4d5c2" opacity="1" label="0.39 - 0.77"/>
             <sld:ColorMapEntry quantity="0.77" color="#d3c2b0" opacity="1" label="0.77 - 1.16"/>
             <sld:ColorMapEntry quantity="1.16" color="#c2b09e" opacity="1" label="1.16 - 1.55"/>
             <sld:ColorMapEntry quantity="1.55" color="#b19d8c" opacity="1" label="1.55 - 1.94"/>
             <sld:ColorMapEntry quantity="1.94" color="#a08b7b" opacity="1" label="1.94 - 2.32"/>
             <sld:ColorMapEntry quantity="2.32" color="#8f7869" opacity="1" label="2.32 - 2.71"/>
             <sld:ColorMapEntry quantity="2.71" color="#7e6657" opacity="1" label="2.71 - 3.10"/>
             <sld:ColorMapEntry quantity="3.1" color="#6d5345" opacity="1" label="3.10 - 3.48"/>
             <sld:ColorMapEntry quantity="3.48" color="#5c4033" opacity="1" label="3.48 - 3.87"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>