<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:java="http://xml.apache.org/xalan/java"
    exclude-result-prefixes="java">

  <xsl:template match="foxml:datastream[@ID='SPMS']/foxml:datastreamVersion[last()]">
    <xsl:param name="content"/>
    <xsl:param name="prefix">spms_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>
    <xsl:apply-templates select="$content/spms/*" mode="berkeley_spms">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="berkeley_spms">
    <xsl:param name="prefix">spms_</xsl:param>
    <xsl:param name="suffix">_ms</xsl:param>

    <!--
      Create fields for the set of selected elements, named according to the
      'local-name' and containing the 'text'.
    -->
    <xsl:variable name="empty">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>
    <xsl:variable name="local">
      <xsl:value-of select="java:toLowerCase(local-name())"/>
    </xsl:variable>
    <xsl:if test="$empty != ''">
          <xsl:choose>
            <xsl:when test="$local = 'completed_date'">
              <xsl:variable name="completed_date">
               <xsl:call-template name="get_ISO8601_date">
                 <xsl:with-param name="date" select="$empty"/>
               </xsl:call-template>
              </xsl:variable>
              <xsl:if test="not(normalize-space($completed_date)='')">
                <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, $local, '_dt')"/>
                </xsl:attribute>
                <xsl:value-of select="$completed_date"/>
                </field>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <field>
              <xsl:attribute name="name">
                <xsl:value-of select="concat($prefix, $local, $suffix)"/>
              </xsl:attribute>
              <xsl:value-of select="$empty"/>
              </field>
            </xsl:otherwise>
          </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="berkeley_spms"/>
</xsl:stylesheet>
