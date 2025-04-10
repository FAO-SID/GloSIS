<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRSSM1</sld:Name>
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
             <sld:ColorMapEntry quantity="-0.32" color="#f4e7d3" opacity="1" label="-0.32 - -0.24"/>
             <sld:ColorMapEntry quantity="-0.24" color="#e4d5c2" opacity="1" label="-0.24 - -0.16"/>
             <sld:ColorMapEntry quantity="-0.16" color="#d3c2b0" opacity="1" label="-0.16 - -0.07"/>
             <sld:ColorMapEntry quantity="-0.07" color="#c2b09e" opacity="1" label="-0.07 - 0.01"/>
             <sld:ColorMapEntry quantity="0.01" color="#b19d8c" opacity="1" label="0.01 - 0.09"/>
             <sld:ColorMapEntry quantity="0.09" color="#a08b7b" opacity="1" label="0.09 - 0.17"/>
             <sld:ColorMapEntry quantity="0.17" color="#8f7869" opacity="1" label="0.17 - 0.26"/>
             <sld:ColorMapEntry quantity="0.26" color="#7e6657" opacity="1" label="0.26 - 0.34"/>
             <sld:ColorMapEntry quantity="0.34" color="#6d5345" opacity="1" label="0.34 - 0.42"/>
             <sld:ColorMapEntry quantity="0.42" color="#5c4033" opacity="1" label="0.42 - 0.50"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>