<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRSSM2</sld:Name>
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
             <sld:ColorMapEntry quantity="-0.3" color="#f4e7d3" opacity="1" label="-0.30 - -0.20"/>
             <sld:ColorMapEntry quantity="-0.2" color="#e4d5c2" opacity="1" label="-0.20 - -0.10"/>
             <sld:ColorMapEntry quantity="-0.1" color="#d3c2b0" opacity="1" label="-0.10 - 0.00"/>
             <sld:ColorMapEntry quantity="0" color="#c2b09e" opacity="1" label="0.00 - 0.09"/>
             <sld:ColorMapEntry quantity="0.09" color="#b19d8c" opacity="1" label="0.09 - 0.19"/>
             <sld:ColorMapEntry quantity="0.19" color="#a08b7b" opacity="1" label="0.19 - 0.29"/>
             <sld:ColorMapEntry quantity="0.29" color="#8f7869" opacity="1" label="0.29 - 0.38"/>
             <sld:ColorMapEntry quantity="0.38" color="#7e6657" opacity="1" label="0.38 - 0.48"/>
             <sld:ColorMapEntry quantity="0.48" color="#6d5345" opacity="1" label="0.48 - 0.58"/>
             <sld:ColorMapEntry quantity="0.58" color="#5c4033" opacity="1" label="0.58 - 0.67"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>