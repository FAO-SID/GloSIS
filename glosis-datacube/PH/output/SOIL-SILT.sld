<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>SILT</sld:Name>
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
             <sld:ColorMapEntry quantity="18" color="#f4e7d3" opacity="1" label="18.00 - 20.77"/>
             <sld:ColorMapEntry quantity="20.77" color="#e4d5c2" opacity="1" label="20.77 - 23.54"/>
             <sld:ColorMapEntry quantity="23.54" color="#d3c2b0" opacity="1" label="23.54 - 26.30"/>
             <sld:ColorMapEntry quantity="26.3" color="#c2b09e" opacity="1" label="26.30 - 29.07"/>
             <sld:ColorMapEntry quantity="29.07" color="#b19d8c" opacity="1" label="29.07 - 31.84"/>
             <sld:ColorMapEntry quantity="31.84" color="#a08b7b" opacity="1" label="31.84 - 34.61"/>
             <sld:ColorMapEntry quantity="34.61" color="#8f7869" opacity="1" label="34.61 - 37.37"/>
             <sld:ColorMapEntry quantity="37.37" color="#7e6657" opacity="1" label="37.37 - 40.14"/>
             <sld:ColorMapEntry quantity="40.14" color="#6d5345" opacity="1" label="40.14 - 42.91"/>
             <sld:ColorMapEntry quantity="42.91" color="#5c4033" opacity="1" label="42.91 - 45.68"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>