<?php

/*
Plugin Name:  ServicePublic
Plugin URI: http://www.krea3.fr, https://www.ville-pont-audemer.fr/, http://www.ccpavr.fr
Description: Affichage du co-marquage Service-Public.fr sur un site Wordpress
Author : Gaylord Hue, Krea3 SARL, Commune de Pont-Audemer, Communauté de Communes Pont-Audemer Val de Risle
Version: 0.5
*/

/**
 * @package Krea3
 * @author Gaylord Hue, Krea3 SARL, Commune de Pont-Audemer, Communauté de Communes Pont-Audemer Val de Risle
 * @version 0.5
 */

require_once('utils.php');

define('SPP_PLUGIN_URL', rtrim(get_option('siteurl'),'/') . '/'. PLUGINDIR . '/' . basename(dirname(getConstantFile(__FILE__))) );
define('SPP_PLUGIN_DIR', ABSPATH . '/'. PLUGINDIR . '/' . basename(dirname(getConstantFile(__FILE__))) );

define('SPP_UPLOAD_DIR','sp_xml');
define('SPP_URL_PART','https://lecomarquage.service-public.fr/vdd/3.0/part/zip/');
define('SPP_URL_PRO','https://lecomarquage.service-public.fr/vdd/3.0/pro/zip/');
define('SPP_URL_ASSO','https://lecomarquage.service-public.fr/vdd/3.0/asso/zip/');

class SPP_ServicePublic{

    protected $upload_dir = '';
	
	//Initialisation du plugin

	public function __construct(){
        
        $uploads = wp_upload_dir();
        $this->upload_dir = $uploads['basedir'];
		
		register_activation_hook(getConstantFile(__FILE__), array(&$this,'activation'));
		register_deactivation_hook(getConstantFile(__FILE__), array(&$this,'deactivation'));
		add_action('plugins_loaded', array(&$this,'init'));
        add_action('init', array(&$this,'makeRewriteRules'));
        add_action('sp_cron',  array(&$this,'cron'));
	}
    
	public function init(){
        add_filter('the_content',array(&$this,'filterContent'));
		// wp_clear_scheduled_hook('sp_cron');
		 //wp_schedule_event( time(), 'daily', 'sp_cron' );
    }
	
	//Recupere le chemin (url) pour une rubrique  sans le ndd devant.
    
    public static function getPath(){
        
          $args = array(
            'post_status'=>'publish',
            'post_type' => 'page',
               'meta_query' => array(
                   array(
                       'key' => 'sp_rubrique'
                   )
               )
        );
        
        $query = new WP_Query($args);
        $posts = $query->posts;
        
        $families = array();
        
        foreach($posts as $post){
            $meta = get_post_meta($post->ID,'sp_rubrique',true);
            $path = SPP_ServicePublic::sanitizePath($post->ID);
            if(($meta == 'tout' || $meta=='part' ) && !array_key_exists('part',$families)){
                if($meta=='tout') $families['part']="$path/part";
                else $families['part']="$path";
            }
            if(($meta == 'tout' || $meta=='pro' ) && !array_key_exists('pro',$families)){
                if($meta=='tout') $families['pro']="$path/pro";
                else $families['pro']="$path";
            }
            if(($meta == 'tout' || $meta=='asso' ) && !array_key_exists('asso',$families)){
                if($meta=='tout') $families['asso']="$path/asso";
                else $families['asso']="$path";
            }
        }
        
        return $families;
        
    }
    
	//Permet de greffer les resultats dans le moteur de recherche standard WP
	
