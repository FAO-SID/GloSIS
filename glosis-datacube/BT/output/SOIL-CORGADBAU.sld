<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADBAU</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="-999" color="#f4e7d3" opacity="1" label="-999.00 - -894.20"/>
             <sld:ColorMapEntry quantity="-894.2" color="#e4d5c2" opacity="1" label="-894.20 - -789.41"/>
             <sld:ColorMapEntry quantity="-789.41" color="#d3c2b0" opacity="1" label="-789.41 - -684.61"/>
             <sld:ColorMapEntry quantity="-684.61" color="#c2b09e" opacity="1" label="-684.61 - -579.81"/>
             <sld:ColorMapEntry quantity="-579.81" color="#b19d8c" opacity="1" label="-579.81 - -475.01"/>
             <sld:ColorMapEntry quantity="-475.01" color="#a08b7b" opacity="1" label="-475.01 - -370.22"/>
             <sld:ColorMapEntry quantity="-370.22" color="#8f7869" opacity="1" label="-370.22 - -265.42"/>
             <sld:ColorMapEntry quantity="-265.42" color="#7e6657" opacity="1" label="-265.42 - -160.62"/>
             <sld:ColorMapEntry quantity="-160.62" color="#6d5345" opacity="1" label="-160.62 - -55.83"/>
             <sld:ColorMapEntry quantity="-55.83" color="#5c4033" opacity="1" label="-55.83 - 48.97"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>