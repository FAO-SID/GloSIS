<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADSSM1</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="-999" color="#f4e7d3" opacity="1" label="-999.00 - -893.78"/>
             <sld:ColorMapEntry quantity="-893.78" color="#e4d5c2" opacity="1" label="-893.78 - -788.56"/>
             <sld:ColorMapEntry quantity="-788.56" color="#d3c2b0" opacity="1" label="-788.56 - -683.35"/>
             <sld:ColorMapEntry quantity="-683.35" color="#c2b09e" opacity="1" label="-683.35 - -578.13"/>
             <sld:ColorMapEntry quantity="-578.13" color="#b19d8c" opacity="1" label="-578.13 - -472.91"/>
             <sld:ColorMapEntry quantity="-472.91" color="#a08b7b" opacity="1" label="-472.91 - -367.69"/>
             <sld:ColorMapEntry quantity="-367.69" color="#8f7869" opacity="1" label="-367.69 - -262.48"/>
             <sld:ColorMapEntry quantity="-262.48" color="#7e6657" opacity="1" label="-262.48 - -157.26"/>
             <sld:ColorMapEntry quantity="-157.26" color="#6d5345" opacity="1" label="-157.26 - -52.04"/>
             <sld:ColorMapEntry quantity="-52.04" color="#5c4033" opacity="1" label="-52.04 - 53.18"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>