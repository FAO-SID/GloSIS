<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADSSM2</sld:Name>
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
             <sld:ColorMapEntry quantity="0.05" color="#f4e7d3" opacity="1" label="0.05 - 1.40"/>
             <sld:ColorMapEntry quantity="1.4" color="#e4d5c2" opacity="1" label="1.40 - 2.74"/>
             <sld:ColorMapEntry quantity="2.74" color="#d3c2b0" opacity="1" label="2.74 - 4.08"/>
             <sld:ColorMapEntry quantity="4.08" color="#c2b09e" opacity="1" label="4.08 - 5.43"/>
             <sld:ColorMapEntry quantity="5.43" color="#b19d8c" opacity="1" label="5.43 - 6.77"/>
             <sld:ColorMapEntry quantity="6.77" color="#a08b7b" opacity="1" label="6.77 - 8.11"/>
             <sld:ColorMapEntry quantity="8.11" color="#8f7869" opacity="1" label="8.11 - 9.46"/>
             <sld:ColorMapEntry quantity="9.46" color="#7e6657" opacity="1" label="9.46 - 10.80"/>
             <sld:ColorMapEntry quantity="10.8" color="#6d5345" opacity="1" label="10.80 - 12.14"/>
             <sld:ColorMapEntry quantity="12.14" color="#5c4033" opacity="1" label="12.14 - 13.49"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>