<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>PHX</sld:Name>
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
             <sld:ColorMapEntry quantity="4.65" color="#ca0020" opacity="1" label="4.65 - 4.97"/>
             <sld:ColorMapEntry quantity="4.97" color="#bb0b35" opacity="1" label="4.97 - 5.29"/>
             <sld:ColorMapEntry quantity="5.29" color="#ac174b" opacity="1" label="5.29 - 5.61"/>
             <sld:ColorMapEntry quantity="5.61" color="#9c2260" opacity="1" label="5.61 - 5.93"/>
             <sld:ColorMapEntry quantity="5.93" color="#8d2e76" opacity="1" label="5.93 - 6.24"/>
             <sld:ColorMapEntry quantity="6.24" color="#7d398b" opacity="1" label="6.24 - 6.56"/>
             <sld:ColorMapEntry quantity="6.56" color="#6e45a1" opacity="1" label="6.56 - 6.88"/>
             <sld:ColorMapEntry quantity="6.88" color="#5e50b6" opacity="1" label="6.88 - 7.20"/>
             <sld:ColorMapEntry quantity="7.2" color="#4f5ccc" opacity="1" label="7.20 - 7.51"/>
             <sld:ColorMapEntry quantity="7.51" color="#3f68e2" opacity="1" label="7.51 - 7.83"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>