    public static function searchEngine($search){
        
        //On recherche seulement si ca vaut le coup (sp_rubrique existe avec tout ou part/pro/asso)
       $families = SPP_ServicePublic::getPath();
        
        if(count($families)<1) return null;
        
        $search = strtolower($search);
        $words = str_replace("'"," ",$search);
        $words = explode(' ',$words);
        $conditional = '';
        if(count($words)=='1') {
            if(strlen($_GET['s'])>3) $conditional = "contains(translate(., 'ABCDEFGHJIKLMNOPQRSTUVWXYZ', 'abcdefghjiklmnopqrstuvwxyz'),'".$_GET['s']."')";
        }
        else{
            
            foreach($words as $key=>$word){
                if(strlen($word)<4) continue;
                if($conditional) $conditional.= "and contains(translate(., 'ABCDEFGHJIKLMNOPQRSTUVWXYZ', 'abcdefghjiklmnopqrstuvwxyz'),'".$word."')";
                else $conditional = "contains(translate(., 'ABCDEFGHJIKLMNOPQRSTUVWXYZ', 'abcdefghjiklmnopqrstuvwxyz'),'".$word."')";
            }
        }
        
        
        
        $retour = null;
        if(!$conditional) return $retour;
        
        $uploads = wp_upload_dir();
        
        foreach($families as $family=>$path){
            
            $xml_doc = new DOMDocument();
            $xml_doc->load($uploads['basedir'].'/'.SPP_UPLOAD_DIR.'/'.$family.'/arborescence.xml');
            $xpath = new DomXPath($xml_doc);
            $Nodes = $xpath->query("//Item/Titre/text()[".$conditional."]/parent::*");
            
            $exist = array();

            foreach ($Nodes as $entry) {
               
                $type = $entry->parentNode->getAttribute('type');
                $ID = $entry->parentNode->getAttribute('ID');
                if(in_array($ID,$exist)) continue;
                $fichier = $entry->parentNode->getAttribute('fichier');
                $titre = $entry->parentNode->getElementsByTagName('Titre')->item(0)->nodeValue;
                
                //Il faut definir le lien
                
                $retour["$family"]["$ID"] = array($titre,$path);
                $exist[] = $ID;
            }   
        }
        
        return $retour;
    }
    
	//Creation des regles de redirection
	
    public function makeRewriteRules() {
        
        global $wp_rewrite;
  
        //Il faut trouver celles qui ont le sp_rubrique
        $args = array(
            'post_status'=>'publish',
        'post_type' => 'page',
           'meta_query' => array(
               array(
                   'key' => 'sp_rubrique'
               )
           )
        );
        
        $query = new WP_Query($args);
        $posts = $query->posts;
        
        add_rewrite_tag('%sp_family%','([^&]+)');
        add_rewrite_tag('%sp_xml%','([^&]+)');
        
        foreach($posts as $post) {
            $path = $this->sanitizePath($post->ID);
            $meta = get_post_meta($post->ID,'sp_rubrique',true);
            
            //Pour chaque page, il faut prendre en compte le tout / part / pro / asso
            //Si tout => 1 ou 2 parametres a rechercher
            //Sinon => 1 seul parametre a rechercher
            
            if($meta == 'tout'){
                
                $wp_rewrite->add_rule($path.'/([^/]+)/([^/]+)','index.php?pagename='.$path.'&sp_family=$matches[1]&sp_xml=$matches[2]','top');
                $wp_rewrite->add_rule($path.'/([^/]+)','index.php?pagename='.$path.'&sp_family=$matches[1]','top');
            }
            else{
                $wp_rewrite->add_rule($path.'/([^/]+)','index.php?pagename='.$path.'&sp_family='.$meta.'&sp_xml=$matches[1]','top');
            }
            
        }
        
        $wp_rewrite->flush_rules();
    }
    
	//Nettoie le chemin en supprimmant les slash avant/apres pour un ID de post
	
    public static function sanitizePath($id){
        $url = parse_url(get_permalink($id));
        $path = $url['path'];
        if(substr($path,0,1)=='/') $path = substr($path,1,strlen($path));
        if(substr($path,-1)=='/') $path = substr($path,0,strlen($path)-1);
        return $path;
    }
    
	//Filtre le contenu d'une page selon le champ personnalisé sp_rubrique
	
