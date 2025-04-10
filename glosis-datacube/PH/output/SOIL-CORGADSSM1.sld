<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADSSM1</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 1.00"/>
             <sld:ColorMapEntry quantity="1" color="#e4d5c2" opacity="1" label="1.00 - 2.01"/>
             <sld:ColorMapEntry quantity="2.01" color="#d3c2b0" opacity="1" label="2.01 - 3.01"/>
             <sld:ColorMapEntry quantity="3.01" color="#c2b09e" opacity="1" label="3.01 - 4.01"/>
             <sld:ColorMapEntry quantity="4.01" color="#b19d8c" opacity="1" label="4.01 - 5.01"/>
             <sld:ColorMapEntry quantity="5.01" color="#a08b7b" opacity="1" label="5.01 - 6.02"/>
             <sld:ColorMapEntry quantity="6.02" color="#8f7869" opacity="1" label="6.02 - 7.02"/>
             <sld:ColorMapEntry quantity="7.02" color="#7e6657" opacity="1" label="7.02 - 8.02"/>
             <sld:ColorMapEntry quantity="8.02" color="#6d5345" opacity="1" label="8.02 - 9.02"/>
             <sld:ColorMapEntry quantity="9.02" color="#5c4033" opacity="1" label="9.02 - 10.03"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>