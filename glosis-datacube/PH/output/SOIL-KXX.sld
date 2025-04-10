<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>KXX</sld:Name>
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
             <sld:ColorMapEntry quantity="0.16" color="#f4e7d3" opacity="1" label="0.16 - 8.09"/>
             <sld:ColorMapEntry quantity="8.09" color="#e4d5c2" opacity="1" label="8.09 - 16.02"/>
             <sld:ColorMapEntry quantity="16.02" color="#d3c2b0" opacity="1" label="16.02 - 23.94"/>
             <sld:ColorMapEntry quantity="23.94" color="#c2b09e" opacity="1" label="23.94 - 31.87"/>
             <sld:ColorMapEntry quantity="31.87" color="#b19d8c" opacity="1" label="31.87 - 39.80"/>
             <sld:ColorMapEntry quantity="39.8" color="#a08b7b" opacity="1" label="39.80 - 47.72"/>
             <sld:ColorMapEntry quantity="47.72" color="#8f7869" opacity="1" label="47.72 - 55.65"/>
             <sld:ColorMapEntry quantity="55.65" color="#7e6657" opacity="1" label="55.65 - 63.58"/>
             <sld:ColorMapEntry quantity="63.58" color="#6d5345" opacity="1" label="63.58 - 71.50"/>
             <sld:ColorMapEntry quantity="71.5" color="#5c4033" opacity="1" label="71.50 - 79.43"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>