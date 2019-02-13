<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" version="1.0">

  <xsl:output method="text"/>
  <xsl:variable name="TAB" select="'&#9;'"/>
  <xsl:variable name="EOL" select="'&#xD;&#xA;'"/>
  <xsl:variable name="dtdelim" select="':'"/>

  <xsl:template name="OsirisExport">
    <export>
      <name>Injection Information File</name>
      <file-extension>tab</file-extension>
      <extension-override>true</extension-override>
      <default-location>*A</default-location>
    </export>
  </xsl:template>

  <xsl:template name="sSplit">
    <xsl:param name="s"/>
    <xsl:param name="delim" select="$dtdelim"/>
    <xsl:choose>
      <xsl:when test="not(string-length($s))"/>
      <xsl:when test="contains($s,$delim)">
        <x><xsl:value-of select="substring-before($s,$delim)"/></x>
        <xsl:call-template name="sSplit">
          <xsl:with-param name="s" select="substring-after($s,$delim)"/>
          <xsl:with-param name="delim" select="$delim"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <x>
          <xsl:value-of select="$s"/>
        </x>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ShowDate">
    <xsl:param name="date"/>
    <xsl:variable name="tmpxdate">
      <xml>
        <xsl:call-template name="sSplit">
          <xsl:with-param name="s" select="$date"/>
        </xsl:call-template>
      </xml>
    </xsl:variable>
    <xsl:variable name="xdate" select="exsl:node-set($tmpxdate)"/>
    <xsl:choose>
      <xsl:when test="count($xdate//x) = 3">
        <xsl:variable name="y" select="$xdate//x[1]"/>
        <xsl:variable name="m" select="concat('00',$xdate//x[2])"/>
        <xsl:variable name="d" select="concat('00',$xdate//x[3])"/>
        <xsl:value-of select="$y"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($m,string-length($m) - 1)"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="substring($m,string-length($m) - 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$date"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ShowTime">
    <xsl:param name="time"/>
    <xsl:variable name="tmpxtime">
      <xml>
        <xsl:call-template name="sSplit">
          <xsl:with-param name="s" select="$time"/>
        </xsl:call-template>
      </xml>
    </xsl:variable>
    <xsl:variable name="xtime" select="exsl:node-set($tmpxtime)"/>
    <xsl:choose>
      <xsl:when test="count($xtime//x) &gt; 2">
        <xsl:variable name="h" select="concat('00',$xtime//x[1])"/>
        <xsl:variable name="m" select="concat('00',$xtime//x[2])"/>
        <xsl:variable name="s" select="concat('00',$xtime//x[3])"/>
        <xsl:value-of select="substring($h,string-length($h) - 1)"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="substring($m,string-length($m) - 1)"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="substring($s,string-length($s) - 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$time"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="header">
    <xsl:text>File name</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Sample name</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Injection voltage</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Injection seconds</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Run date</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Run time</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Capillary number</xsl:text>
    <xsl:value-of select="$EOL"/>
  </xsl:template>
  <xsl:template match="/">
    <xsl:call-template name="header"/>
    <xsl:for-each select="/OsirisAnalysisReport/Table/Sample">
      <xsl:sort select="Type"/>
      <xsl:value-of select="Name"/>
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="SampleName"/>
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="Info/InjectionVoltage"/>
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="Info/InjectionSeconds"/>
      <xsl:value-of select="$TAB"/>
      <xsl:call-template name="ShowDate">
        <xsl:with-param name="date" select="Info/RunDate"/>
      </xsl:call-template>
      <xsl:value-of select="$TAB"/>
      <xsl:call-template name="ShowTime">
        <xsl:with-param name="time" select="Info/RunTime"/>
      </xsl:call-template>
      <xsl:value-of select="$TAB"/>
      <xsl:value-of select="Info/CapillaryNumber"/>
      <xsl:value-of select="$EOL"/>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>