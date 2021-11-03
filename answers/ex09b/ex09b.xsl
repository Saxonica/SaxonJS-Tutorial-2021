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

<xsl:import href="../../lib/utils.xsl"/>

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
  <select id="serves" x-base="{$default}">
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

<xsl:template match="select" mode="ixsl:onchange">
  <xsl:variable name="servings"
                select="xs:int(ixsl:get(ixsl:event(), 'target.value'))"/>
  <xsl:variable name="base-servings"
                select="xs:int(@x-base)"/>

  <xsl:message select="($base-servings, $servings, $base-servings div $servings)"/>

  <xsl:apply-templates select="//li[@x-quantity]" mode="fix-servings">
    <xsl:with-param name="factor" select="$servings div $base-servings"/>
  </xsl:apply-templates>
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

<!-- ============================================================ -->

<xsl:mode name="fix-servings" on-no-match="shallow-copy"/>

<xsl:template match="li[@x-quantity]" mode="fix-servings">
  <xsl:param name="factor" as="xs:double"/>

  <xsl:result-document href="?." method="ixsl:replace-content">
    <xsl:call-template name="prettyprint-quantity">
      <xsl:with-param name="decimal" select="@x-quantity * $factor"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:sequence select="@x-units/string()"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="span" mode="fix-servings"/>
  </xsl:result-document>
</xsl:template>

<!-- ============================================================ -->


</xsl:stylesheet>