    public function filterContent($content) {
        global $wp_query;
		
        global $post;
        $sp_rubrique = get_post_meta($post->ID, 'sp_rubrique', true);
        if($sp_rubrique){
             $sp_family = $wp_query->query_vars['sp_family'];
             $sp_xml = $wp_query->query_vars['sp_xml'];
			  return $this->render($sp_xml,$sp_family);
           
        }
        else return $content;
    }
    
	//Créée le rendu d'une feuille XML selon sa famille
	
    protected function render($xml,$famille){
        
        if($famille==''){
            //Afficher le choix general => recuperer le template
            $file = get_template_directory() . '/sp/general.php';
            if(!@file_exists($file)) $file = SPP_PLUGIN_DIR. '/template/general.php';
            
            //On affiche le fichier
            //$content = @file_get_contents($file);
			//$content = wp_remote_retrieve_body( wp_remote_get($file) );
			//echo $file;
			include($file);
			
            return $content;
        }
        else{
            if($xml=='' || $xml=='Associations' || $xml=='Particuliers' || $xml=='Professionnels' ){
                //On affiche l'accueil
                $xml_file = $this->upload_dir.'/sp_xml/'.$famille.'/accueil.xml';
                $xsl_file = $this->selectXSL('accueil.xsl',$famille);
            }
            else{
                //On choisit le xml et la xsl
                 $xml_file = $this->upload_dir.'/sp_xml/'.$famille.'/'.$xml.'.xml';
                 $first =substr($xml,0,1);
    
                switch ($first) {
                    case 'F':
                         $xsl_file = $this->selectXSL('F.xsl',$famille);
                        break;
                    case 'N':
                         $xsl_file = $this->selectXSL('N.xsl',$famille);
                        break;
                    case 'R':
                        $xsl_file = $this->selectXSL('R.xsl',$famille);
                        break;
                    default:
                        $xsl_file = $this->selectXSL($xml.'.xsl',$famille);
                }
                
                //Attention actualité traitement special
                if($xml=='actualite'){
                     $xml_file = $this->upload_dir.'/sp_xml/'.$famille.'/actualites/index.xml';
                     $xsl_file =  $this->selectXSL('actualite.xsl',$famille);
                }
            }
        }
        
        //Faire les transformations xsl et transformer les menus
        
        $menu =  $this->transformDoc($this->upload_dir.'/sp_xml/'.$famille.'/menu.xml',$this->selectXSL('menu.xsl',$famille));
        
        //il faut faire un include des common.xsl et texte.xsl (remplace le DIR par URL)
        $includes = array();
        $includes[] = $this->selectXSL('common.xsl',$famille, 'dir');
        $includes[] = $this->selectXSL('texte.xsl',$famille, 'dir');
        
        $body = $this->transformDoc($xml_file,$xsl_file, $includes);
        
        $string = $menu.$body;
        
        $paths = SPP_ServicePublic::getPath(); 
        $string = str_replace('[lien]','/'.$paths["$famille"],$string);
        $string = str_replace('[lien_part]','/'.$paths['part'],$string);
        $string = str_replace('[lien_pro]','/'.$paths['pro'],$string);
        $string = str_replace('[lien_asso]','/'.$paths['asso'],$string);

        return $string;  
    }
    
	//Transforme une feuille xml avec la feuille xsl indiquée, et eventuellement les includes (autres feuilles xsml additionnelles)
	
    protected function transformDoc($xml_file,$xsl_file, $includes = null){
        
        //Transforme le document, en modifiant le lien
        $xml_doc = new DOMDocument();
        $xml_doc->load($xml_file);
        
        $xsl_doc = new DOMDocument();
        $string_xsl = file_get_contents($xsl_file);
		//$string_xsl = wp_remote_retrieve_body( wp_remote_get($xsl_file) );
		
        //$string_xsl = str_replace('[lien]','test.php',$string_xsl); //?? ou au retour final
        $xsl_doc->loadXML($string_xsl);
        
        if(is_array($includes)){
            foreach($includes as $id=>$file){
                $xsl_doc = $this->includeXSL($xsl_doc,$file);
            }
        }
        
        $proc = new XSLTProcessor();
        
        $proc->importStylesheet($xsl_doc);
        $newdom = $proc->transformToDoc($xml_doc);
        
        $string = $newdom->saveXML();
        return $string;
        
    }
    
