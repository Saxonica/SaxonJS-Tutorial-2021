<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:f="https://nwalsh.com/ns/functions"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="../../lib/utils.xsl"/>

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:variable name="CONVERT"
              select="'http://localhost:9000/lib/conversions.json'"/>

<xsl:template name="xsl:initial-template">
  <xsl:result-document href="#main" method="ixsl:replace-content">
    <xsl:apply-templates select="ixsl:page()//main"/>
  </xsl:result-document>

  <ixsl:schedule-action document="{$CONVERT}">
    <xsl:call-template name="interactive"/>
  </ixsl:schedule-action>
</xsl:template>

<xsl:template match="main">
  <h1><xsl:sequence select="string(/html/head/title)"/></h1>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template name="interactive">
  <xsl:result-document href="#serves" method="ixsl:replace-content">
    <xsl:apply-templates select="ixsl:page()//span[@id='serves']"
                         mode="interactive"/>
  </xsl:result-document>
</xsl:template>

<xsl:template match="span[@id='serves']" mode="interactive">
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
  <xsl:text> </xsl:text>
  <select id="units">
    <option value="imperial">imperial units</option>
    <option value="metric">metric units</option>
  </select>
</xsl:template>

<xsl:template match="select" mode="ixsl:onchange">
  <xsl:variable name="qselect" select="ixsl:page()//select[@id='serves']"/>
  <xsl:variable name="uselect" select="ixsl:page()//select[@id='units']"/>

  <xsl:variable name="qpos" select="ixsl:get($qselect, 'selectedIndex') + 1"/>
  <xsl:variable name="upos" select="ixsl:get($uselect, 'selectedIndex') + 1"/>

  <xsl:variable name="base-servings"
                select="xs:decimal($qselect/@x-base)"/>
  <xsl:variable name="servings"
                select="xs:decimal($qselect/option[position() = $qpos]/@value)"/>
  <xsl:variable name="units"
                select="$uselect/option[position() = $upos]/@value/string()"/>

  <xsl:apply-templates select="//*[@x-quantity]" mode="fix-servings">
    <xsl:with-param name="factor" select="$servings div $base-servings"/>
    <xsl:with-param name="units" select="$units"/>
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

<xsl:template match="*[@x-quantity]" mode="fix-servings">
  <xsl:param name="factor" as="xs:double"/>
  <xsl:param name="units" as="xs:string"/>

  <xsl:variable name="convert" select="json-doc($CONVERT)"/>
  <xsl:variable name="quantity" select="@x-quantity * $factor"/>

  <xsl:result-document href="?." method="ixsl:replace-content">
    <xsl:choose>
      <xsl:when test="$units = 'imperial'">
        <xsl:call-template name="prettyprint-quantity">
          <xsl:with-param name="decimal" select="$quantity"/>
        </xsl:call-template>
        <xsl:text> </xsl:text>
        <xsl:sequence select="@x-units/string()"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="span"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="ing" select="((span/@class, span)[1]/string(), '*')[1]"/>
        <xsl:variable name="map" as="map(*)?">
          <xsl:choose>
            <xsl:when test="map:contains($convert, $ing)">
              <xsl:sequence select="map:get($convert, $ing)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence select="map:get($convert, '*')"/>
            </xsl:otherwise>
          </xsl:choose>              
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="@x-units and map:contains($map, @x-units)">
            <xsl:variable name="cmap" select="map:get($map, @x-units)"/>
            <xsl:sequence select="f:convert($quantity, $cmap?factor, $cmap?units)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="prettyprint-quantity">
              <xsl:with-param name="decimal" select="$quantity"/>
            </xsl:call-template>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@x-units"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="span"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:result-document>
</xsl:template>

<xsl:template match="*[contains(., '°F') or contains(., '°C')]"
              mode="fix-servings" priority="10">
  <xsl:param name="units" as="xs:string"/>
  <xsl:result-document href="?." method="ixsl:replace-content">
    <xsl:choose>
      <xsl:when test="$units = 'imperial'">
        <xsl:sequence select="@x-quantity/string() || ' °F'"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="c" select="(xs:decimal(@x-quantity) - 32.0) * 5.0 div 9.0"/>
        <xsl:variable name="c" select="floor(($c + 4.0) div 5.0) * 5.0"/>
        <xsl:sequence select="xs:int($c) || ' °C'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:result-document>
</xsl:template>

<xsl:function name="f:convert" as="xs:string">
  <xsl:param name="quantity" as="xs:double"/>
  <xsl:param name="factor" as="xs:double"/>
  <xsl:param name="units" as="xs:string"/>

  <xsl:variable name="number" as="xs:string">
    <xsl:choose>
      <xsl:when test="$units = 'ml' or $units = 'g'">
        <xsl:sequence select="string(xs:int(round($quantity * $factor)))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="format-number($quantity * $factor, '#0.0')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:sequence select="$number || $units"/>
</xsl:function>

</xsl:stylesheet>
