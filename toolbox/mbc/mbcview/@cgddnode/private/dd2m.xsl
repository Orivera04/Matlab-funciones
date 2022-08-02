<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" encoding="iso-8859-1"/>

<xsl:template match="/">
    
<xsl:text>importedDD.value(1:</xsl:text><xsl:value-of select = "count(datadictionary/value)" /><xsl:text>)=struct;
</xsl:text>

<xsl:text>importedDD.constant(1:</xsl:text><xsl:value-of select = "count(datadictionary/constant)" /><xsl:text>)=struct;
</xsl:text>

<xsl:text>importedDD.symvalue(1:</xsl:text><xsl:value-of select = "count(datadictionary/symvalue)" /><xsl:text>)=struct;
</xsl:text>

    <xsl:for-each select="datadictionary/constant">
        <xsl:call-template name="add">
            <xsl:with-param name="iteration" select="position()"/>
            <xsl:with-param name="name">importedDD.<xsl:value-of select="name(.)"/></xsl:with-param>
        </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="datadictionary/value">
        <xsl:call-template name="add">
            <xsl:with-param name="iteration" select="position()"/>
            <xsl:with-param name="name">importedDD.<xsl:value-of select="name(.)"/></xsl:with-param>
        </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="datadictionary/symvalue">
        <xsl:call-template name="add">
            <xsl:with-param name="iteration" select="position()"/>
            <xsl:with-param name="name">importedDD.<xsl:value-of select="name(.)"/></xsl:with-param>
        </xsl:call-template>
    </xsl:for-each>
    
</xsl:template>


<xsl:template name="add">
<xsl:param name="iteration"/>
<xsl:param name="name">1.</xsl:param>

<xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>)<xsl:text>.alias = {};
</xsl:text>
<xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>)<xsl:text>.description = '';
</xsl:text>
<xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>)<xsl:text>.setpoint = [];
</xsl:text>

<xsl:for-each select="child::node()">
<xsl:choose>
 <xsl:when test="contains(name(.),'alias')">
  <xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>)<xsl:text>.alias{end+1} =' </xsl:text><xsl:value-of select="."/><xsl:text>';
</xsl:text>
 </xsl:when>
 
 <xsl:when test="contains(name(.),'name') or contains(name(.),'description') or contains(name(.),'definition') or contains(name(.),'unit')">
   <xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>).<xsl:value-of select="name(.)"/><xsl:text> = '</xsl:text><xsl:value-of select="."/><xsl:text>';
</xsl:text>
 </xsl:when>
 <xsl:when test="contains(name(.),'min') or contains(name(.),'max') or contains(name(.),'val') or contains(name(.),'setpoint')">
   <xsl:value-of select="$name"/>(<xsl:value-of select="$iteration"/>).<xsl:value-of select="name(.)"/> <xsl:text> = </xsl:text><xsl:value-of select="."/><xsl:text>;
</xsl:text>
 </xsl:when>
</xsl:choose>
</xsl:for-each>

</xsl:template>


<xsl:template name="wrap-string">
    <xsl:param name="text"/>
    <xsl:text>['</xsl:text><xsl:call-template name="escape-newline">
         <xsl:with-param name="text">
             <xsl:call-template name="escape-quotes">
                 <xsl:with-param name="text" select="$text"/>
             </xsl:call-template>
         </xsl:with-param>
     </xsl:call-template><xsl:text>']</xsl:text>
</xsl:template>

<xsl:template name="escape-quotes">
    <xsl:param name="text"/>
    <xsl:variable name="quote"><xsl:text disable-output-escaping="yes">&#39;</xsl:text></xsl:variable>
    <xsl:choose>
      <!-- If the value of the $text parameter contains lt -->
      <xsl:when test="contains($text,$quote)"><xsl:value-of select="substring-before($text,$quote)"/><xsl:text disable-output-escaping="yes">&#39;&#39;</xsl:text><xsl:call-template name="escape-quotes"><xsl:with-param name="text" select="substring-after($text,$quote)"/></xsl:call-template></xsl:when>
      <xsl:otherwise><xsl:copy-of select="$text"/></xsl:otherwise>
   </xsl:choose>
</xsl:template>

<xsl:template name="escape-newline">
    <xsl:param name="text"/>
    <xsl:variable name="newline"><xsl:text disable-output-escaping="yes">&#10;</xsl:text></xsl:variable>
    <xsl:choose>
      <!-- If the value of the $text parameter contains lt -->
      <xsl:when test="contains($text,$newline)"><xsl:value-of select="substring-before($text,$newline)"/><xsl:text disable-output-escaping="yes">&#39;,char(32),...&#10;&#39;</xsl:text><xsl:call-template name="escape-newline"><xsl:with-param name="text" select="substring-after($text,$newline)"/></xsl:call-template></xsl:when>
      <xsl:otherwise><xsl:copy-of select="$text"/></xsl:otherwise>
   </xsl:choose>
</xsl:template>

</xsl:stylesheet>