	//Permet l'inclusion de feuilles xsl additionnelles
	
    protected function includeXSL($xsl_doc,$xsl_include){
        
        
         $importnode= $xsl_doc->createElement('xsl:include'); 
        $attr= $xsl_doc->createAttribute('href');
    
        $attr->value = $xsl_include;
        
        $importnode->appendChild($attr);

        $xsl_doc->getElementsByTagNameNS('http://www.w3.org/1999/XSL/Transform','stylesheet')->item(0)->appendChild($importnode); 
        $xsl_doc->loadXML($xsl_doc->saveXml());
    
        return $xsl_doc;
        
    }
	
	//Permet la selection de la feuille xsl selon la hierarchie expliquée dans le fichier readme.txt
    
    protected function selectXSL($xsl,$famille,$type = 'dir'){
        
        //On recherche dans l'ordre suivant
        //theme/sp/famille
        $file = get_template_directory() . '/sp/'.$famille.'/'.$xsl;
        if(@file_exists($file)){
            if($type=='dir') return $file;
            if($type=='url') return get_template_directory_uri() . '/sp/'.$famille.'/'.$xsl;
        }
        //theme/sp/common
        $file = get_template_directory() . '/sp/common/'.$xsl;
        if(@file_exists($file)){
            if($type=='dir') return $file;
            if($type=='url') return get_template_directory_uri() . '/sp/common/'.$xsl;
        }
        //plugin/xsl/famille
        $file = SPP_PLUGIN_DIR. '/xsl/'.$famille.'/'.$xsl;
        if(@file_exists($file)){
            if($type=='dir') return $file;
            if($type=='url') return SPP_PLUGIN_URL. '/xsl/'.$famille.'/'.$xsl;
        }
        //plugin/xsl/common
        $file = SPP_PLUGIN_DIR. '/xsl/common/'.$xsl;
        if(@file_exists($file)){
            if($type=='dir') return $file;
            if($type=='url') return SPP_PLUGIN_URL. '/xsl/common/'.$xsl;
            
        }
        
        return null;
    }
	
	//Fonction executée par le cron
    
