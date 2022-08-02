<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
File: assembler.xsl

Abstract:
	XSL style sheet for converting generic powerpc configuration
	scripts to DIAB configuration scripts 

$Revision: 1.1.4.1 $
$Date: 2004/04/19 01:24:26 $

Copyright 1990-2002 The MathWorks, Inc.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>

    <xsl:strip-space elements="*"/>
    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <!-- Start processing the document root -->
    <xsl:template match="/">
        .export initialization_code

initialization_code:
        <xsl:apply-templates/>
    </xsl:template>

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
        ; write long (32bit) <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
        addis r2,r0,<xsl:value-of select="@addr"/>@ha
        addi r2,r0,<xsl:value-of select="@addr"/>@l
        addis r3,r0,<xsl:value-of select="@val"/>@ha
        addi r3,r3,<xsl:value-of select="@val"/>@l
        stw  r3,0(r2)
    </xsl:template>

    <!-- write a byte number -->
    <xsl:template match="halfword">
        ; write word (16bit) <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
        addis r2,r0,<xsl:value-of select="@addr"/>@ha
        addi r2,r0,<xsl:value-of select="@addr"/>@l
        addi r3,r3,<xsl:value-of select="@val"/>
        sth  r3,0(r2)
    </xsl:template>

    <!-- write a word number -->
    <xsl:template match="byte">
        ; write word (16bit) <xsl:value-of select ="@addr"/> = <xsl:value-of select="@val"/> 
        addis r2,r0,<xsl:value-of select="@addr"/>@ha
        addi r2,r0,<xsl:value-of select="@addr"/>@l
        addi r3,r0,<xsl:value-of select="@val"/>
        stb  r3,0(r2)
    </xsl:template>

    <!-- write to a named register -->
    <xsl:template match="reg">
        ; write to register (32bit) <xsl:value-of select ="@name"/> = <xsl:value-of select="@val"/> 
        addis r3,r0,<xsl:value-of select="@val"/>@ha
        addi r3,r3,<xsl:value-of select="@val"/>@l
        mt<xsl:value-of select="translate(@name,$ucletters,$lcletters)"/> r3
    </xsl:template>

    <!-- write to a numbered spr -->
    <xsl:template match="spr">
        ; write to spr (32bit) <xsl:value-of select="@id"/> = <xsl:value-of select="@val"/> 
        addis r3,r0,<xsl:value-of select="@val"/>@ha
        addi r3,r3,<xsl:value-of select="@val"/>@l
        mtspr <xsl:value-of select="@id"/>,r3
    </xsl:template>

    <!-- Write out a comment to the file -->
    <xsl:template match="comment">

        ;---------------------------------------------
        ; <xsl:value-of select="normalize-space(.)"/>
        ;---------------------------------------------
    </xsl:template>

</xsl:stylesheet>

