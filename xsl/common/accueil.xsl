<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
<xsl:template match="/">
<xsl:variable name="audience" select="//Audience"/>
<!--html>
    <head>
        <title><xsl:value-of select="/Publication/SurTitre"/></title>
    </head>
    
    <body-->
<h1><xsl:value-of select="/Publication/Audience"/></h1>
<xsl:for-each select="/Publication/Groupe">
    <xsl:apply-templates select="."/>
</xsl:for-each>

    <!--/body>
</html-->
</xsl:template>

<xsl:template match="Groupe[@type='Service en ligne']">
    <xsl:variable name="audience" select="//Audience"/>
    <div class="un-bloc-liens-comarquage small">
		<h2><xsl:value-of select="Titre" ></xsl:value-of></h2><hr/>
		<xsl:for-each select="ServiceEnLigne">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<p class="tous-les"><a href="[lien]/servicesEnLigne">Tous les <xsl:value-of select="Titre" ></xsl:value-of></a></p>
	</div><!--fin de un bloc liens comarquage-->
</xsl:template>
              
<xsl:template match="Groupe[@type='Simulateur']">
    <xsl:variable name="audience" select="//Audience"/>
    <div class="un-bloc-liens-comarquage small">
		<h2><xsl:value-of select="Titre" ></xsl:value-of></h2><hr/>
		 <xsl:for-each select="ServiceEnLigne">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<p class="tous-les"><a href="[lien]/servicesEnLigne">Tous les simulateurs</a></p>
      </div><!--fin de un bloc liens comarquage-->
</xsl:template>

<xsl:template match="Groupe[@type='Fiche Question-réponse']">
    <xsl:variable name="audience" select="//Audience"/>
    <div class="un-bloc-liens-comarquage small">
	   <h2><xsl:value-of select="Titre" ></xsl:value-of></h2><hr/>
		<xsl:for-each select="QuestionReponse">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
		<p class="tous-les"><a href="[lien]/questionsReponses">Toutes les questions-reponses</a></p>
    </div><!--fin de un bloc liens comarquage-->
</xsl:template>

<xsl:template match="Groupe[@type='Fiche Comment faire si']">
    <xsl:variable name="audience" select="//Audience"/>
    <div class="un-bloc-liens-comarquage small">
    	<h2><xsl:value-of select="Titre" ></xsl:value-of></h2><hr/>
		 <xsl:for-each select="CommentFaireSi">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
     	<p class="tous-les"><a href="[lien]/commentFaireSi">Tous les <xsl:value-of select="Titre" ></xsl:value-of></a></p>
     </div><!--fin de un bloc liens comarquage-->
</xsl:template>


<!-- 1 item services en ligne -->
<xsl:template match="ServiceEnLigne">
    <xsl:variable name="audience" select="//Audience"/>
 <p><a href="[lien]/{@ID}"><xsl:value-of select="Titre" ></xsl:value-of></a></p>
 <xsl:apply-templates select="Source"/>
</xsl:template>

<!-- 1 item questions réponses -->
<xsl:template match="QuestionReponse">
     <xsl:variable name="audience" select="//Audience"/>
 <p><a href="[lien]/{@ID}"><xsl:value-of select="text()" ></xsl:value-of></a></p>
</xsl:template>

<!-- 1 item comment faire si -->
<xsl:template match="CommentFaireSi">
  <xsl:variable name="audience" select="//Audience"/>
 <p><a href="[lien]/{@ID}"><xsl:value-of select="text()" ></xsl:value-of></a></p>
</xsl:template>

<!-- 1 item Source -->
<xsl:template match="Source">
 <!--p>Source <xsl:value-of select="@ID" ></xsl:value-of>  : <xsl:value-of select="text()" ></xsl:value-of></p-->
</xsl:template>

 
</xsl:stylesheet>