    public function cron(){
		
        update_option('SPP_CRON',date('d/m/Y H:i:s'));
        $this->getLatestZip(SPP_URL_PART,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/part','SPP_PART_LATEST');
        $this->getLatestZip(SPP_URL_PRO,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/pro','SPP_PRO_LATEST');
        $this->getLatestZip(SPP_URL_ASSO,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/asso','SPP_ASSO_LATEST');
    }
	
	//Fonction appelée à l'activation du plugin
    
    public function activation(){
		
        $this->createDir($this->upload_dir.'/'.SPP_UPLOAD_DIR);
        $this->createDir($this->upload_dir.'/'.SPP_UPLOAD_DIR.'/part');
        $this->createDir($this->upload_dir.'/'.SPP_UPLOAD_DIR.'/pro');
        $this->createDir($this->upload_dir.'/'.SPP_UPLOAD_DIR.'/asso');
        
        //Importer les "latest"
        $this->getLatestZip(SPP_URL_PART,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/part','SPP_PART_LATEST');
        $this->getLatestZip(SPP_URL_PRO,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/pro','SPP_PRO_LATEST');
        $this->getLatestZip(SPP_URL_ASSO,$this->upload_dir.'/'.SPP_UPLOAD_DIR.'/asso','SPP_ASSO_LATEST');
        
        if ( !wp_next_scheduled('sp_cron') )
            wp_schedule_event( time(), 'daily', 'sp_cron' );

	}
    
	//Fonction de creation d'un dossier
	
    protected function createDir($dir){
        if(!is_dir($dir)){
            $is_created = mkdir($dir);
            if(!$is_created)  trigger_error('<strong>Le dossier '.$dir.'/part n\'a pû être créé. Verifiez les droits utilisateurs </strong>', E_USER_ERROR);
        }
    }
	
	//Fonction pour recuperer le dernier zip fournit par service-public.fr
    
    protected function getLatestZip($url,$to,$option_name){
        
        //Noter dans les options SPP_PART_LATEST, SPP_PRO_LATEST et SPP_ASSO_LATEST le nom du dernier fichier
        
        //$input = file_get_contents($url);
		$input = wp_remote_retrieve_body( wp_remote_get($url) );
		
        if(!$input)  trigger_error('<strong>Recuperation impossible de la liste des zip xml à l\'adresse '.SPP_URL_PART.'</strong>', E_USER_ERROR);
        $regexp = "<a\s[^>]*href=(\"??)([^\" >]*?)\\1[^>]*>(.*)<\/a>";
        if(preg_match_all("/$regexp/siU", $input, $matches, PREG_SET_ORDER)) {
            $file = null;
            $error = false;
            foreach($matches as $match) {
                // $match[2] = link address
                // $match[3] = link text
                if($match['2']>$file){
                    if(strpos($match['2'],'vosdroits_')!==false && substr($match['2'],-4)=='.zip'){   
                     $file = $match['2'];
                    }
                }    
            }
            
            if($file){
            
                $latest_file_downloaded = get_option($option_name);
                if($file=="$latest_file_downloaded") return true;
                
                //$archive = file_get_contents($url.'/'.$file);
				$archive = wp_remote_retrieve_body( wp_remote_get($url.'/'.$file) );
				
                if(!$archive) trigger_error('<strong>Recuperation impossible des fichiers xml à l\'adresse '.$url.'/'.$file.'</strong>', E_USER_ERROR);
                $write_zip = file_put_contents($to.'/xml.zip',$archive);
                if(!$write_zip) trigger_error('<strong>Ecriture impossible du fichier zip dans '.$to.'/xml.zip', E_USER_ERROR);
                $zip = new ZipArchive();
                if ($zip->open($to.'/xml.zip') === TRUE) {
                    $extract = $zip->extractTo($to);
                    if(!$extract){
                        trigger_error('<strong>L\'extraction du fichier zip '.$to.'/xml.zip a échoué', E_USER_ERROR);
                    }
                    else{
                        //On note dans les options
                        update_option($option_name,$file);
                        @unlink($to.'/xml.zip');
                    }
                    $zip->close();
                }
                else{
                 trigger_error('<strong>Impossible de lire le fichier zip '.$to.'/xml.zip', E_USER_ERROR);
                }
                    
            }
            else{
                 trigger_error('<strong>Le système n\'a trouvé aucun fichier vosdroits_*.zip à l\'adresse '.$url.'</strong>', E_USER_ERROR);
            }
        }
        else{
            trigger_error('<strong>Le système n\'a pû les lister les liens à l\'adresse '.$url.'</strong>', E_USER_ERROR);
        }
    }
    
	//Fonction appelée lorsque l'on desactive la plugin
	
	public function deactivation(){
		//Supprimer les options SP_* et le repertoire sp_xml
        //SP_rrmdir($this->upload_dir.'/'.SP_UPLOAD_DIR.'/part');
        //SP_rrmdir($this->upload_dir.'/'.SP_UPLOAD_DIR.'/pro');
        //SP_rrmdir($this->upload_dir.'/'.SP_UPLOAD_DIR.'/asso');
        
        //delete_option('SP_PART_LATEST');
        //delete_option('SP_PRO_LATEST');
        //delete_option('SP_ASSO_LATEST');
        
        wp_clear_scheduled_hook('sp_cron');
         
	}
	
}

//Lancement du plugin

new SPP_ServicePublic();



?>
