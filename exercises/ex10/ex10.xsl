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

<xsl:template name="xsl:initial-template">
  <xsl:sequence select="ixsl:call(ixsl:window(),
                          'alert', ['All your base are belong to us'])"/>

  <xsl:apply-templates select="ixsl:page()/*"/>
</xsl:template>

<xsl:template match="*">
  <xsl:result-document href="#main" method="ixsl:replace-content">
    <p>All your base are belong to us.</p>
  </xsl:result-document>

  <xsl:iterate select="1 to 10000000">
    <xsl:param name="count" select="0"/>
    <xsl:message select="'Looping looping looping…'"/>
    <xsl:next-iteration>
      <xsl:with-param name="count" select="$count + 1"/>
    </xsl:next-iteration>
  </xsl:iterate>
</xsl:template>

</xsl:stylesheet>
