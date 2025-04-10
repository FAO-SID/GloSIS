<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGSOCSSM2</sld:Name>
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
             <sld:ColorMapEntry quantity="14.39" color="#f4e7d3" opacity="1" label="14.39 - 26.51"/>
             <sld:ColorMapEntry quantity="26.51" color="#e4d5c2" opacity="1" label="26.51 - 38.63"/>
             <sld:ColorMapEntry quantity="38.63" color="#d3c2b0" opacity="1" label="38.63 - 50.75"/>
             <sld:ColorMapEntry quantity="50.75" color="#c2b09e" opacity="1" label="50.75 - 62.87"/>
             <sld:ColorMapEntry quantity="62.87" color="#b19d8c" opacity="1" label="62.87 - 75.00"/>
             <sld:ColorMapEntry quantity="75" color="#a08b7b" opacity="1" label="75.00 - 87.12"/>
             <sld:ColorMapEntry quantity="87.12" color="#8f7869" opacity="1" label="87.12 - 99.24"/>
             <sld:ColorMapEntry quantity="99.24" color="#7e6657" opacity="1" label="99.24 - 111.36"/>
             <sld:ColorMapEntry quantity="111.36" color="#6d5345" opacity="1" label="111.36 - 123.48"/>
             <sld:ColorMapEntry quantity="123.48" color="#5c4033" opacity="1" label="123.48 - 135.61"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>