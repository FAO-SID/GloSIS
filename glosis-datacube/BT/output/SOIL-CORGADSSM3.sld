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
             <sld:ColorMapEntry quantity="-999" color="#f4e7d3" opacity="1" label="-999.00 - -892.52"/>
             <sld:ColorMapEntry quantity="-892.52" color="#e4d5c2" opacity="1" label="-892.52 - -786.04"/>
             <sld:ColorMapEntry quantity="-786.04" color="#d3c2b0" opacity="1" label="-786.04 - -679.56"/>
             <sld:ColorMapEntry quantity="-679.56" color="#c2b09e" opacity="1" label="-679.56 - -573.08"/>
             <sld:ColorMapEntry quantity="-573.08" color="#b19d8c" opacity="1" label="-573.08 - -466.60"/>
             <sld:ColorMapEntry quantity="-466.6" color="#a08b7b" opacity="1" label="-466.60 - -360.12"/>
             <sld:ColorMapEntry quantity="-360.12" color="#8f7869" opacity="1" label="-360.12 - -253.64"/>
             <sld:ColorMapEntry quantity="-253.64" color="#7e6657" opacity="1" label="-253.64 - -147.16"/>
             <sld:ColorMapEntry quantity="-147.16" color="#6d5345" opacity="1" label="-147.16 - -40.68"/>
             <sld:ColorMapEntry quantity="-40.68" color="#5c4033" opacity="1" label="-40.68 - 65.80"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>