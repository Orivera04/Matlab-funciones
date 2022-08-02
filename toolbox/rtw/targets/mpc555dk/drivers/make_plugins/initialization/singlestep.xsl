<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- 
File : singlestep.xsl

Abstract : 
    XSL style sheet for converting generic powerpc configuration
    scripts to DIAB configuration scripts 
    
$Revision: 1.1.4.1 $
$Date: 2004/04/19 01:24:29 $

Copyright 1990-2002 The MathWorks, Inc.
 
-->

 
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

    <xsl:strip-space elements="*"/>

    <!--  A write block may contain any number of write
          sub commands -->
    <xsl:template match="write">
        <xsl:apply-templates/>
    </xsl:template>
        
    <!-- ****************** -->
    <!-- WRITE SUB COMMANDS -->
    <!-- ****************** -->

    <!-- write a long number -->
    <xsl:template match="word">
write -l <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
    </xsl:template>

    <!-- write a byte number -->
    <xsl:template match="halfword">
write -w <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
    </xsl:template>

    <!-- write a word number -->
    <xsl:template match="byte">
write -b <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
    </xsl:template>

    <!-- write to a named register -->
    <xsl:template match="reg">
@ <xsl:value-of select="@name"/> = <xsl:value-of select="@val"/> 
    </xsl:template>

    <!-- write to a numbered spr -->
    <xsl:template match="spr">
@ SPR<xsl:value-of select="@id"/> = <xsl:value-of select="@val"/> 
    </xsl:template>
        
    <!-- Write out a comment to the file -->
    <xsl:template match="comment">

# <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

</xsl:stylesheet>

