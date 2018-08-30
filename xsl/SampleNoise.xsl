<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

  <xsl:output method="text"/>

  <xsl:variable name="DELIM" select="'&#9;'"/>
  <xsl:variable name="EOL" select="'&#10;'"/>

  <xsl:template name="Header">
    <xsl:variable name="xNoise" select="(/OsirisAnalysisReport/Table/Sample/Info)[1]"/>

    <xsl:text>Sample</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Max Linear PU</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Max Nonlinear PU</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Max Error</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Width Last ILS</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Locus Area Ratio</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text> YSTR Area Ratio</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Start Temp</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Temp Diff</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Start Voltage</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Voltage Diff</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Start Curr</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text> Curr Diff</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>start Power</xsl:text>
    <xsl:value-of select="$DELIM"/>
    <xsl:text>Power Diff</xsl:text>
    <xsl:for-each select="$xNoise/Channel">
      <xsl:value-of select="$DELIM"/>
      <xsl:text>Ch</xsl:text>
      <xsl:value-of select="Number"/>
      <xsl:text> Noise</xsl:text>

      <xsl:value-of select="$DELIM"/>
      <xsl:text>Ch</xsl:text>
      <xsl:value-of select="Number"/>
      <xsl:text> Locus Area Ratio</xsl:text>

      <xsl:value-of select="$DELIM"/>
      <xsl:text>Ch</xsl:text>
      <xsl:value-of select="Number"/>
      <xsl:text> YSTR Area Ratio</xsl:text>

    </xsl:for-each>
    <xsl:value-of select="$EOL"/>
  </xsl:template>



  <xsl:template match="/">
    <xsl:if test="/OsirisAnalysisReport/Table/Sample/Info">
      <xsl:call-template name="Header"/>
      <xsl:for-each select="/OsirisAnalysisReport/Table/Sample/Info">
        <xsl:value-of select="../Name"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxLinearPullup"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxNonlinearPullup"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxBPErrorSampleToLadder"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="WidthOfLastILSPeak"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="SampleLocusTotalAreaRatioMaxToMin"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="SampleYLinkedLocusTotalAreaRatioMaxToMin"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="StartingTemperature"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxMinusMinTemperature"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="StartingVoltage"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxMinusMinVoltage"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="StartingCurrent"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxMinusMinCurrent"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="StartingPower"/>

        <xsl:value-of select="$DELIM"/>
        <xsl:value-of select="MaxMinusMinPower"/>

        <xsl:for-each select="Channel">
          <xsl:value-of select="$DELIM"/>
          <xsl:value-of select="Noise"/>
          <xsl:value-of select="$DELIM"/>
          <xsl:value-of select="ChannelLocusTotalAreaRatioMaxToMin"/>
          <xsl:value-of select="$DELIM"/>
          <xsl:value-of select="ChannelYLinkedLocusTotalAreaMaxToMin"/>
        </xsl:for-each>
        <xsl:value-of select="$EOL"/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
