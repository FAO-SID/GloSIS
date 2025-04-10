<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGRSRSSM3</sld:Name>
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
             <sld:ColorMapEntry quantity="0" color="#f4e7d3" opacity="1" label="0.00 - 0.08"/>
             <sld:ColorMapEntry quantity="0.08" color="#e4d5c2" opacity="1" label="0.08 - 0.15"/>
             <sld:ColorMapEntry quantity="0.15" color="#d3c2b0" opacity="1" label="0.15 - 0.23"/>
             <sld:ColorMapEntry quantity="0.23" color="#c2b09e" opacity="1" label="0.23 - 0.31"/>
             <sld:ColorMapEntry quantity="0.31" color="#b19d8c" opacity="1" label="0.31 - 0.39"/>
             <sld:ColorMapEntry quantity="0.39" color="#a08b7b" opacity="1" label="0.39 - 0.46"/>
             <sld:ColorMapEntry quantity="0.46" color="#8f7869" opacity="1" label="0.46 - 0.54"/>
             <sld:ColorMapEntry quantity="0.54" color="#7e6657" opacity="1" label="0.54 - 0.62"/>
             <sld:ColorMapEntry quantity="0.62" color="#6d5345" opacity="1" label="0.62 - 0.70"/>
             <sld:ColorMapEntry quantity="0.7" color="#5c4033" opacity="1" label="0.70 - 0.77"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>