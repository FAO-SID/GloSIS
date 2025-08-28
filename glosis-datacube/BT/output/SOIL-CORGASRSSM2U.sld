<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGASRSSM2U</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="15.36" color="#f4e7d3" opacity="1" label="15.36 - 113.73"/>
             <sld:ColorMapEntry quantity="113.73" color="#e4d5c2" opacity="1" label="113.73 - 212.09"/>
             <sld:ColorMapEntry quantity="212.09" color="#d3c2b0" opacity="1" label="212.09 - 310.45"/>
             <sld:ColorMapEntry quantity="310.45" color="#c2b09e" opacity="1" label="310.45 - 408.82"/>
             <sld:ColorMapEntry quantity="408.82" color="#b19d8c" opacity="1" label="408.82 - 507.18"/>
             <sld:ColorMapEntry quantity="507.18" color="#a08b7b" opacity="1" label="507.18 - 605.55"/>
             <sld:ColorMapEntry quantity="605.55" color="#8f7869" opacity="1" label="605.55 - 703.91"/>
             <sld:ColorMapEntry quantity="703.91" color="#7e6657" opacity="1" label="703.91 - 802.27"/>
             <sld:ColorMapEntry quantity="802.27" color="#6d5345" opacity="1" label="802.27 - 900.64"/>
             <sld:ColorMapEntry quantity="900.64" color="#5c4033" opacity="1" label="900.64 - 999.00"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>