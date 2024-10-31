<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
<!--html-->
 <h1>Actualités</h1>
 <ul id="actu-comarquage">
 <xsl:for-each select="/IndexActualite/RefActualite">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
 </ul>  
<!--/html-->
</xsl:template>



<xsl:template match="RefActualite">
    <li>
		 <span class="date-actu-comarquage"><span><xsl:value-of select="SurTitre"/></span> - (<xsl:value-of select="Date"/>)</span>
		 <h2><xsl:value-of select="Titre"/></h2>
		 <p><xsl:apply-templates select="Introduction"/></p>
    </li>
</xsl:template>

</xsl:stylesheet>