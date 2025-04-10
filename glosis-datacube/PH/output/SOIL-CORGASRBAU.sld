<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRBAU</sld:Name>
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
             <sld:ColorMapEntry quantity="-0.34" color="#f4e7d3" opacity="1" label="-0.34 - -0.28"/>
             <sld:ColorMapEntry quantity="-0.28" color="#e4d5c2" opacity="1" label="-0.28 - -0.21"/>
             <sld:ColorMapEntry quantity="-0.21" color="#d3c2b0" opacity="1" label="-0.21 - -0.14"/>
             <sld:ColorMapEntry quantity="-0.14" color="#c2b09e" opacity="1" label="-0.14 - -0.07"/>
             <sld:ColorMapEntry quantity="-0.07" color="#b19d8c" opacity="1" label="-0.07 - -0.01"/>
             <sld:ColorMapEntry quantity="-0.01" color="#a08b7b" opacity="1" label="-0.01 - 0.06"/>
             <sld:ColorMapEntry quantity="0.06" color="#8f7869" opacity="1" label="0.06 - 0.13"/>
             <sld:ColorMapEntry quantity="0.13" color="#7e6657" opacity="1" label="0.13 - 0.19"/>
             <sld:ColorMapEntry quantity="0.19" color="#6d5345" opacity="1" label="0.19 - 0.26"/>
             <sld:ColorMapEntry quantity="0.26" color="#5c4033" opacity="1" label="0.26 - 0.33"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>