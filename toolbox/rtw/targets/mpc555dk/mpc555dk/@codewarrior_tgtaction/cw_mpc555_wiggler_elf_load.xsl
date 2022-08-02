<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!-- 
File : cw_mpc555_wiggler_elf_load.xsl

Abstract :

Processes a default Code Warrior project xml export file
and inserts the correct setting to load an elf format file

Usage:

saxon raw_project.xml cw_mpc555_wiggler_elf_load.xsl elf=executable.elf initscript=startup.cfg filelist=filelist.xml grouplist=grouplist.xml > new_project.xml

Parameters
-	raw_project.xml		                -	The original project file export from Code Warrior
-	cw_mpc555_wiggler_elf_load.xsl		 -	This stylesheet
-	elfdir				                   -	[optional] Insert the directory location of the executable to load
-	elf				                  	 -	[optional] Insert the name of the executable to load
-	initscript			                   -	Insert the full path to the initialization script to run
-  filelist                             - [optional] Insert the filelist section for the source files of the project
-  grouplist                            - [optional] Insert the grouplist section for the source files of the project
-  access_paths                         - [optional] Insert the searchpaths section for the sources files of the project
-  StopAtTempBPOnLaunch                 - "true" | "false"
-  isFlashApplication                   - "true" | "false"
-  Processor                            - The target processor type
-  memconfigfile                        - Insert the full path to the memory configuration file

Invoking the saxon XSLT processor

saxon is a command alias for

saxon='java -jar "d:\r13\java\jarext\saxon.jar"'

$Revision: 1.4.6.4 $
$Date: 2004/04/19 01:26:11 $

Copyright 2002-2004 The MathWorks, Inc.

