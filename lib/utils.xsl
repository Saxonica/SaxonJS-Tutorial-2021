<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="xs"
                version="3.0">

<xsl:template name="prettyprint-quantity">
  <xsl:param name="decimal" as="xs:double" required="true"/>

  <xsl:variable name="q" select="format-number($decimal, '#.000')"/>
  <xsl:variable name="whole" select="substring-before($q, '.')"/>
  <xsl:variable name="frac" select="substring-after($q, '.')"/>

  <xsl:choose>
    <xsl:when test="$frac = '000'">
      <xsl:sequence select="$whole"/>
    </xsl:when>
    <xsl:when test="$frac = '100'">
      <xsl:sequence select="$whole || ' ⅒'"/>
    </xsl:when>
    <xsl:when test="$frac = '111'">
      <xsl:sequence select="$whole || ' ⅑'"/>
    </xsl:when>
    <xsl:when test="$frac = '125'">
      <xsl:sequence select="$whole || ' ⅛'"/>
    </xsl:when>
    <xsl:when test="$frac = '143'">
      <xsl:sequence select="$whole || ' ⅐'"/>
    </xsl:when>
    <xsl:when test="$frac = '167'">
      <xsl:sequence select="$whole || ' ⅙'"/>
    </xsl:when>
    <xsl:when test="$frac = '200'">
      <xsl:sequence select="$whole || ' ⅕'"/>
    </xsl:when>
    <xsl:when test="$frac = '250'">
      <xsl:sequence select="$whole || ' ¼'"/>
    </xsl:when>
    <xsl:when test="$frac = '375'">
      <xsl:sequence select="$whole || ' ⅜'"/>
    </xsl:when>
    <xsl:when test="$frac = '333'">
      <xsl:sequence select="$whole || ' ⅓'"/>
    </xsl:when>
    <xsl:when test="$frac = '400'">
      <xsl:sequence select="$whole || ' ⅖'"/>
    </xsl:when>
    <xsl:when test="$frac = '500'">
      <xsl:sequence select="$whole || ' ½'"/>
    </xsl:when>
    <xsl:when test="$frac = '600'">
      <xsl:sequence select="$whole || ' ⅗'"/>
    </xsl:when>
    <xsl:when test="$frac = '625'">
      <xsl:sequence select="$whole || ' ⅝'"/>
    </xsl:when>
    <xsl:when test="$frac = '667'">
      <xsl:sequence select="$whole || ' ⅔'"/>
    </xsl:when>
    <xsl:when test="$frac = '750'">
      <xsl:sequence select="$whole || ' ¾'"/>
    </xsl:when>
    <xsl:when test="$frac = '800'">
      <xsl:sequence select="$whole || ' ⅘'"/>
    </xsl:when>
    <xsl:when test="$frac = '833'">
      <xsl:sequence select="$whole || ' ⅚'"/>
    </xsl:when>
    <xsl:when test="$frac = '875'">
      <xsl:sequence select="$whole || ' ⅞'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$q"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
