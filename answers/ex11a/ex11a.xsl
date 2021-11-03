<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
 	        xmlns:ixsl="http://saxonica.com/ns/interactiveXSLT"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:js="http://saxonica.com/ns/globalJS"
                xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:mode on-no-match="shallow-copy"/>

<xsl:variable name="CATEGORIES"
              select="'http://localhost:9000/recipes/categories.json'"/>

<xsl:template name="xsl:initial-template">
  <xsl:result-document href="#main" method="ixsl:replace-content">
    <xsl:apply-templates select="ixsl:page()//main"/>
  </xsl:result-document>

  <!-- Avoid scheduling the action to update the page while you're
       updating the page... -->
  <xsl:if test="ixsl:page()//div[@id='categories']">
    <ixsl:schedule-action document="{$CATEGORIES}">
      <xsl:call-template name="select-category"/>
    </ixsl:schedule-action>
  </xsl:if>
</xsl:template>

<xsl:template match="main">
  <h1><xsl:sequence select="string(/html/head/title)"/></h1>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="div[@id='categories']">
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <h2>Recipe categories</h2>
  </xsl:copy>
</xsl:template>

<xsl:template name="select-category">
  <xsl:variable name="json"
                select="if (unparsed-text-available($CATEGORIES))
                        then json-doc($CATEGORIES)
                        else map {}"/>

  <xsl:result-document href="#categories">
    <p>Select a category:</p>
    <ul>
      <xsl:for-each select="map:keys($json)">
        <li class="category" id="{.}">
          <a href="#{.}">
            <xsl:value-of select="."/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:result-document>
</xsl:template>

</xsl:stylesheet>
