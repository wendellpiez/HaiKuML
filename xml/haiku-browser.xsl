<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output method="html" encoding="UTF-8"/>

  <!-- Basic Haiku display stylesheet. XSLT 1.0 will run in a browser. -->

  <xsl:template match="/">
    <html>
      <head>
        <title>Haiku Demo</title>

        <meta charset="utf-8"/>

        <xsl:call-template name="css"/>
        <xsl:call-template name="javascript"/>

      </head>
      <xsl:apply-templates/>
    </html>
  </xsl:template>

  <xsl:template match="ku">
    <body>
      <xsl:apply-templates/>
      <xsl:call-template name="credits"/>
    </body>
  </xsl:template>

  <xsl:template match="author">
    <h1 class="author">
      <xsl:apply-templates/>
    </h1>
  </xsl:template>

  <xsl:template match="text">
    <div class="text">
      <div id="ku">
        <xsl:apply-templates mode="display"/>
      </div>
      <div id="trans">
        <xsl:apply-templates mode="translation"/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="commentary">
    <div class="commentary">
      <xsl:call-template name="themes"/>
      <xsl:call-template name="vocabulary"/>
      <xsl:apply-templates select="remarks"/>
      <xsl:call-template name="links"/>
    </div>
  </xsl:template>

  <xsl:template match="l" mode="translation">
    <xsl:variable name="n">
      <xsl:apply-templates select="." mode="number"/>
    </xsl:variable>
    <p class="l" id="trans-{$n}">
      <xsl:apply-templates select="trans"/>
    </p>
  </xsl:template>

  <xsl:template match="l" mode="number">
    <xsl:number level="any" format="001"/>
  </xsl:template>

  <xsl:template match="l" mode="display">
    <xsl:variable name="n">
      <xsl:apply-templates select="." mode="number"/>
    </xsl:variable>
    <p class="l" onmouseover="javascript:flashOn('trans-{$n}')"
      onmouseout="javascript:flashOff('trans-{$n}')">
      <xsl:apply-templates select="orig" mode="display"/>
    </p>
  </xsl:template>

  <xsl:template match="k[normalize-space(@ji)]" mode="display">
    <ruby>
      <xsl:apply-templates select="@ji"/>
      <rt>
        <xsl:apply-templates/>
      </rt>
    </ruby>
  </xsl:template>

  <xsl:template match="ji[normalize-space(@k)]" mode="display">
    <ruby>
      <xsl:apply-templates/>
      <rt>
        <xsl:apply-templates select="@k"/>
      </rt>
    </ruby>
  </xsl:template>

  <xsl:template match="remarks">
    <div class="remarks">
      <h3>Remarks</h3>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="p">
    <p class="p">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="lookup"/>

  <xsl:template name="themes">
    <xsl:if test="theme[normalize-space(.)]">
      <div class="block">
        <h3>
          <xsl:text>Theme</xsl:text>
          <xsl:if test="count(theme[normalize-space(.)]) > 1">s</xsl:if>
          <xsl:text>: </xsl:text>
          <xsl:for-each select="theme[normalize-space(.)]">
            <xsl:if test="not(position() = 1)">; </xsl:if>
            <span class="theme">
              <xsl:apply-templates/>
            </span>
          </xsl:for-each>
        </h3>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="vocabulary">
    <xsl:if test="vocab[normalize-space(.)]">
      <div class="block">
        <h3>Vocabulary</h3>
        <xsl:apply-templates select="vocab[normalize-space(.)]"/>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="links">
    <xsl:if test="link[normalize-space(@href)]">
      <div class="block">
        <h3>
          <xsl:text>Link</xsl:text>
          <xsl:if test="count(link[normalize-space(@href)]) > 1">s</xsl:if>
          <xsl:text>: </xsl:text>
        </h3>
        <xsl:apply-templates select="link[normalize-space(@href)]"/>
      </div>
    </xsl:if>
  </xsl:template>


  <xsl:template match="vocab/term">
    <dt class="term">
      <xsl:apply-templates/>
    </dt>
  </xsl:template>

  <xsl:template match="def">
    <dd class="def">
      <xsl:apply-templates/>
    </dd>
  </xsl:template>

  <xsl:template match="link">
    <p class="link">
      <a href="{@href}" target="_new">
        <xsl:choose>
          <xsl:when test="normalize-space(.)">
            <xsl:apply-templates/>
            <span class="url">
              <xsl:text> [</xsl:text>
              <xsl:value-of select="@href"/>
              <xsl:text>]</xsl:text>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="url">
              <xsl:value-of select="@href"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </p>
  </xsl:template>

  <xsl:template match="dictionary">
    <div class="dictionary">
      <h3>Kanji dictionary</h3>
      <p>Consulting CJKV-English</p>
    </div>
    <table class="dictionary">
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="entry">
    <tr>
      <td class="head">
        <xsl:for-each select="head">
          <xsl:apply-templates/>
        </xsl:for-each>
      </td>
      <td class="senses">
        <xsl:apply-templates select="sense"/>
      </td>
      <td class="pronunciation">
        <xsl:apply-templates select="pron"/>
      </td>
      
    </tr>
  </xsl:template>

  <xsl:template match="entry/head" priority="2"/>

  <xsl:template match="entry/sense">
    <p class="sense">
      <xsl:apply-templates/>
      <xsl:if test="@source | @resp[not(. = 'Charles Muller')]">
        <!-- Chuck already gets credit above. :-) -->
        <xsl:text> (</xsl:text>
        <i class="source">
          <xsl:apply-templates select="@source"/>
          <xsl:if test="@source and @resp[not(. = 'Charles Muller')]">: </xsl:if>
          <xsl:apply-templates select="@resp[not(. = 'Charles Muller')]"/>
        </i>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </p>
  </xsl:template>


  <xsl:template match="entry/pron">
    <p class="pron">
      <xsl:apply-templates/>

    </p>
  </xsl:template>

  <xsl:template name="credits">
    <div class="block credits">
      <p>HaiKuML is developed as an XML/XSLT demonstration (and a test of technology support for
        Japanese) by <a href="http://www.wendellpiez.com">Wendell Piez</a> (2015).</p>
      <p>Access to the CJKV-English kanji dictionary was kindly provided by A. Charles Muller.
        Unless otherwise attributed, kanji dictionary senses have been provided by him.</p>
    </div>
  </xsl:template>
  
  <!-- TEI elements we let in from the dictionary: soCalled | title | quote | hi | term | foreign | strong-->
  
  <xsl:template match="soCalled | quote ">
    <xsl:text>”</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>“</xsl:text>
  </xsl:template>
  
  <xsl:template match="title | hi | foreign">
    <i class="{local-name()}">
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <xsl:template match="term | strong">
    <b class="{local-name()}">
      <xsl:apply-templates/>
    </b>
  </xsl:template>
  
  
  <xsl:template name="css">
    <style type="text/css">
      body{
        padding:0.5em
      }
      
      h1.author{
        text-align:right
      }
      
      div#ku{
        font-size:200%;
        float:right;
        clear:both;
        padding:0.5em;
        border:thin solid grey;
      
        -ms-writing-mode:tb-rl;
        -webkit-writing-mode:vertical-rl;
        -moz-writing-mode:vertical-rl;
        -ms-writing-mode:vertical-rl;
        writing-mode:vertical-rl;
      }
      
      div p:first-child{
        margin-top:0ex;
        margin-right:0ex
      }
      div p:last-child{
        margin-bottom:0ex;
        margin-left:0ex
      }
      
      div.commentary{
        clear:both
      }
      
      div.block{
        margin-top:1em
      }
      
      div.credits { padding: 0.5em; border: thin solid black;
        font-size: 80% }
      
      table.dictionary{
        width:80%
      }
      
      td{
        vertical-align:top;
        border-top:thin solid black;
        padding:6pt 0pt
      }
      td p{
        margin-top:0.5em;
        margin-bottom:0px
      }
      td p:first-child{
        margin-top:0px
      }
      p.pron{
        font-size:80%;
        font-style:italic
      }
      p.pron:before{
        content:'reading: '
      }
      
      table.dictionary td.head { font-size:160%; width:15%
      }
      table.dictionary td.pronunciation { width: 25% }
      
      span.theme{
        font-weight:normal;
        font-style:italic
      }
      
      a{
        color:inherit;
        text-decoration:inherit
      }
      a:hover{
        color:blue;
        text-decoration:underline
      }
      span.url{
        font-family:sans-serif;
        font-size:90%
      }
      
      i.source{
        font-size:80%
      }</style>
  </xsl:template>

  <xsl:template name="javascript">
    <script type="text/javascript">
      function flashOn(lineID) {
        document.getElementById(lineID).style.fontStyle = 'italic'
        return }
      
      function flashOff(lineID) {
        document.getElementById(lineID).style.fontStyle = 'inherit'
        return }
      
    </script>
  </xsl:template>

</xsl:stylesheet>
