<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
<!--html-->

 <div id="fil-ariane-comarquage">
 <xsl:apply-templates select="/Publication/FilDAriane"/>
 </div><!--fin fil ariane comarquage-->
 
 <h1><xsl:value-of select="/Publication/dc:title"/></h1>
 
 <xsl:for-each select="/Publication/Groupe">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
      
<!--/html-->
</xsl:template>



<xsl:template match="FilDAriane">
 <xsl:for-each select="Niveau">
    <xsl:apply-templates select="."/>
</xsl:for-each>
</xsl:template>

<xsl:template match="Niveau">
    <xsl:variable name="audience" select="//Audience"/>
    » <a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a> 
</xsl:template>

<xsl:template match="Groupe">
   <div class="un-bloc-liens-comarquage">
    <h2><xsl:value-of select="Titre"/></h2><hr/>
     <xsl:for-each select="QuestionReponse">
    <xsl:apply-templates select="."/>
</xsl:for-each>
	</div><!-- fin un bloc liens comarquage-->
</xsl:template>

<xsl:template match="QuestionReponse">
    <xsl:variable name="audience" select="//Audience"/>
    <p><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></p>
</xsl:template>

 
</xsl:stylesheet>