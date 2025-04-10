<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>SAND</sld:Name>
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
             <sld:ColorMapEntry quantity="10.48" color="#f4e7d3" opacity="1" label="10.48 - 15.76"/>
             <sld:ColorMapEntry quantity="15.76" color="#e4d5c2" opacity="1" label="15.76 - 21.03"/>
             <sld:ColorMapEntry quantity="21.03" color="#d3c2b0" opacity="1" label="21.03 - 26.31"/>
             <sld:ColorMapEntry quantity="26.31" color="#c2b09e" opacity="1" label="26.31 - 31.59"/>
             <sld:ColorMapEntry quantity="31.59" color="#b19d8c" opacity="1" label="31.59 - 36.86"/>
             <sld:ColorMapEntry quantity="36.86" color="#a08b7b" opacity="1" label="36.86 - 42.14"/>
             <sld:ColorMapEntry quantity="42.14" color="#8f7869" opacity="1" label="42.14 - 47.42"/>
             <sld:ColorMapEntry quantity="47.42" color="#7e6657" opacity="1" label="47.42 - 52.70"/>
             <sld:ColorMapEntry quantity="52.7" color="#6d5345" opacity="1" label="52.70 - 57.97"/>
             <sld:ColorMapEntry quantity="57.97" color="#5c4033" opacity="1" label="57.97 - 63.25"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>