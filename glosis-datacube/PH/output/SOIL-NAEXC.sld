<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>NAEXC</sld:Name>
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
             <sld:ColorMapEntry quantity="0.02" color="#f4e7d3" opacity="1" label="0.02 - 1.79"/>
             <sld:ColorMapEntry quantity="1.79" color="#e4d5c2" opacity="1" label="1.79 - 3.55"/>
             <sld:ColorMapEntry quantity="3.55" color="#d3c2b0" opacity="1" label="3.55 - 5.31"/>
             <sld:ColorMapEntry quantity="5.31" color="#c2b09e" opacity="1" label="5.31 - 7.08"/>
             <sld:ColorMapEntry quantity="7.08" color="#b19d8c" opacity="1" label="7.08 - 8.84"/>
             <sld:ColorMapEntry quantity="8.84" color="#a08b7b" opacity="1" label="8.84 - 10.60"/>
             <sld:ColorMapEntry quantity="10.6" color="#8f7869" opacity="1" label="10.60 - 12.37"/>
             <sld:ColorMapEntry quantity="12.37" color="#7e6657" opacity="1" label="12.37 - 14.13"/>
             <sld:ColorMapEntry quantity="14.13" color="#6d5345" opacity="1" label="14.13 - 15.89"/>
             <sld:ColorMapEntry quantity="15.89" color="#5c4033" opacity="1" label="15.89 - 17.66"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>