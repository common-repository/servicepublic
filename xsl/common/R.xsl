<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
    
<!--html>
    <head>
        <title><xsl:value-of select="/ServiceComplementaire/dc:title"/></title>
    </head>
    
    <body-->
    
<div id="fil-ariane-comarquage">
 <xsl:apply-templates select="/ServiceComplementaire/FilDAriane"/>
 </div><!--fin fil ariane comarquage-->
 

<h1><xsl:value-of select="/ServiceComplementaire/dc:title"/></h1>

<!-- Fil d'ariane, theme, Introduction, Texte (Paragraphes, Listes), Liens Webs, fiches liees, Dossier) -->

<!--p><xsl:apply-templates select="/ServiceComplementaire/Theme"/></p>
<p><xsl:apply-templates select="/ServiceComplementaire/Dossier"/></p-->
<p><xsl:apply-templates select="/ServiceComplementaire/Introduction"/></p>
<p><xsl:apply-templates select="/ServiceComplementaire/Texte"/></p>

<xsl:for-each select="/ServiceComplementaire/LienWeb">
    <xsl:apply-templates select="."/>
</xsl:for-each>

<div class="un-bloc-liens-comarquage">
    <h2>Pour toute explication, consulter les fiches pratiques :</h2><hr/>
<xsl:for-each select="/ServiceComplementaire/FicheLiee">
    <xsl:apply-templates select="."/>
</xsl:for-each>
 </div><!-- fin un bloc liens comarquage-->



    <!--/body>
</html-->
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

<xsl:template match="Theme">
    <xsl:variable name="audience" select="//Audience"/>
    <span style="padding:10px"><a href='[lien]/{@ID}'><xsl:value-of select="Titre"/></a></span>
</xsl:template>

<xsl:template match="Introduction">
  
   <xsl:for-each select="Texte">
    <xsl:apply-templates select="."/>
</xsl:for-each>
</xsl:template>

<xsl:template match="Texte">
   <xsl:for-each select="Paragraphe|Liste|Attention">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
</xsl:template>

<xsl:template match="Paragraphe">
        <p><xsl:value-of select="text()"/></p>
</xsl:template>

<xsl:template match="Titre">
        <h3><xsl:value-of select="text()"/></h3>
</xsl:template>

<xsl:template match="Attention">
    <div class="attention-comarquage">
     <xsl:for-each select="Paragraphe|Liste|Titre">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
	</div><!--fin de attention-->
</xsl:template>

<xsl:template match="Liste">
       <ul><xsl:for-each select="Item">
        <xsl:apply-templates select="."/>
    </xsl:for-each></ul>
</xsl:template>

<xsl:template match="Item">
       <li><xsl:for-each select="Paragraphe">
        <xsl:apply-templates select="."/>
    </xsl:for-each></li>
</xsl:template>

<xsl:template match="LienWeb">
        <!--p><a href="{@URL}"><xsl:value-of select="@URL"/> (<xsl:value-of select="Source"/>) </a></p-->
        <div class="acceder-au-service">
        	<a href="{@URL}" target="_blank" aria-label="Accéder au service en ligne (nouvelle fenêtre)">Accéder au service en ligne</a>
        	<span><xsl:value-of select="Source"/></span>
        </div><!--fin de accéder au service-->
</xsl:template>

<xsl:template match="FicheLiee">
    <xsl:variable name="audience" select="//Audience"/>
        <p>
        <!--a href="[lien]/{Dossier/@ID}"> <xsl:value-of select="Dossier"/> </a> > -->
        <a href="index.php?fiche={@ID}&amp;famille={@audience}"><!--xsl:value-of select="@type"/ :--> <xsl:value-of select="Titre"/></a></p>
</xsl:template>

<xsl:template match="Dossier">
    <xsl:variable name="audience" select="//Audience"/>
        <p><a href="[lien]/{@ID}"> <xsl:value-of select="Titre"/> </a></p>
</xsl:template>


</xsl:stylesheet>