<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">
 
<xsl:template match="/">
    
<!--html>
    <head>
        <title><xsl:value-of select="/Publication/dc:title"/></title>
    </head>
    
    <body-->
    
<div id="fil-ariane-comarquage">
 	<xsl:apply-templates select="/Publication/FilDAriane"/>
 	</div><!--fin fil ariane comarquage-->
    
<h1><xsl:value-of select="/Publication/dc:title"/></h1>

<!-- theme, Introduction, Texte (Paragraphes, Listes), Liens Webs, fiches liees, Dossier) -->
<p><xsl:apply-templates select="/Publication/SousTheme"/></p>
<!--p><xsl:apply-templates select="/Publication/SousThemePere"/></p-->
<p><xsl:apply-templates select="/Publication/Introduction"/></p>
<p><xsl:apply-templates select="/Publication/OuSAdresser"/></p>

<div class="un-bloc-liens-dossiers-N">
<p><xsl:apply-templates select="/Publication/Dossier"/></p>
</div><!-- fin un bloc liens comarquage-->

<p><xsl:apply-templates select="/Publication/SousDossier"/></p>

<hr/>
<xsl:if test="count(/Publication/VoirAussi) > 0">
<xsl:apply-templates select="/Publication/VoirAussi"/>
</xsl:if> 

<xsl:if test="count(/Publication/Fiche) > 0">
<div class="un-bloc-liens-comarquage fond-couleur">
    <h2>Fiches liées</h2><hr/>
	<xsl:apply-templates select="/Publication/Fiche"/>
</div><!-- fin un bloc liens comarquage-->
</xsl:if>   

<xsl:if test="count(/Publication/ServiceEnLigne) > 0">
<div class="un-bloc-liens-comarquage fond-couleur">
	<h2>Services en ligne</h2><hr/>
	<xsl:apply-templates select="/Publication/ServiceEnLigne"/>
</div><!-- fin un bloc liens comarquage-->
</xsl:if>   

<xsl:if test="count(/Publication/PourEnSavoirPlus) > 0">
<div class="un-bloc-liens-comarquage fond-couleur">
	<h2>Pour en savoir plus</h2><hr/>
    <xsl:apply-templates select="/Publication/PourEnSavoirPlus"/>
</div><!-- fin un bloc liens comarquage-->
</xsl:if>   

<xsl:if test="count(/Publication/QuestionReponse) > 0">
<div class="un-bloc-liens-comarquage fond-couleur">
	<h2>Questions - Réponses</h2><hr/>
	<xsl:apply-templates select="/Publication/QuestionReponse"/>
</div><!-- fin un bloc liens comarquage-->
</xsl:if>    

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
    > <a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a> 
</xsl:template>

<xsl:template match="SousTheme">
  <div class="un-bloc-liens-comarquage">
        <h2><xsl:value-of select="Titre"/></h2>
        <hr/>
 <xsl:for-each select="Dossier">
    <xsl:apply-templates select="."/>
</xsl:for-each>
</div><!-- fin un bloc liens comarquage-->
</xsl:template>

<xsl:template match="Dossier">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="Titre"/><xsl:value-of select="text()"/></a></p>
</xsl:template>

<xsl:template match="SousThemePere">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></p>
</xsl:template>

<xsl:template match="SousDossier">
  <div class="un-bloc-liens-comarquage">
    <h2><xsl:value-of select="Titre"/></h2><hr/>
 <xsl:for-each select="Fiche">
    <xsl:apply-templates select="."/>
</xsl:for-each>
  </div><!-- fin un bloc liens comarquage-->
</xsl:template>

<xsl:template match="Fiche">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></p>
</xsl:template>

<xsl:template match="ServiceEnLigne">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="Titre"/></a> <a href='index.php?fiche={Source/@ID}&amp;famille={$audience}'><xsl:value-of select="Source"/></a></p>
</xsl:template>

<xsl:template match="PourEnSavoirPlus">
    <xsl:variable name="audience" select="//Audience"/>
	<p><a href='{@URL}' target="_blank" aria-label="Pour en savoir plus (nouvelle fenêtre)"><xsl:value-of select="Titre"/></a> <a href='[lien]/{Source/@ID}' class="source-en-savoir-plus-N"><xsl:value-of select="Source"/> </a></p>
</xsl:template>

<xsl:template match="QuestionReponse">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></p>
</xsl:template>

<xsl:template match="VoirAussi">
   <div class="un-bloc-liens-comarquage fond-couleur">
    <h2>Voir aussi...</h2><hr/>
    <xsl:variable name="audience" select="//Audience"/>
 <xsl:for-each select="Dossier">
    <p><a href='[lien]/{@ID}'><xsl:value-of select="Titre"/></a></p>
</xsl:for-each>
  <xsl:for-each select="Fiche">
    <p><a href='[lien]/{@ID}'><xsl:value-of select="Titre"/></a></p>
</xsl:for-each>
 
	</div><!-- fin un bloc liens comarquage-->
</xsl:template>

<xsl:template match="Introduction">
   <xsl:for-each select="Texte">
    <xsl:apply-templates select="."/>
    <hr />
</xsl:for-each>
</xsl:template>

<xsl:template match="OuSAdresser">
    <h2>Où s'informer ?</h2><hr/>
    <h3><xsl:value-of select="Titre"/></h3>
	<xsl:if test="count(Complement) > 0">
    <h4><xsl:value-of select="Complement"/></h4>
	</xsl:if>
	<xsl:if test="count(RessourceWeb) > 0">
    <a href='{RessourceWeb/@URL}'><xsl:value-of select="Titre"/> (Site internet)</a>
	</xsl:if>
   <xsl:for-each select="Texte">
    	<xsl:apply-templates select="."/>
</xsl:for-each>
	
	<hr />
</xsl:template>

</xsl:stylesheet>

