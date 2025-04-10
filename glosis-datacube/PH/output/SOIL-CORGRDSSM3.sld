<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGRDSSM3</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 1.55"/>
             <sld:ColorMapEntry quantity="1.55" color="#e4d5c2" opacity="1" label="1.55 - 3.10"/>
             <sld:ColorMapEntry quantity="3.1" color="#d3c2b0" opacity="1" label="3.10 - 4.64"/>
             <sld:ColorMapEntry quantity="4.64" color="#c2b09e" opacity="1" label="4.64 - 6.19"/>
             <sld:ColorMapEntry quantity="6.19" color="#b19d8c" opacity="1" label="6.19 - 7.74"/>
             <sld:ColorMapEntry quantity="7.74" color="#a08b7b" opacity="1" label="7.74 - 9.29"/>
             <sld:ColorMapEntry quantity="9.29" color="#8f7869" opacity="1" label="9.29 - 10.84"/>
             <sld:ColorMapEntry quantity="10.84" color="#7e6657" opacity="1" label="10.84 - 12.39"/>
             <sld:ColorMapEntry quantity="12.39" color="#6d5345" opacity="1" label="12.39 - 13.93"/>
             <sld:ColorMapEntry quantity="13.93" color="#5c4033" opacity="1" label="13.93 - 15.48"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>