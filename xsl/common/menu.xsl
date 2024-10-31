<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 
<xsl:template match="/">
<!--html-->
<xsl:variable name="audience" select="//Audience"/>

<ul id="menu-top-guide-demarches">
 <xsl:choose>
         <xsl:when test="$audience = 'Particuliers'">
           <li id="comarquage-particuliers">
				<a href="[lien_part]" class="current-profil-comarquage">
					<span>Particuliers</span>
				</a>
       		</li>
         </xsl:when>
         <xsl:otherwise>
          <li id="comarquage-particuliers">
          		<a href="[lien_part]" class="light-profil-comarquage">
          			<span>Particuliers</span>
          		</a>
          </li>
         </xsl:otherwise>
 </xsl:choose>
 
  <xsl:choose>
         <xsl:when test="$audience = 'Professionnels'">
           <li id="comarquage-pro">
           		<a href="[lien_pro]" class="current-profil-comarquage">
					<span>Professionnels</span>
           		</a>
           </li>
         </xsl:when>
         <xsl:otherwise>
           <li id="comarquage-pro">
           		<a href="[lien_pro]" class="light-profil-comarquage">
					<span>Professionnels</span>
           		</a>
           </li>
         </xsl:otherwise>
 </xsl:choose>
 
  <xsl:choose>
         <xsl:when test="$audience = 'Associations'">
           <li id="comarquage-asso">
           		<a href="[lien_asso]" class="current-profil-comarquage">
           			<span>Associations</span>
           		</a>
           </li>
         </xsl:when>
         <xsl:otherwise>
          <li id="comarquage-asso">
          		<a href="[lien_asso]" class="light-profil-comarquage">
          			<span>Associations</span>
          		</a>
          </li>
         </xsl:otherwise>
 </xsl:choose>
 
</ul><!--fin menu guide des démarches-->

<hr/>

<!--menu 2 de la page comarquage boucle-->
<ul id="menu2-guide-demarches">
 	<xsl:for-each select="/Menu/Item[@type='Theme']">
        <xsl:apply-templates select="."/>
    </xsl:for-each>

	<li><a href="[lien]/centresDeContact">Centres de contact</a></li>
	<li><a href="[lien]/actualite">Actualites</a></li>
	
</ul><!--fin du menu2 guide demarches-->

<hr/>

<!--/html-->
</xsl:template>

<!--menu 2 de la page comarquage 1 item-->
<xsl:template match="Item">
 <xsl:variable name="audience" select="//Audience"/>
 <li><a href="[lien]/{@ID}"><xsl:value-of select="Titre" ></xsl:value-of></a></li>
</xsl:template>
 
</xsl:stylesheet>