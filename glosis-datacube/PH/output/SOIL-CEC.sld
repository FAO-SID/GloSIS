<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CEC</sld:Name>
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
             <sld:ColorMapEntry quantity="21.07" color="#f4e7d3" opacity="1" label="21.07 - 25.90"/>
             <sld:ColorMapEntry quantity="25.9" color="#e4d5c2" opacity="1" label="25.90 - 30.73"/>
             <sld:ColorMapEntry quantity="30.73" color="#d3c2b0" opacity="1" label="30.73 - 35.56"/>
             <sld:ColorMapEntry quantity="35.56" color="#c2b09e" opacity="1" label="35.56 - 40.39"/>
             <sld:ColorMapEntry quantity="40.39" color="#b19d8c" opacity="1" label="40.39 - 45.22"/>
             <sld:ColorMapEntry quantity="45.22" color="#a08b7b" opacity="1" label="45.22 - 50.04"/>
             <sld:ColorMapEntry quantity="50.04" color="#8f7869" opacity="1" label="50.04 - 54.87"/>
             <sld:ColorMapEntry quantity="54.87" color="#7e6657" opacity="1" label="54.87 - 59.70"/>
             <sld:ColorMapEntry quantity="59.7" color="#6d5345" opacity="1" label="59.70 - 64.53"/>
             <sld:ColorMapEntry quantity="64.53" color="#5c4033" opacity="1" label="64.53 - 69.36"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>