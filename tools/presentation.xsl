<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:e="http://www.w3.org/1999/XSL/Spec/ElementSyntax"
                xmlns:f="http://docbook.org/ns/docbook/functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/ns/docbook/modes"
                xmlns:t="http://docbook.org/ns/docbook/templates"
                xmlns:v="http://docbook.org/ns/docbook/variables"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all"
                version="3.0">

<xsl:import href="https://cdn.docbook.org/release/xsltng/current/xslt/docbook.xsl"/>
<!--
<xsl:import href="/Users/ndw/projects/docbook/xslTNG/build/xslt/docbook.xsl"/>
-->

<xsl:output method="html" html-version="5" encoding="utf-8" indent="no"/>

<xsl:param name="persistent-toc" select="'true'"/>
<xsl:param name="verbatim-numbered-elements" select="''"/>
<xsl:param name="tutorial-version" required="yes"/>
<xsl:param name="server-port" required="yes"/>

<xsl:param name="css-links"
           select="'css/docbook.css css/docbook-screen.css css/presentation.css'"/>

<xsl:variable name="v:templates" as="document-node()">
  <xsl:document>
    <db:book xmlns:tmp="http://docbook.org/ns/docbook/templates">
      <header>
        <tmp:apply-templates select="db:title">
          <h1><tmp:content/></h1>
        </tmp:apply-templates>
        <tmp:apply-templates select="db:subtitle">
          <h2><tmp:content/></h2>
        </tmp:apply-templates>
        <tmp:apply-templates select="db:author">
          <div class="author">
            <h3><tmp:content/></h3>
            <tmp:apply-templates select="db:affiliation">
              <p class="affiliation"><tmp:content/></p>
            </tmp:apply-templates>
          </div>
        </tmp:apply-templates>
        <tmp:apply-templates select="db:confgroup"/>
        <tmp:apply-templates select="db:pubdate">
          <p class="pubdate"><tmp:content/></p>
        </tmp:apply-templates>
      </header>
    </db:book>
  </xsl:document>
</xsl:variable>

<xsl:template match="db:confgroup" mode="m:titlepage">
  <p>
    <xsl:apply-templates select="." mode="m:attributes"/>
    <xsl:apply-templates mode="m:titlepage"/>
  </p>
</xsl:template>

<xsl:template match="db:conftitle|db:confdates" mode="m:titlepage">
  <span>
    <xsl:apply-templates select="." mode="m:attributes"/>
    <xsl:apply-templates mode="m:titlepage"/>
  </span>
</xsl:template>
  
<xsl:template match="db:affiliation" mode="m:titlepage">
  <xsl:apply-templates select="db:orgname/node()" mode="m:docbook"/>
</xsl:template>

<xsl:template match="db:chapter" mode="m:headline-label">
  <xsl:param name="purpose" as="xs:string" select="'title'"/>
  <xsl:param name="number" as="node()*" required="yes"/>
  <xsl:param name="title" as="node()*" required="yes"/>
  <xsl:sequence select="()"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:html-head-links">
  <script src="https://kit.fontawesome.com/5f1e765bbe.js" crossorigin="anonymous"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:link[@xlink:href]" mode="m:docbook">
  <xsl:variable name="href"
                select="replace(@xlink:href, 'PORT', $server-port)
                        => replace('9000', $server-port)"/>
  <a href="{$href}">
    <xsl:choose>
      <xsl:when test="empty(node())">
        <xsl:sequence select="$href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" mode="m:docbook"/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<xsl:template match="processing-instruction('port')">
  <xsl:sequence select="$server-port"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:top-nav">
  <xsl:param name="docbook" as="node()" tunnel="yes"/>
  <xsl:param name="node" as="element()"/>
  <xsl:param name="prev" as="element()?"/>
  <xsl:param name="next" as="element()?"/>
  <xsl:param name="up" as="element()?"/>
  <xsl:param name="top" as="element()?"/>

  <span class="nav">
    <a title="{$docbook/db:book/db:info/db:title}" href="{$top/@db-chunk/string()}">
      <i class="fas fa-home"></i>
    </a>
    <xsl:text>&#160;</xsl:text>

    <xsl:choose>
      <xsl:when test="exists($prev)">
        <a href="{$prev/@db-chunk/string()}" title="{f:title-content($prev)}">
          <i class="fas fa-arrow-left"></i>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="inactive">
          <i class="fas fa-arrow-left"></i>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#160;</xsl:text>

    <xsl:choose>
      <xsl:when test="exists($up)">
        <a title="{f:title-content($up)}" href="{$up/@db-chunk/string()}">
          <i class="fas fa-arrow-up"></i>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="inactive">
          <i class="fas fa-arrow-up"></i>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#160;</xsl:text>

    <xsl:choose>
      <xsl:when test="exists($next)">
        <a title="{f:title-content($next)}" href="{$next/@db-chunk/string()}">
          <i class="fas fa-arrow-right"></i>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span class="inactive">
          <i class="fas fa-arrow-right"></i>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </span>
  
  <span class="text">
    <i class="title"><xsl:value-of select="/h:html/h:head/h:title"/></i>
  </span>
  <span class="nav"/>
