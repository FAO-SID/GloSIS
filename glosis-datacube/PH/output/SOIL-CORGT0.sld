<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGT0</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 12.35"/>
             <sld:ColorMapEntry quantity="12.35" color="#e4d5c2" opacity="1" label="12.35 - 24.69"/>
             <sld:ColorMapEntry quantity="24.69" color="#d3c2b0" opacity="1" label="24.69 - 37.04"/>
             <sld:ColorMapEntry quantity="37.04" color="#c2b09e" opacity="1" label="37.04 - 49.39"/>
             <sld:ColorMapEntry quantity="49.39" color="#b19d8c" opacity="1" label="49.39 - 61.73"/>
             <sld:ColorMapEntry quantity="61.73" color="#a08b7b" opacity="1" label="61.73 - 74.08"/>
             <sld:ColorMapEntry quantity="74.08" color="#8f7869" opacity="1" label="74.08 - 86.43"/>
             <sld:ColorMapEntry quantity="86.43" color="#7e6657" opacity="1" label="86.43 - 98.77"/>
             <sld:ColorMapEntry quantity="98.77" color="#6d5345" opacity="1" label="98.77 - 111.12"/>
             <sld:ColorMapEntry quantity="111.12" color="#5c4033" opacity="1" label="111.12 - 123.47"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>