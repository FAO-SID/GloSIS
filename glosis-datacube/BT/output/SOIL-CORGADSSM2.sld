<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGADSSM2</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="-999" color="#f4e7d3" opacity="1" label="-999.00 - -893.36"/>
             <sld:ColorMapEntry quantity="-893.36" color="#e4d5c2" opacity="1" label="-893.36 - -787.72"/>
             <sld:ColorMapEntry quantity="-787.72" color="#d3c2b0" opacity="1" label="-787.72 - -682.08"/>
             <sld:ColorMapEntry quantity="-682.08" color="#c2b09e" opacity="1" label="-682.08 - -576.45"/>
             <sld:ColorMapEntry quantity="-576.45" color="#b19d8c" opacity="1" label="-576.45 - -470.81"/>
             <sld:ColorMapEntry quantity="-470.81" color="#a08b7b" opacity="1" label="-470.81 - -365.17"/>
             <sld:ColorMapEntry quantity="-365.17" color="#8f7869" opacity="1" label="-365.17 - -259.53"/>
             <sld:ColorMapEntry quantity="-259.53" color="#7e6657" opacity="1" label="-259.53 - -153.89"/>
             <sld:ColorMapEntry quantity="-153.89" color="#6d5345" opacity="1" label="-153.89 - -48.25"/>
             <sld:ColorMapEntry quantity="-48.25" color="#5c4033" opacity="1" label="-48.25 - 57.38"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>