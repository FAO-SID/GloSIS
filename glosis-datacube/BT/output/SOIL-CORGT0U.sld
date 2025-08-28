<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" version="1.0.0" xmlns:sld="http://www.opengis.net/sld" xmlns:gml="http://www.opengis.net/gml" xmlns:ogc="http://www.opengis.net/ogc">
  <UserLayer>
    <sld:LayerFeatureConstraints>
      <sld:FeatureTypeConstraint/>
    </sld:LayerFeatureConstraints>
    <sld:UserStyle>
      <sld:Name>CORGT0U</sld:Name>
      <sld:FeatureTypeStyle>
        <sld:Rule>
          <sld:RasterSymbolizer>
            <sld:ChannelSelection>
              <sld:GrayChannel>
                <sld:SourceChannelName>1</sld:SourceChannelName>
              </sld:GrayChannel>
            </sld:ChannelSelection>
            <sld:ColorMap type="intervals">
             <sld:ColorMapEntry quantity="-999" color="#f4e7d3" opacity="1" label="-999.00 - -842.40"/>
             <sld:ColorMapEntry quantity="-842.4" color="#e4d5c2" opacity="1" label="-842.40 - -685.80"/>
             <sld:ColorMapEntry quantity="-685.8" color="#d3c2b0" opacity="1" label="-685.80 - -529.20"/>
             <sld:ColorMapEntry quantity="-529.2" color="#c2b09e" opacity="1" label="-529.20 - -372.60"/>
             <sld:ColorMapEntry quantity="-372.6" color="#b19d8c" opacity="1" label="-372.60 - -216.00"/>
             <sld:ColorMapEntry quantity="-216" color="#a08b7b" opacity="1" label="-216.00 - -59.40"/>
             <sld:ColorMapEntry quantity="-59.4" color="#8f7869" opacity="1" label="-59.40 - 97.20"/>
             <sld:ColorMapEntry quantity="97.2" color="#7e6657" opacity="1" label="97.20 - 253.80"/>
             <sld:ColorMapEntry quantity="253.8" color="#6d5345" opacity="1" label="253.80 - 410.40"/>
             <sld:ColorMapEntry quantity="410.4" color="#5c4033" opacity="1" label="410.40 - 567.00"/>
            </sld:ColorMap>
          </sld:RasterSymbolizer>
        </sld:Rule>
      </sld:FeatureTypeStyle>
    </sld:UserStyle>
  </UserLayer>
</StyledLayerDescriptor>