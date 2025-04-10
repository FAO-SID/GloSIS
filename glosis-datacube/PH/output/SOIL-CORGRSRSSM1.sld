<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGRSRSSM1</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 0.02"/>
             <sld:ColorMapEntry quantity="0.02" color="#e4d5c2" opacity="1" label="0.02 - 0.04"/>
             <sld:ColorMapEntry quantity="0.04" color="#d3c2b0" opacity="1" label="0.04 - 0.06"/>
             <sld:ColorMapEntry quantity="0.06" color="#c2b09e" opacity="1" label="0.06 - 0.08"/>
             <sld:ColorMapEntry quantity="0.08" color="#b19d8c" opacity="1" label="0.08 - 0.10"/>
             <sld:ColorMapEntry quantity="0.1" color="#a08b7b" opacity="1" label="0.10 - 0.12"/>
             <sld:ColorMapEntry quantity="0.12" color="#8f7869" opacity="1" label="0.12 - 0.14"/>
             <sld:ColorMapEntry quantity="0.14" color="#7e6657" opacity="1" label="0.14 - 0.15"/>
             <sld:ColorMapEntry quantity="0.15" color="#6d5345" opacity="1" label="0.15 - 0.17"/>
             <sld:ColorMapEntry quantity="0.17" color="#5c4033" opacity="1" label="0.17 - 0.19"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>