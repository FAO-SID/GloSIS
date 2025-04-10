<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRSSM3</sld:Name>
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
             <sld:ColorMapEntry quantity="-0.25" color="#f4e7d3" opacity="1" label="-0.25 - -0.12"/>
             <sld:ColorMapEntry quantity="-0.12" color="#e4d5c2" opacity="1" label="-0.12 - 0.01"/>
             <sld:ColorMapEntry quantity="0.01" color="#d3c2b0" opacity="1" label="0.01 - 0.13"/>
             <sld:ColorMapEntry quantity="0.13" color="#c2b09e" opacity="1" label="0.13 - 0.26"/>
             <sld:ColorMapEntry quantity="0.26" color="#b19d8c" opacity="1" label="0.26 - 0.39"/>
             <sld:ColorMapEntry quantity="0.39" color="#a08b7b" opacity="1" label="0.39 - 0.52"/>
             <sld:ColorMapEntry quantity="0.52" color="#8f7869" opacity="1" label="0.52 - 0.64"/>
             <sld:ColorMapEntry quantity="0.64" color="#7e6657" opacity="1" label="0.64 - 0.77"/>
             <sld:ColorMapEntry quantity="0.77" color="#6d5345" opacity="1" label="0.77 - 0.90"/>
             <sld:ColorMapEntry quantity="0.9" color="#5c4033" opacity="1" label="0.90 - 1.03"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>