<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/">

<xsl:template match="/">
    
<!--html-->
    <xsl:variable name="audience" select="//Audience"/>
    <!--head>
        <title><xsl:value-of select="/Publication/dc:title"/></title>
    </head>
    
    <body-->
    
    <div id="fil-ariane-comarquage">
 	<xsl:apply-templates select="/Publication/FilDAriane"/>
 	</div><!--fin fil ariane comarquage-->
 
    
    <h1><xsl:value-of select="/Publication/dc:title"/></h1>
    <!--p><a href='index.php?fiche={/Publication/Theme/@ID}&amp;famille={$audience}'><xsl:value-of select="/Publication/Theme"/></a></p>
    <p><xsl:value-of select="/Publication/SousThemePere"/></p>
    <p><xsl:value-of select="/Publication/SousDossierPere"/></p>
    <p><xsl:apply-templates select="/Publication/DossierPere"/></p-->
    <p><xsl:apply-templates select="/Publication/Introduction"/></p>
    <p><xsl:apply-templates select="/Publication/Texte"/></p>
	<p><xsl:apply-templates select="/Publication/ListeSituations"/></p>
    <p><xsl:apply-templates select="/Publication/OuSAdresser"/></p>
    
    <hr/>
    
    <div class="un-bloc-liens-comarquage">
    <h2>Textes de référence</h2><hr/>
    <xsl:apply-templates select="/Publication/Reference"/>
    </div><!-- fin un bloc liens comarquage-->
    
    <div class="un-bloc-liens-comarquage">
    <h2>Questions - Réponses</h2><hr/>
    <xsl:apply-templates select="/Publication/QuestionReponse"/>
    </div><!-- fin un bloc liens comarquage-->
    
    <!-- Reference, Question/Reponse -->
    
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

<xsl:template match="DossierPere">

       <p><xsl:value-of select="Titre"/>
        <ul>
    <xsl:for-each select="SousDossier">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
  </ul></p>
</xsl:template>

<xsl:template match="SousDossier">
  <ul>
        <li><xsl:value-of select="Titre"/></li>
        <ul>
 <xsl:for-each select="Fiche">
    <xsl:apply-templates select="."/>
</xsl:for-each>
  </ul></ul>
</xsl:template>

<xsl:template match="Fiche">
  <xsl:variable name="audience" select="//Audience"/>
  <li><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></li>
</xsl:template>

<xsl:template match="Texte">
   <xsl:for-each select="Paragraphe|Liste|Attention">
        <xsl:apply-templates select="."/>
    </xsl:for-each>
</xsl:template>

<xsl:template match="ListeSituations">
   <xsl:for-each select="Situation">
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

<xsl:template match="Reference">
   <xsl:variable name="audience" select="//Audience"/> 
  <p><a href='{@URL}'><xsl:value-of select="Titre"/></a> <xsl:value-of select="Complement"/></p>
</xsl:template>

<xsl:template match="QuestionReponse">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'><xsl:value-of select="text()"/></a></p>
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

<xsl:template match="ServiceEnLigne">
    <xsl:variable name="audience" select="//Audience"/>
  <p><a href='[lien]/{@ID}'>Service en ligne / Formulaires : <xsl:value-of select="Titre"/> - Cliquez-ici</a></p>
</xsl:template>

    
</xsl:stylesheet>