</xsl:template>

<xsl:template name="t:bottom-nav">
  <xsl:param name="docbook" as="node()" tunnel="yes"/>
  <xsl:param name="node" as="element()"/>
  <xsl:param name="prev" as="element()?"/>
  <xsl:param name="next" as="element()?"/>
  <xsl:param name="up" as="element()?"/>
  <xsl:param name="top" as="element()?"/>

  <xsl:if test="exists($prev)">
    <div class="navrow">
      <div class="navleft">
        <span class="copyrightfooter">
          <xsl:apply-templates select="$docbook/db:book/db:info/db:copyright" mode="m:docbook"/>
        </span>
      </div>
      <div class="navmiddle"></div>
      <div class="navright">
        <xsl:value-of select="count($node/preceding::h:div[@db-chunk]) + 1"/>
        <xsl:text> / </xsl:text>
        <xsl:value-of select="count($node/preceding::h:div[@db-chunk])
                              + count($node/following::h:div[@db-chunk]) + 1"/>
      </div>
    </div>
  </xsl:if>

  <xsl:variable name="db-node"
                select="key('genid', $node/@db-id, $docbook)"/>

  <div class="infofooter">
    <!-- This is a terrible hack -->
    <span style='float: right;'>
      <xsl:sequence select="'Version ' || $tutorial-version"/>
      <xsl:text> </xsl:text>
      <a title="Chapter 1" href="ch01.html"><i class="fas fa-arrow-right"></i></a>
    </span>
    <span class="copyrightfooter">
      <xsl:apply-templates select="$docbook/db:book/db:info/db:copyright" mode="m:docbook"/>
    </span>

    <xsl:if test="$db-node/db:info/db:releaseinfo[@role='hash']">
      <xsl:variable name="hash"
                    select="$db-node/db:info/db:releaseinfo[@role='hash']"/>

      <span class="revision">
        <xsl:attribute name="title"
                       select="'git hash: '
                               || substring($hash, 1, 6)
                               || '…'"/>
        <xsl:text>Last revised by </xsl:text>
        <xsl:value-of
            select="substring-before($db-node/db:info/db:releaseinfo[@role='author'],
                                     ' &lt;')"/>
        <xsl:text> on </xsl:text>
        <xsl:for-each select="$db-node/db:info/db:pubdate">
          <!-- hack: there should be only one -->
          <xsl:if test=". castable as xs:dateTime">
            <xsl:value-of select="format-dateTime(. cast as xs:dateTime,
                                                  '[D1] [MNn,*-3] [Y0001]')"/>
          </xsl:if>
        </xsl:for-each>
      </span>
    </xsl:if>
  </div>
</xsl:template>

<xsl:function name="f:title-content" as="node()*">
  <xsl:param name="node" as="element()?"/>

  <xsl:variable name="header" select="($node/h:header, $node/h:article/h:header)[1]"/>

  <xsl:variable name="title" as="element()?"
                select="($header/h:h1,
                         $header/h:h2,
                         $header/h:h3,
                         $header/h:h4,
                         $header/h:h5)"/>

  <xsl:variable name="title" as="element()?"
                select="if (exists($title))
                        then $title
                        else $node/h:div[@class='refnamediv']
                                /h:p/h:span[@class='refname']"/>
 
  <xsl:sequence select="$title/node()"/>
</xsl:function>

</xsl:stylesheet>
