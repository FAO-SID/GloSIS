<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGSOCSSM1</sld:Name>
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
             <sld:ColorMapEntry quantity="14.03" color="#f4e7d3" opacity="1" label="14.03 - 25.81"/>
             <sld:ColorMapEntry quantity="25.81" color="#e4d5c2" opacity="1" label="25.81 - 37.59"/>
             <sld:ColorMapEntry quantity="37.59" color="#d3c2b0" opacity="1" label="37.59 - 49.37"/>
             <sld:ColorMapEntry quantity="49.37" color="#c2b09e" opacity="1" label="49.37 - 61.15"/>
             <sld:ColorMapEntry quantity="61.15" color="#b19d8c" opacity="1" label="61.15 - 72.93"/>
             <sld:ColorMapEntry quantity="72.93" color="#a08b7b" opacity="1" label="72.93 - 84.71"/>
             <sld:ColorMapEntry quantity="84.71" color="#8f7869" opacity="1" label="84.71 - 96.49"/>
             <sld:ColorMapEntry quantity="96.49" color="#7e6657" opacity="1" label="96.49 - 108.27"/>
             <sld:ColorMapEntry quantity="108.27" color="#6d5345" opacity="1" label="108.27 - 120.05"/>
             <sld:ColorMapEntry quantity="120.05" color="#5c4033" opacity="1" label="120.05 - 131.83"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>