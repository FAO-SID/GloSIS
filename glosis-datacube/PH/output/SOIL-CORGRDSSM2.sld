<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGRDSSM2</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 0.77"/>
             <sld:ColorMapEntry quantity="0.77" color="#e4d5c2" opacity="1" label="0.77 - 1.55"/>
             <sld:ColorMapEntry quantity="1.55" color="#d3c2b0" opacity="1" label="1.55 - 2.32"/>
             <sld:ColorMapEntry quantity="2.32" color="#c2b09e" opacity="1" label="2.32 - 3.10"/>
             <sld:ColorMapEntry quantity="3.1" color="#b19d8c" opacity="1" label="3.10 - 3.87"/>
             <sld:ColorMapEntry quantity="3.87" color="#a08b7b" opacity="1" label="3.87 - 4.64"/>
             <sld:ColorMapEntry quantity="4.64" color="#8f7869" opacity="1" label="4.64 - 5.42"/>
             <sld:ColorMapEntry quantity="5.42" color="#7e6657" opacity="1" label="5.42 - 6.19"/>
             <sld:ColorMapEntry quantity="6.19" color="#6d5345" opacity="1" label="6.19 - 6.97"/>
             <sld:ColorMapEntry quantity="6.97" color="#5c4033" opacity="1" label="6.97 - 7.74"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>