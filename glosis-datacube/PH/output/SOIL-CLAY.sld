<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CLAY</sld:Name>
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
             <sld:ColorMapEntry quantity="27.36" color="#f4e7d3" opacity="1" label="27.36 - 31.34"/>
             <sld:ColorMapEntry quantity="31.34" color="#e4d5c2" opacity="1" label="31.34 - 35.32"/>
             <sld:ColorMapEntry quantity="35.32" color="#d3c2b0" opacity="1" label="35.32 - 39.30"/>
             <sld:ColorMapEntry quantity="39.3" color="#c2b09e" opacity="1" label="39.30 - 43.28"/>
             <sld:ColorMapEntry quantity="43.28" color="#b19d8c" opacity="1" label="43.28 - 47.26"/>
             <sld:ColorMapEntry quantity="47.26" color="#a08b7b" opacity="1" label="47.26 - 51.24"/>
             <sld:ColorMapEntry quantity="51.24" color="#8f7869" opacity="1" label="51.24 - 55.22"/>
             <sld:ColorMapEntry quantity="55.22" color="#7e6657" opacity="1" label="55.22 - 59.20"/>
             <sld:ColorMapEntry quantity="59.2" color="#6d5345" opacity="1" label="59.20 - 63.18"/>
             <sld:ColorMapEntry quantity="63.18" color="#5c4033" opacity="1" label="63.18 - 67.16"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>