=== ServicePublic  ===
Contributors: krea3, Ville de Pont-Audemer
Tags: service public, comarquage
Requires at least: 4.7
Tested up to: 5.2.1
Stable tag: 0.5
Requires PHP: 5.6
License: GPLv2
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Affichage du co-marquage Service-Public.fr sur un site Wordpress

== Description ==

Ce plugin permet de reprendre les contenus xml de service-public.fr pour les intégrer à un site internet sous Wordpress.

Cf rubrique installation pour davantage d’informations.

Vous pouvez le voir en fonctionnement ici : https://www.ville-pont-audemer.fr/demarches-en-ligne/guide-demarches-ligne/


== Installation ==

Necessite la classe PHP 'ZipArchive' et son extension ZIP associee.

Pour prendre en compte le contenu, ajouter le champ personnalise 'sp_rubrique' a une page

Le champ personnalisé ‘sp_rubrique' peut prendre les valeurs tout, part, pro, asso

Hierarchie de prise en compte des feuilles xsl de transformation (par ordre de priorite) :
1.	/[path_template]/sp/[famille]/*.xsl
2.	/[path_template]/sp/common/*.xsl
3.	/[path_plugin]/sp/[famille]/*.xsl
4.	/[path_plugin]/sp/common/*.xsl

Pour surcharger les feuilles de transformation xsl il faut donc creer un repertoire 'sp' dans le theme actif et creer soit dans sp/common ou sp/[famille] les feuilles xsl.
[famille] peut etre part, pro ou asso.

Il y a un cron qui toutes les 24 heures recupere le dernier zip.
Les datas xml sont dezippees dans [upload_dir]/sp_xml/[famille]


== Changelog ==

= 0.5 =
Version stable
