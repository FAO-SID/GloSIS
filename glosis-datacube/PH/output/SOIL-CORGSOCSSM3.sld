<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGSOCSSM3</sld:Name>
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
             <sld:ColorMapEntry quantity="15.08" color="#f4e7d3" opacity="1" label="15.08 - 27.89"/>
             <sld:ColorMapEntry quantity="27.89" color="#e4d5c2" opacity="1" label="27.89 - 40.71"/>
             <sld:ColorMapEntry quantity="40.71" color="#d3c2b0" opacity="1" label="40.71 - 53.52"/>
             <sld:ColorMapEntry quantity="53.52" color="#c2b09e" opacity="1" label="53.52 - 66.34"/>
             <sld:ColorMapEntry quantity="66.34" color="#b19d8c" opacity="1" label="66.34 - 79.15"/>
             <sld:ColorMapEntry quantity="79.15" color="#a08b7b" opacity="1" label="79.15 - 91.97"/>
             <sld:ColorMapEntry quantity="91.97" color="#8f7869" opacity="1" label="91.97 - 104.78"/>
             <sld:ColorMapEntry quantity="104.78" color="#7e6657" opacity="1" label="104.78 - 117.60"/>
             <sld:ColorMapEntry quantity="117.6" color="#6d5345" opacity="1" label="117.60 - 130.41"/>
             <sld:ColorMapEntry quantity="130.41" color="#5c4033" opacity="1" label="130.41 - 143.23"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>