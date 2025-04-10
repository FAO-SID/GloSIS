<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADBAU</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 0.66"/>
             <sld:ColorMapEntry quantity="0.66" color="#e4d5c2" opacity="1" label="0.66 - 1.31"/>
             <sld:ColorMapEntry quantity="1.31" color="#d3c2b0" opacity="1" label="1.31 - 1.97"/>
             <sld:ColorMapEntry quantity="1.97" color="#c2b09e" opacity="1" label="1.97 - 2.63"/>
             <sld:ColorMapEntry quantity="2.63" color="#b19d8c" opacity="1" label="2.63 - 3.28"/>
             <sld:ColorMapEntry quantity="3.28" color="#a08b7b" opacity="1" label="3.28 - 3.94"/>
             <sld:ColorMapEntry quantity="3.94" color="#8f7869" opacity="1" label="3.94 - 4.60"/>
             <sld:ColorMapEntry quantity="4.6" color="#7e6657" opacity="1" label="4.60 - 5.25"/>
             <sld:ColorMapEntry quantity="5.25" color="#6d5345" opacity="1" label="5.25 - 5.91"/>
             <sld:ColorMapEntry quantity="5.91" color="#5c4033" opacity="1" label="5.91 - 6.56"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>