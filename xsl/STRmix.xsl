<?xml version="1.0" encoding="utf-8"?>
<!--
#
# ===========================================================================
#
#                            PUBLIC DOMAIN NOTICE
#               National Center for Biotechnology Information
#
#  This software/database is a "United States Government Work" under the
#  terms of the United States Copyright Act.  It was written as part of
#  the author's official duties as a United States Government employee and
#  thus cannot be copyrighted.  This software/database is freely available
#  to the public for use. The National Library of Medicine and the U.S.
#  Government have not placed any restriction on its use or reproduction.
#
#  Although all reasonable efforts have been taken to ensure the accuracy
#  and reliability of the software and data, the NLM and the U.S.
#  Government do not and cannot warrant the performance or results that
#  may be obtained by using this software or data. The NLM and the U.S.
#  Government disclaim all warranties, express or implied, including
#  warranties of performance, merchantability or fitness for any particular
#  purpose.
#
#  Please cite the author in any work or product based on this material.
#
# ===========================================================================
#
#  FileName: STRmix.xsl
#  Author:   Douglas Hoffman
#  Description:  Export allele info from OSIRIS analysis file to a
#   tab-delimited text file
#
  Columns:
    Sample file     File name (fsa/hid
    Marker          Locus
    Allele 1        Allele call
    Allele 2        Allele call
    .....
    Allele 25       Allele call
    Size 1          Basepairs
    Size 2          Basepairs
    .....
    Size 25         Basepairs
    Height 1        RFU
    Height 2        RFU
    .....
    Height 25       RFU
#
-->
    <xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:func="http://exslt.org/functions"
  xmlns:exsl="http://exslt.org/common"
  xmlns:os="http://www.ncbi.nlm.nih.gov/projects/SNP/osiris/"
  extension-element-prefixes="func exsl os"
  version="1.0">

  <xsl:import href="util.xsl"/>
  <xsl:output method="text"/>

  <xsl:param name="ILSBPS" select="1"/>
  <xsl:param name="DECBPS" select="1"/>
  <xsl:variable name="TAB" select="'&#9;'"/>
  <xsl:variable name="EOL" select="'&#10;'"/>
  <xsl:variable name="repeats" select="25"/>

  <xsl:variable name="fileExt">
    <xsl:variable name="ts" 
      select="string(/OsirisAnalysisReport/LabSettings/Info/DataFileType)"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="$ts"/>
    <xsl:if test="string-length($ts) = 0">
      <xsl:text>fsa</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:template name="OsirisExport">
    <export>
      <name>STRmix</name>
      <file-extension>tab</file-extension>
      <file-extension>txt</file-extension>
      <extension-override>true</extension-override>
      <default-location>*A</default-location>
      <xsl-params>
        <param>
          <name>ILSBPS</name>
          <description>Use ILS Ref. BPS</description>
          <type>checkbox</type>
          <checked-value>1</checked-value>
          <unchecked-value>0</unchecked-value>
        </param>
        <param>
          <name>DECBPS</name>
          <description>Round BPS to nearest integer</description>
          <type>checkbox</type>
          <checked-value>0</checked-value>
          <unchecked-value>1</unchecked-value>
        </param>
      </xsl-params>
    </export>
  </xsl:template>
  
  <xsl:template name="HeaderLoop">
    <xsl:param name="label"/>
    <xsl:param name="begin" select="1"/>
    <xsl:param name="end" select="$repeats"/>
    <xsl:choose>
      <xsl:when test="$end &gt; $begin">
        <xsl:variable name="mid" select="floor( ($begin + $end) * 0.5 )"/>
        <xsl:call-template name="HeaderLoop">
          <xsl:with-param name="label" select="$label"/>
          <xsl:with-param name="begin" select="$begin"/>
          <xsl:with-param name="end" select="$mid"/>
        </xsl:call-template>
        <xsl:call-template name="HeaderLoop">
          <xsl:with-param name="label" select="$label"/>
          <xsl:with-param name="begin" select="$mid + 1"/>
          <xsl:with-param name="end" select="$end"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$TAB"/>
        <xsl:value-of select="$label"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$begin"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  
  <xsl:template name="Header">
    <xsl:text>Sample File</xsl:text>
    <xsl:value-of select="$TAB"/>
    <xsl:text>Marker</xsl:text>
    <xsl:call-template name="HeaderLoop">
      <xsl:with-param name="label" select="'Allele'"/>
    </xsl:call-template>
    <xsl:call-template name="HeaderLoop">
      <xsl:with-param name="label" select="'Size'"/>
    </xsl:call-template>
    <xsl:call-template name="HeaderLoop">
      <xsl:with-param name="label" select="'Height'"/>
    </xsl:call-template>
    <xsl:value-of select="$EOL"/>
  </xsl:template>


  <xsl:template name="Repeat">
    <xsl:param name="node" select="$TAB"/>
    <xsl:param name="count" select="0"/>
    <xsl:choose>
      <xsl:when test="$count = 1">
        <xsl:copy-of select="$node"/>
      </xsl:when>
      <xsl:when test="$count = 2">
        <xsl:copy-of select="$node"/>
        <xsl:copy-of select="$node"/>
      </xsl:when>
      <xsl:when test="$count &gt; 2">
        <xsl:variable name="half" select="floor($count * 0.5)"/>
        <xsl:call-template name="Repeat">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="count" select="$half"/>
        </xsl:call-template>
        <xsl:call-template name="Repeat">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="count" select="$count - $half"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template name="isEnabled">
    <xsl:param name="sample"/>
    <xsl:variable name="rtn">
      <xsl:choose>
        <xsl:when test="not($sample)">
          <xsl:value-of select="0"/>
        </xsl:when>
        <xsl:when test="$sample/EnableHistory/Enable">
          <xsl:for-each select="$sample/EnableHistory/Enable">
            <xsl:sort select="Time" order="descending" data-type="number"/>
            <xsl:choose>
              <xsl:when test="position() != 1"/>
              <xsl:when test="Enabled = 'true'">
                <xsl:value-of select="1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$rtn"/>
  </xsl:template>

  <func:function name="os:isEnabled">
    <xsl:param name="sample"/>
    <xsl:variable name="x">
      <xsl:call-template name="isEnabled">
        <xsl:with-param name="sample" select="$sample"/>
      </xsl:call-template>
    </xsl:variable>
    <func:result select="boolean(number($x))"/>
  </func:function>

  <func:function name="os:isAlleleEnabled">
    <xsl:param name="Allele"/>
    <xsl:variable name="x" select="boolean(not($Allele/Disabled) or ($Allele/Disabled != 'true'))"/>
    <func:result select="$x"/>
  </func:function>

  <func:function name="os:hasAlleles">
    <xsl:param name="sample"/>
    <xsl:variable name="x" select="boolean($sample/Locus/Allele[os:isAlleleEnabled(.)])"/>
    <func:result select="$x"/>
  </func:function>
  
  <func:function name="os:hasLocusAlleles">
    <xsl:param name="locus"/>
    <xsl:variable name="x" select="boolean($locus/Allele[os:isAlleleEnabled(.)])"/>
    <func:result select="$x"/>
  </func:function>
    
  <xsl:template name="writeSample">
    <xsl:param name="sample"/>
    <xsl:variable name="LineStart">
      <xsl:value-of select="$sample/Name"/>
      <xsl:value-of select="$fileExt"/>
      <xsl:value-of select="$TAB"/>
    </xsl:variable>

    <!-- loop through sample loci -->

    <xsl:for-each select="$sample/Locus[os:hasLocusAlleles(.)]">
      <xsl:variable name="tmpAlleleExpand">
        <!--  repeat each Allele element by its Count element value  -->
        <xsl:for-each select="Allele[os:isAlleleEnabled(.)]">
          <xsl:copy-of select="."/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="AlleleNodeSet" select="exsl:node-set($tmpAlleleExpand)"/>
      <xsl:variable name="AlleleExpand" select="$AlleleNodeSet/Allele[position() &lt;= $repeats]"/>
      <xsl:variable name="AlleleCount" select="count($AlleleNodeSet/Allele)"/>
      <xsl:if test="$AlleleCount &gt; $repeats">
        <xsl:message>
          <xsl:value-of select="$sample/Name"/>
          <xsl:value-of select="$fileExt"/>
          <xsl:text>, locus </xsl:text>
          <xsl:value-of select="LocusName"/>
          <xsl:text>, has </xsl:text>
          <xsl:value-of select="$AlleleCount"/>
          <xsl:text> alleles.  </xsl:text>
          <xsl:value-of select="$repeats"/>
          <xsl:text> will be exported.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:variable name="IsAmel" select="os:IsAmel(LocusName)"/>
      <xsl:variable name="emptyColumns">
        <xsl:call-template name="Repeat">
          <xsl:with-param name="count" select="$repeats - count($AlleleExpand)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:value-of select="$LineStart"/>
      <xsl:value-of select="LocusName"/>
      <xsl:for-each select="$AlleleExpand">
        <xsl:value-of select="$TAB"/>
        <xsl:value-of select="os:DisplayAllele2(Name,$IsAmel)"/>
      </xsl:for-each>
      <xsl:value-of select="$emptyColumns"/>
      <xsl:for-each select="$AlleleExpand">
        <xsl:variable name="bps0">
          <xsl:choose>
            <xsl:when test="$ILSBPS">
              <xsl:value-of select="meanbps"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="BPS"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="bps">
          <xsl:choose>
            <xsl:when test="not(string-length($bps0))"/>
            <xsl:when test="$DECBPS">
              <xsl:value-of select="format-number($bps0,'#.00')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="floor($bps0 + 0.5)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$TAB"/>
        <xsl:value-of select="$bps"/>
      </xsl:for-each>
      <xsl:value-of select="$emptyColumns"/>
      <xsl:for-each select="$AlleleExpand">
        <xsl:value-of select="$TAB"/>
        <xsl:value-of select="RFU"/>
      </xsl:for-each>
      <xsl:value-of select="$EOL"/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="/" priority="10">
    <xsl:variable name="samples" select="/OsirisAnalysisReport/Table/Sample[os:isEnabled(.) and os:hasAlleles(.)]"/>
    <xsl:choose>
      <xsl:when test="$samples">
        <xsl:call-template name="Header"/>
        <xsl:for-each select="$samples">
          <xsl:call-template name="writeSample">
            <xsl:with-param name="sample" select="."/>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>No samples found in this file.</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
