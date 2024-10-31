<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
<!--html-->

<div id="fil-ariane-comarquage">
 <xsl:apply-templates select="/CentresDeContact/FilDAriane"/>
 </div><!--fin fil ariane comarquage-->

 <h1>Centres de contact</h1>
 
 <ul class="un-bloc-liens-comarquage">
 <xsl:for-each select="/CentresDeContact/Contact">
        <xsl:apply-templates select="."/>
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
    » <a href='[lien]/{@ID}'> <xsl:value-of select="text()"/></a> 
</xsl:template>

<xsl:template match="Contact">
   <xsl:variable name="audience" select="//Audience"/>
    <li> <a href='[lien]/{@ID}'><xsl:value-of select="Titre"/></a></li>
</xsl:template>


 
</xsl:stylesheet>