<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRSSM3U</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="15.39" color="#f4e7d3" opacity="1" label="15.39 - 113.75"/>
             <sld:ColorMapEntry quantity="113.75" color="#e4d5c2" opacity="1" label="113.75 - 212.11"/>
             <sld:ColorMapEntry quantity="212.11" color="#d3c2b0" opacity="1" label="212.11 - 310.47"/>
             <sld:ColorMapEntry quantity="310.47" color="#c2b09e" opacity="1" label="310.47 - 408.83"/>
             <sld:ColorMapEntry quantity="408.83" color="#b19d8c" opacity="1" label="408.83 - 507.19"/>
             <sld:ColorMapEntry quantity="507.19" color="#a08b7b" opacity="1" label="507.19 - 605.55"/>
             <sld:ColorMapEntry quantity="605.55" color="#8f7869" opacity="1" label="605.55 - 703.92"/>
             <sld:ColorMapEntry quantity="703.92" color="#7e6657" opacity="1" label="703.92 - 802.28"/>
             <sld:ColorMapEntry quantity="802.28" color="#6d5345" opacity="1" label="802.28 - 900.64"/>
             <sld:ColorMapEntry quantity="900.64" color="#5c4033" opacity="1" label="900.64 - 999.00"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>