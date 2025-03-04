<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="xsl dc">

	<xsl:output method="html" encoding="UTF-8" cdata-section-elements="script" indent="yes"/> 
  	
  	<xsl:template name="affDossierTexte" mode="Noeud-dossier">
  		<div class="spNoeudDossierTexte">
  			<xsl:apply-templates select="Texte"/>
  		</div>
  	</xsl:template>
  	
	<xsl:template match="Texte">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="Texte" mode="Definition">
		<xsl:apply-templates mode="Definition"/>
	</xsl:template>

	<xsl:template match="Texte" mode="OuSAdresser">
		<xsl:apply-templates mode="OuSAdresser"/>
	</xsl:template>

	<xsl:template match="Chapitre" mode="Definition">
		<xsl:apply-templates mode="Definition"/>
	</xsl:template>

	<xsl:template match="Chapitre" mode="OuSAdresser">
		<div class="spTexteChapitre">
			<xsl:apply-templates mode="OuSAdresser"/>
		</div>
	</xsl:template>

	<xsl:template match="Chapitre">
		<div class="	">
			<xsl:if test="Titre">
				<xsl:attribute name="class">
					<xsl:call-template name="createChapitreId"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@type != ''">
					<div class="spTexteChapitreNote">
						<xsl:call-template name="affTexteType"/>
						<xsl:apply-templates/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="SousChapitre">
		<div class="spTexteSousChapitre">
			<xsl:choose>
				<xsl:when test="@type != ''">
					<div class="spTexteSousChapitreNote">
						<xsl:call-template name="affTexteType"/>
						<xsl:apply-templates/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="Paragraphe" mode="Definition">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="Paragraphe" mode="OuSAdresser">
		<p class="spTexteParagraphe"><xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match="Paragraphe">
		<xsl:choose>
			<xsl:when test="name(..) = 'Titre'">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<p class="spTexteParagraphe"><xsl:apply-templates/></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="LienExterne">
		<xsl:variable name="title">
			<xsl:value-of select="text()"/>
			<xsl:text> - </xsl:text>
			<xsl:value-of select="@URL"/>
		</xsl:variable>
		<xsl:if test="text()">
   			<xsl:call-template name="getSiteLink">
   				<xsl:with-param name="href"><xsl:value-of select="@URL"/></xsl:with-param>
   				<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
   				<xsl:with-param name="text"><xsl:value-of select="text()"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="Liste" mode="OuSAdresser">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="Liste">
		<xsl:choose>
			<xsl:when test="name(..) = 'Item'">
				<ul class="spTexteListeListe"><xsl:apply-templates/></ul>
			</xsl:when>
			<xsl:otherwise>
				<ul class="spTexteListe"><xsl:apply-templates/></ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Item">
		<xsl:choose>
			<xsl:when test="name(../..) = 'Liste'">
				<li class="spTexteListeListe"><xsl:apply-templates/></li>
			</xsl:when>
			<xsl:otherwise test="name(../..) = 'Chapitre'">
				<li class="spTexteListe"><xsl:apply-templates/></li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Citation">
		<xsl:choose>
			<xsl:when test="text()">
				<span class="italic"><xsl:apply-templates/></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="MiseEnEvidence">
		<xsl:choose>
			<xsl:when test="text()">
				<span class="bold"><xsl:apply-templates/></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Description">
		<p class="spTexteDescription"><xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match="Tableau">
		<table class="spTexteTableau" cellspacing="0">
			<xsl:attribute name="summary">
				<xsl:choose>
					<xsl:when test="Rangée[@type='header']">
						<xsl:text>Tableau</xsl:text>
						<xsl:for-each select="Rangée[@type='header']/Cellule">
							<xsl:text> - </xsl:text>
							<xsl:value-of select="normalize-space(.)"/>
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="Rangée">
		<tr class="spTexteTableau">
			<xsl:choose>
				<xsl:when test="@type = 'header'">
					<xsl:apply-templates mode="header"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="normal"/>
				</xsl:otherwise>			
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template match="Cellule" mode="normal">
		<td class="spTexteTableau">
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="Cellule" mode="header">
		<th class="spTexteTableau">
			<xsl:apply-templates/>
		</th>
	</xsl:template>
	
	<xsl:template match="LienInterne">
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="@type ='Définition de glossaire'">
					<xsl:call-template name="getDefinition">
						<xsl:with-param name="id" select="@LienPublication"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@type"/>
					<!-- xsl:value-of select="$sepFilDAriane"/ -->
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- 
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$REFERER"/>xml=<xsl:value-of select="@LienPublication"/><xsl:text>.xml</xsl:text>&#x26;xsl=spFichePrincipale.xsl</xsl:attribute>
			<xsl:value-of select="text()"/>
		</a>
		-->
		<xsl:variable name="xsl">
			<xsl:choose>
				<xsl:when test="@nature ='Fiche'">
						<xsl:text>spFichePrincipale</xsl:text>
				</xsl:when>
				<xsl:when test="@nature ='Noeud'">
						<xsl:text>spNoeud</xsl:text>
				</xsl:when>
				<xsl:otherwise>
						<xsl:text>spRessource</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getPublicationLink">
			<xsl:with-param name="xml"><xsl:value-of select="@LienPublication"/></xsl:with-param>
			<xsl:with-param name="xsl"><xsl:value-of select="$xsl"/></xsl:with-param>
			<xsl:with-param name="title"><xsl:value-of select="$title"/></xsl:with-param>
			<xsl:with-param name="text"><xsl:value-of select="text()"/> </xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="getDefinition">
		<xsl:param name="id"/>	
		<xsl:variable name="texte">
			<xsl:apply-templates select="//Publication/Definition[@ID=$id]/Texte" mode="Definition"/>
		</xsl:variable>
		<xsl:text>Définition : </xsl:text>
		<xsl:value-of select="normalize-space($texte)"/>
	</xsl:template>

	<xsl:template match="RessourceWeb">
		<a href="{@URL}" title="{@URL}" rel="noffolow">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="Montant">
		<span class="spTexteMontant">
			<xsl:value-of select="text()"/>
			<xsl:text> </xsl:text>
			<abbr title="Euros">€</abbr>
		</span>
	</xsl:template>

	<xsl:template name="affTexteType">
		<img width="20" height="20" class="entiteImageFloatLeft">
			<xsl:choose>
				<xsl:when test="@type = 'note'">
					<xsl:attribute name="src">
						<xsl:value-of select="$IMAGES"/>
						<xsl:text>note.jpg</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="alt">
						<xsl:text>A noter</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'savoir'">
					<xsl:attribute name="src">
						<xsl:value-of select="$IMAGES"/>
						<xsl:text>a-savoir.png</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="alt">
						<xsl:text>A savoir</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'attention'">
					<xsl:attribute name="src">
						<xsl:value-of select="$IMAGES"/>
						<xsl:text>attention.jpg</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="alt">
						<xsl:text>Attention</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type = 'info'">
					<xsl:attribute name="src">
						<xsl:value-of select="$IMAGES"/>
						<xsl:text>info.png</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="alt">
						<xsl:text>Sachez que</xsl:text>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		</img>
	</xsl:template>

</xsl:stylesheet>
