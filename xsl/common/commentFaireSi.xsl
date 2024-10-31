<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
<!--html-->
 <xsl:variable name="audience" select="//Audience"/>
 
 <div id="fil-ariane-comarquage">
 <xsl:apply-templates select="/Publication/FilDAriane"/>
 </div><!--fin fil ariane comarquage-->
 
 <h1><xsl:value-of select="/Publication/dc:title"/></h1>
 
<ul class="un-bloc-liens-comarquage">
 <xsl:for-each select="/Publication/CommentFaireSi">
        <li><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></li>
    </xsl:for-each>
 </ul>  
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


 
</xsl:stylesheet>