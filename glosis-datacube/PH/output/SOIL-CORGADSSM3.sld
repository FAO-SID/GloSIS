<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADSSM3</sld:Name>
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
             <sld:ColorMapEntry quantity="0.09" color="#f4e7d3" opacity="1" label="0.09 - 2.14"/>
             <sld:ColorMapEntry quantity="2.14" color="#e4d5c2" opacity="1" label="2.14 - 4.18"/>
             <sld:ColorMapEntry quantity="4.18" color="#d3c2b0" opacity="1" label="4.18 - 6.23"/>
             <sld:ColorMapEntry quantity="6.23" color="#c2b09e" opacity="1" label="6.23 - 8.27"/>
             <sld:ColorMapEntry quantity="8.27" color="#b19d8c" opacity="1" label="8.27 - 10.32"/>
             <sld:ColorMapEntry quantity="10.32" color="#a08b7b" opacity="1" label="10.32 - 12.36"/>
             <sld:ColorMapEntry quantity="12.36" color="#8f7869" opacity="1" label="12.36 - 14.40"/>
             <sld:ColorMapEntry quantity="14.4" color="#7e6657" opacity="1" label="14.40 - 16.45"/>
             <sld:ColorMapEntry quantity="16.45" color="#6d5345" opacity="1" label="16.45 - 18.49"/>
             <sld:ColorMapEntry quantity="18.49" color="#5c4033" opacity="1" label="18.49 - 20.54"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>