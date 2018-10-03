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

  <xsl:output method="text"/>

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
      <xsl-params/>
    </export>
  </xsl:template>
  
  <xsl:template name="HeaderLoop">
    <xsl:param name="label"/>
    <xsl:param name="begin" select="1"/>
    <xsl:param name="end" select="$repeats"/>
    <xsl:choose>
      <xsl:when test="$end &gt; $begin">
        <xsl:variable name="mid" select="floor( ($begin + $end)/2 )"/>
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
    <xsl:call-template name="Headerloop">
      <xsl:with-param name="label" select="'Allele'/>
    </xsl:call-template>
    <xsl:call-template name="Headerloop">
      <xsl:with-param name="label" select="'Size'/>
    </xsl:call-template>
    <xsl:call-template name="Headerloop">
      <xsl:with-param name="label" select="'Height'/>
    </xsl:call-template>
    <xsl:value-of select="$EOL"/>
  </xsl:template>


  <xsl:template name="Repeat">
    <xsl:param name="str" select="$TAB"/>
    <xsl:param name="count" select="0"/>
    <xsl:choose>
      <xsl:when test="$count = 1">
        <xsl:copy-of select="$str"/>
      <xsl:when/>
      <xsl:when test="$count &gt; 1">
        <xsl:variable name="half" select="floor($count / 2)"/>
        <xsl:call-template name="Repeat">
          <xsl:with-param name="str" select="$str"/>
          <xsl:with-param name="count" select="$half"/>
        </xsl:call-template>
        <xsl:call-template name="Repeat">
          <xsl:with-param name="str" select="$str"/>
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



  <xsl:template name="GetBool">
    <xsl:param name="s"/>
    <xsl:choose>
      <xsl:when test="$s = ''">
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:when test="contains('FfNn0',substring($s,1,1))">
        <!-- check for false or no -->
        <xsl:value-of select="0"/>
      </xsl:when>
      <xsl:when test="contains('YyTt123456789',substring($s,1,1))">
        <!-- check for true or yes -->
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:when test="boolean($s) = 'true'">
        <xsl:value-of select="1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="0"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="sum">
    <xsl:param name="nodes"/>
    <xsl:param name="top" select="1"/>
    <xsl:param name="bottom" select="count($nodes)"/>
    
    <xsl:choose>
      <xsl:when test="$top &lt; $bottom">
        <xsl:variable name="mid" select="floor(($top + $bottom) * 0.5)"/>
        <xsl:variable name="s1">
          <xsl:call-template name="sum">
            <xsl:with-param name="nodes" select="$nodes"/>
            <xsl:with-param name="top" select="$top"/>
            <xsl:with-param name="bottom" select="$mid"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="s2">
          <xsl:call-template name="sum">
            <xsl:with-param name="nodes" select="$nodes"/>
            <xsl:with-param name="top" select="$mid + 1"/>
            <xsl:with-param name="bottom" select="$bottom"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="int($s1) + int($s2)"/>
      </xsl:when>
      <xsl:when test="$top = $bottom">
        <xsl:value-of select="$nodes[$top]/Count"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <func:function name="os:sum">
    <xsl:param name="nodes"/>
    <xsl:variable name="nSum">
      <xsl:call-template name="sum">
        <xsl:with-param name="nodes" select="$nodes"/>
      </xsl:call-template>
    </xsl:variable>
    <func:result select="int($nSum)"/>
  </func:function>
  
  <func:function name="AlleleCount">
    <xsl:with-param name="Locus"/>
    <xsl:variable name="r" "/>
    <func:result select="$r"/>
  </xsl:template>

  
  <xsl:template name="writeAlleleItem">
    <xsl:param name="str"/>
    <xsl:param name="count"/>
    <xsl:variable name="tabStr" select="concat($TAB,$str)"/>
    <xsl:choose>
      <xsl:when test="$count">
        <xsl:call-template select="Repeat">
          <xsl:with-param name="str" select="$tabStr"/>
          <xsl:with-param name="count" select="$count"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$tabStr"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="writeSample">
    <xsl:param name="sample"/>
    <xsl:variable name="SampleFile" select="$sample/Name"/>
    <xsl:variable name="LineStart">
      <xsl:value-of select="$sample/Name"/>
      <xsl:value-of select="$fileExt"/>
      <xsl:value-of select="$TAB"/>
    </xsl:variable>

    <!-- loop through sample loci -->

    <xsl:for-each select="$sample/Locus[Allele]">
      <xsl:variable name="tmpAlleleExpand">
        <xsl:for-each select="Allele">
          <xsl:variable name="count">
          </xsl:variable>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="alleleCount" select="count(Allele[not(Count)]) + os:sum(Allele/Count)"/>
      <xsl:value-of select="$LineStart"/>
      <xsl:value-of select="LocusName"/>
      <xsl:variable name="emptyColumns">
        <xsl:call-template name="Repeat">
          <xsl:with-param name="count" select="$repeats - $alleleCount"/>
        </xsl:call>
      </xsl:variable>

      <xsl:variable name="sAlleles">
        <xsl:for-each select="Allele">
          <xsl:variable name="AlleleContent" select="concat($TAB,Name)"/>
          <xsl:variable>
          
        </xsl:for-each>
      </xsl:variable>
        <xsl:variable name="AlleleName">
          <xsl:choose>
            <xsl:when test="OffLadder = 'true'">
              <xsl:text>OL</xsl:text>
            </xsl:when>
            <xsl:when test="$LocusName != 'AMEL'">
              <xsl:value-of select="Name"/>
            </xsl:when>
            <xsl:when test="Name = '1'">
              <xsl:text>X</xsl:text>
            </xsl:when>
            <xsl:when test="Name = '2'">
              <xsl:text>Y</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="Name"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($TAB,$AlleleName,$TAB,meanbps,$TAB,RFU)"/>
      </xsl:for-each>
      <xsl:value-of select="$EOL"/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="/" priority="10">
    <xsl:variable name="samples" select="/OsirisAnalysisReport/Table/Sample[os:isEnabled(.) and os:hasAlleles(.)]"/>
    <xsl:choose>
      <xsl:when test="$samples">
        <xsl:call-template select="Header"/>
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
