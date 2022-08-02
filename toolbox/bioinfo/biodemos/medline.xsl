<?xml version="1.0"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 
<xsl:output method="html" encoding="iso-8859-1"/>

<xsl:template match="/">
   <html>
      <head><title>Medline Citation</title></head>
      <body>
         <xsl:apply-templates select="MedlineCitation"/>  
      </body>
   </html>
</xsl:template> 

<xsl:template match="MedlineCitation"> 
  <i><xsl:value-of select="MedlineJournalInfo/MedlineTA"/>, </i>
  <xsl:value-of select="Article/Journal/JournalIssue/PubDate/Year"/>
  (<xsl:value-of select="Article/Journal/JournalIssue/PubDate/Month"/>), 
  <b><xsl:value-of select="Article/Journal/JournalIssue/Volume"/></b>
  (<xsl:value-of select="Article/Journal/JournalIssue/Issue"/>):
  <xsl:value-of select="Article/Pagination/MedlinePgn"/>
  <h2>	 
    <xsl:value-of select="Article/ArticleTitle"/>
  </h2>
  <xsl:apply-templates select="Article/AuthorList/Author"/>
  <br/>
  <xsl:value-of select="Article/Affiliation"/>
  <p/>
  <b>Abstract:</b><br/>
  <xsl:value-of select="Article/Abstract/AbstractText"/>
  <p/>
  <b>PMID: </b><xsl:value-of select="PMID"/><br/>
  <b>ISSN: </b><xsl:value-of select="Article/Journal/ISSN"/>
  <p/>
  <b>Publication Type:</b><br/>
  <ul>
  <xsl:apply-templates select="Article/PublicationTypeList/PublicationType"/>
  </ul>
  <p/>
  <xsl:for-each select="MeshHeadingList/MeshHeading">
     <xsl:if test="position()=1"><b>Keywords: </b></xsl:if>
     <xsl:value-of select="DescriptorName"/>
     <xsl:if test="not(position()=last())">, </xsl:if>
  </xsl:for-each>

</xsl:template> 

<xsl:template match="Article/AuthorList/Author">
   <xsl:apply-templates select="LastName"/>, <xsl:apply-templates select="ForeName"/>
   <xsl:if test="not(position()=last())">; </xsl:if>
</xsl:template> 

<xsl:template match="Article/PublicationTypeList/PublicationType">
   <xsl:if test="position()!=1"> <br/> </xsl:if>
   <xsl:apply-templates /> 
</xsl:template>

</xsl:stylesheet>