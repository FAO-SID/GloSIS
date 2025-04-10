<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORG</sld:Name>
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
             <sld:ColorMapEntry quantity="16.38" color="#f4e7d3" opacity="1" label="16.38 - 22.38"/>
             <sld:ColorMapEntry quantity="22.38" color="#e4d5c2" opacity="1" label="22.38 - 28.38"/>
             <sld:ColorMapEntry quantity="28.38" color="#d3c2b0" opacity="1" label="28.38 - 34.38"/>
             <sld:ColorMapEntry quantity="34.38" color="#c2b09e" opacity="1" label="34.38 - 40.38"/>
             <sld:ColorMapEntry quantity="40.38" color="#b19d8c" opacity="1" label="40.38 - 46.38"/>
             <sld:ColorMapEntry quantity="46.38" color="#a08b7b" opacity="1" label="46.38 - 52.39"/>
             <sld:ColorMapEntry quantity="52.39" color="#8f7869" opacity="1" label="52.39 - 58.39"/>
             <sld:ColorMapEntry quantity="58.39" color="#7e6657" opacity="1" label="58.39 - 64.39"/>
             <sld:ColorMapEntry quantity="64.39" color="#6d5345" opacity="1" label="64.39 - 70.39"/>
             <sld:ColorMapEntry quantity="70.39" color="#5c4033" opacity="1" label="70.39 - 76.39"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>