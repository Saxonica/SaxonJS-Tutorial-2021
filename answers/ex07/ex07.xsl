<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="h ixsl js saxon xs"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:template name="xsl:initial-template">
  <xsl:result-document href="#main" method="ixsl:replace-content">
    <xsl:apply-templates select="ixsl:page()//main"/>
  </xsl:result-document>
</xsl:template>

<xsl:template match="main">
  <h1><xsl:sequence select="string(/html/head/title)"/></h1>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="span[@id='serves']">
  <xsl:variable name="default" select="xs:int(.)"/>
  <xsl:variable name="servings" select="distinct-values(($default, 1, 2, 4, 6, 8))"/>
  <select id="serves">
    <xsl:for-each select="$servings">
      <option value="{.}">
        <xsl:if test=". = $default">
          <xsl:attribute name="selected" select="'selected'"/>
        </xsl:if>
        <xsl:sequence select="."/>
      </option>
    </xsl:for-each>
  </select>
</xsl:template>

<xsl:template match="div[@id='ingredients']">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <h2>Ingredients</h2>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="div[@id='directions']">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <h2>Directions</h2>
    <xsl:apply-templates select="node()"/>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
