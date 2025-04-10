<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGSOCBAU</sld:Name>
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
             <sld:ColorMapEntry quantity="13.68" color="#f4e7d3" opacity="1" label="13.68 - 25.12"/>
             <sld:ColorMapEntry quantity="25.12" color="#e4d5c2" opacity="1" label="25.12 - 36.56"/>
             <sld:ColorMapEntry quantity="36.56" color="#d3c2b0" opacity="1" label="36.56 - 47.99"/>
             <sld:ColorMapEntry quantity="47.99" color="#c2b09e" opacity="1" label="47.99 - 59.43"/>
             <sld:ColorMapEntry quantity="59.43" color="#b19d8c" opacity="1" label="59.43 - 70.87"/>
             <sld:ColorMapEntry quantity="70.87" color="#a08b7b" opacity="1" label="70.87 - 82.31"/>
             <sld:ColorMapEntry quantity="82.31" color="#8f7869" opacity="1" label="82.31 - 93.74"/>
             <sld:ColorMapEntry quantity="93.74" color="#7e6657" opacity="1" label="93.74 - 105.18"/>
             <sld:ColorMapEntry quantity="105.18" color="#6d5345" opacity="1" label="105.18 - 116.62"/>
             <sld:ColorMapEntry quantity="116.62" color="#5c4033" opacity="1" label="116.62 - 128.06"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>