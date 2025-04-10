<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGSSMU</sld:Name>
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
             <sld:ColorMapEntry quantity="9.56" color="#f4e7d3" opacity="1" label="9.56 - 11.85"/>
             <sld:ColorMapEntry quantity="11.85" color="#e4d5c2" opacity="1" label="11.85 - 14.13"/>
             <sld:ColorMapEntry quantity="14.13" color="#d3c2b0" opacity="1" label="14.13 - 16.42"/>
             <sld:ColorMapEntry quantity="16.42" color="#c2b09e" opacity="1" label="16.42 - 18.70"/>
             <sld:ColorMapEntry quantity="18.7" color="#b19d8c" opacity="1" label="18.70 - 20.99"/>
             <sld:ColorMapEntry quantity="20.99" color="#a08b7b" opacity="1" label="20.99 - 23.27"/>
             <sld:ColorMapEntry quantity="23.27" color="#8f7869" opacity="1" label="23.27 - 25.56"/>
             <sld:ColorMapEntry quantity="25.56" color="#7e6657" opacity="1" label="25.56 - 27.84"/>
             <sld:ColorMapEntry quantity="27.84" color="#6d5345" opacity="1" label="27.84 - 30.12"/>
             <sld:ColorMapEntry quantity="30.12" color="#5c4033" opacity="1" label="30.12 - 32.41"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>