-->


    <!-- **************************************
    Parameters to the XSLT file
    *************************************** -->

	<!-- The directory where the elf file is to be found -->
	<xsl:param name="elfdir" select="''"/>
	<!-- The *.elf file to be loaded on the target -->
	<xsl:param name="elf" select="''"/>
	<!-- The full location of the initialization script --> 
	<xsl:param name="initscript" select="''"/>
	<!-- The full location of the filelist xml file --> 
	<xsl:param name="filelist" select="''"/>
	<!-- The full location of the grouplist xml file --> 
	<xsl:param name="grouplist" select="''"/>
	<!-- The full location of the access_paths xml file --> 
	<xsl:param name="access_paths" select="''"/>
	<!-- Stop on temporary break point before launch --> 
	<xsl:param name="StopAtTempBPOnLaunch" select="''"/>
   <!-- Is the application a flash application -->
	<xsl:param name="isFlashApplication" select="''"/>
   <!-- Target processor type -->
	<xsl:param name="Processor" select="''"/>
   <!-- The full location of the memory configuration file --> 
	<xsl:param name="memconfigfile" select="''"/>
   


	<!-- Parameterized changes to the file -->

    <!-- Set the executable for the debug session -->
    <xsl:template match="SETTING[NAME/text()='MWProject_EPPC_outfile']">
        <xsl:choose>
            <xsl:when test="string-length($elf) > 0">
                <SETTING><NAME>MWProject_EPPC_outfile</NAME>
                    <VALUE><xsl:value-of select="$elf"/></VALUE>
                </SETTING>
            </xsl:when>
            <xsl:otherwise>
                <!-- No Application for the debug session -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Set the old executable for the debug session -->
    <xsl:template match="SETTING[NAME/text()='MWProject_EPPC_old_outfile']">
        <xsl:choose>
            <xsl:when test="string-length($elf) > 0">
                <SETTING><NAME>MWProject_EPPC_old_outfile</NAME>
                    <VALUE><xsl:value-of select="$elf"/></VALUE>
                </SETTING>
            </xsl:when>
            <xsl:otherwise>
                <!-- No Application for the debug session -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Setup the download options for flash applications -->
    <!-- Initial download options -->
    <xsl:template match =
       " VALUE/text()[ 
       ../../NAME/text() = 'IDexecutable'    or
       ../../NAME/text() = 'IDinitialized'   or 
       ../../NAME/text() = 'IDuninitialized' or
       ../../NAME/text() = 'IDconstant'      or
       ../../NAME/text() = 'SDexecutable'    or
       ../../NAME/text() = 'SDinitialized'   or
       ../../NAME/text() = 'SDuninitialized' or
       ../../NAME/text() = 'SDconstant' ] ">
       <xsl:choose>
          <xsl:when test="$isFlashApplication='true'">0</xsl:when>
          <xsl:when test="$isFlashApplication='false'">1</xsl:when>
       </xsl:choose>
    </xsl:template>


	<!-- Set the location to find the executable -->
	<xsl:template match="SETTING[NAME/text()='OutputDirectory']">
        <xsl:if test="string-length($elf)>0">
            <SETTING><NAME>OutputDirectory</NAME>
                <SETTING><NAME>Path</NAME><VALUE><xsl:value-of select="$elfdir"/></VALUE></SETTING>
                <SETTING><NAME>PathFormat</NAME><VALUE>Windows</VALUE></SETTING>
                <SETTING><NAME>PathRoot</NAME><VALUE>Absolute</VALUE></SETTING>
            </SETTING>
        </xsl:if>
	</xsl:template>

   <!-- Set the initialization script for the debug session -->
	<xsl:template match="SETTING[NAME/text()='InitializationFile']">
      <SETTING><NAME>InitializationFile</NAME>
        <SETTING><NAME>Path</NAME><VALUE><xsl:value-of select="$initscript"/></VALUE></SETTING>
        <SETTING><NAME>PathFormat</NAME><VALUE>Windows</VALUE></SETTING>
        <SETTING><NAME>PathRoot</NAME><VALUE>Absolute</VALUE></SETTING>
    </SETTING>
	</xsl:template>

   <!-- Set the memory configuation file for the debug session -->
	<xsl:template match="SETTING[NAME/text()='ConfigurationFile']">
      <SETTING><NAME>ConfigurationFile</NAME>
        <SETTING><NAME>Path</NAME><VALUE><xsl:value-of select="$memconfigfile"/></VALUE></SETTING>
        <SETTING><NAME>PathFormat</NAME><VALUE>Windows</VALUE></SETTING>
        <SETTING><NAME>PathRoot</NAME><VALUE>Absolute</VALUE></SETTING>
    </SETTING>
	</xsl:template>

    <!-- Do not stop on temporary break point when executing -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='StopAtTempBPOnLaunch']"><xsl:value-of select="$StopAtTempBPOnLaunch"/></xsl:template>

	<!-- Add some files into the Project -->
	<xsl:template match= "FILELIST">
        <xsl:if test="string-length($filelist) > 0">
            <xsl:variable name="doc" select="document($filelist)"/>
            <xsl:copy-of select="$doc"/>
        </xsl:if>
	</xsl:template>

	<xsl:template match= "GROUPLIST">
        <xsl:if test="string-length($grouplist) > 0">
            <xsl:variable name="doc" select="document($grouplist)"/>
            <xsl:copy-of select="$doc"/>
        </xsl:if>
	</xsl:template>

    <xsl:template match="SETTING[NAME/text()='UserSearchPaths']">
        <xsl:if test="string-length($access_paths) > 0">
            <xsl:variable name="doc" select="document($access_paths)"/>
            <xsl:copy-of select="$doc"/>
        </xsl:if>
	</xsl:template>


    <!-- *************************************************
    Standard non parameterized templates for MPC555 target 
    ************************************************** -->

    <!-- Name the target Mathworks Downloader -->
    <xsl:template match="text()[../text()='Mathworks']">MathWorks Downloader</xsl:template>

    <!-- Use an initialization file -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='UseInitFile']">1</xsl:template>

    <!-- Use a memory config file -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='UseConfigFile']">1</xsl:template>

    <!-- Set the linker to be Embedded Power PC -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='Linker']">Embedded PPC Linker</xsl:template>

    <!-- Set the processor -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='Processor']"><xsl:value-of select="$Processor"/></xsl:template>

    <!-- Set the Floating Point buffer address -->
	<xsl:template match=
		"VALUE/text()[../../NAME/text()='MWDebugger_EPPC_fpuBuffAddr']">0x3f9800</xsl:template>

	<!-- There is no 'VALUE/text()' to match with ConnectionName as it is
	     empty in the default project so we go with the slightly more verbose
		 form of the replacement where we replace the entire VALUE element. -->
	<xsl:template match=
		"VALUE[../NAME/text()='ConnectionName']">
		<VALUE>MPC555DK Wiggler</VALUE></xsl:template>

    <!-- Disable CodeWarrior from catching the external interrupt -->
    <xsl:template match=
        "SETTING/SETTING[4]/VALUE/text()[../../../NAME/text()='MWDebugger_EPPC_Exceptions']">0</xsl:template>










	<!--
	Identity Copy Template

	Recursively decends the document copying all nodes to the output that have
	not been matched by the above templates.
	-->

	<xsl:template match="*|@*|comment()|processing-instruction()|text()">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()"/>
		</xsl:copy>
	</xsl:template>


</xsl:stylesheet>


