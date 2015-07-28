<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <!-- HaiKuML enhancement stylesheet. An XSLT 2.0 stylesheet.
         Enhances a HaiKuML document instance by adding a dictionary
         containing lookups for all the characters found in the file. -->
    
    <!-- The full dictionary is here: '../../../kanji-dictionary/dealt?select=*.xml'   -->
  
    <!-- By default you get the reduced dictionary. -->
    <xsl:param name="dictionary-collection">../../lib?select=kanji-dictionary.xml</xsl:param>
  
    <xsl:variable name="dictionary-entries" as="document-node()">
      <!-- All of Chuck's JDKV-English dictionary is here -->
      <xsl:document>
        <xsl:sequence select="collection($dictionary-collection)/*/entry"/>
      </xsl:document>
    </xsl:variable>

    
  
    <xsl:key name="entry-by-head" match="entry" use="hdwd"/>
  
  <xsl:template match="ku">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>      
      <xsl:call-template name="kanji-lookup"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template name="kanji-lookup">
    <xsl:variable name="returns">
    <xsl:for-each-group select="(//text//orig | //lookup  | //@ji)/string-to-codepoints(.)" group-by=".">
      <xsl:variable name="char" select="codepoints-to-string(current-grouping-key())"/>
      <xsl:variable name="entries" select="key('entry-by-head', $char, $dictionary-entries)"/>
      <xsl:if test="exists($entries)">
        <entry>
          <head>
            <xsl:value-of select="$char"/>
          </head>
          <xsl:apply-templates mode="filter" select="$entries//sense"/>
          <xsl:apply-templates mode="filter" select="$entries//pron[@lang='ja'][matches(.,'\S')]"/>
        </entry>
      </xsl:if>
    </xsl:for-each-group>
    </xsl:variable>
    <xsl:if test="exists($returns/*)">
      <dictionary>
        <xsl:sequence select="$returns"/>
      </dictionary>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- The dictionary contains the following element contents inside sense and pron:
    xref, quote, bibl, title, persName, placeName, br, foreign, soCalled,
    emph, term, transcription, reign, hi, p, listBibl, biblStruct, monogr,
    author, surname, forename, imprint, pubPlace, publisher, date, list,
    item, note, strong -->

  <!-- Mostly, we strip these. -->
  <xsl:template mode="filter" match="*">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <!-- We copy these through. -->
  <xsl:template mode="filter" match="sense | pron | soCalled | title | quote | hi | term | foreign | strong">
    <xsl:copy>
      <!-- We drop attributes except @lang -->
      <xsl:copy-of select="@lang"/>
      <xsl:apply-templates mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>