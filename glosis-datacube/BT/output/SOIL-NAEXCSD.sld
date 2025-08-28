<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>NAEXCSD</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="0.02" color="#f4e7d3" opacity="1" label="0.02 - 0.29"/>
             <sld:ColorMapEntry quantity="0.29" color="#e4d5c2" opacity="1" label="0.29 - 0.56"/>
             <sld:ColorMapEntry quantity="0.56" color="#d3c2b0" opacity="1" label="0.56 - 0.83"/>
             <sld:ColorMapEntry quantity="0.83" color="#c2b09e" opacity="1" label="0.83 - 1.10"/>
             <sld:ColorMapEntry quantity="1.1" color="#b19d8c" opacity="1" label="1.10 - 1.38"/>
             <sld:ColorMapEntry quantity="1.38" color="#a08b7b" opacity="1" label="1.38 - 1.65"/>
             <sld:ColorMapEntry quantity="1.65" color="#8f7869" opacity="1" label="1.65 - 1.92"/>
             <sld:ColorMapEntry quantity="1.92" color="#7e6657" opacity="1" label="1.92 - 2.19"/>
             <sld:ColorMapEntry quantity="2.19" color="#6d5345" opacity="1" label="2.19 - 2.47"/>
             <sld:ColorMapEntry quantity="2.47" color="#5c4033" opacity="1" label="2.47 - 2.74"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>