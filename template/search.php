<?php
/**
 * @package Krea3
 */

get_header(); ?>


			
<div id="conteneur">



        <div id="la-page" class="largeur92">
        
        <?php include"outils.php"; ?>
        
        <div id="content" class="taille-texte-variable"><!--début de la zone dont le texte peut être agrandi / réduit--> 
        
        <div>
				
		<?php $sp_results = ServicePublic::searchEngine($_GET['s']); ?>

<?php if ( have_posts() || $sp_results ) : ?>
				<h1 class="page-title"><?php _e( 'R&eacute;sultats pour', 'nom-theme' ); ?> : <span><?php echo get_search_query(); ?></span></h1>
				<?php
				/* Run the loop for the search to output the results.
				 * If you want to overload this in a child theme then include a file
				 * called loop-search.php and that will be used instead.
				 */
				if($sp_results){
						foreach($sp_results as $family=>$datas){
								foreach($datas as $id=>$datas){
										$title = $datas['0'];
										$path = $datas['1'];
										echo '<div id="post-SP'.$id.'" class="sp_results '.$family.'">';
										echo '<h3 class="entry-title">';
										echo '<a href="/'.$path.'/'.$id.'" title="'.$title.'" rel="bookmark" ">'.$title.'</a></h3>';
										echo '<div class="entry-summary">';
										echo __('Vos démarches Service-Public.fr');
										echo'</div></div>';
		
								}
						}
				}
				if(have_posts()) get_template_part( 'loop', 'search' );
				?>
<?php else : ?>
				<div id="post-0" class="post no-results not-found">
					<h2 class="entry-title"><?php echo __('Aucun r&eacute;sultat'); ?><!--<?php _e( 'Nothing Found', 'twentyten' ); ?>--></h2>
					<div class="entry-content">
						<h3>
                        	<!--<?php _e( 'Sorry, but nothing matched your search criteria. Please try again with some different keywords.', 'nom-theme' ); ?>-->
                            <?php echo __('D&eacute;sol&eacute;, il n&apos;y a aucun r&eacute;sultat. Essayez une autre recherche.'); ?>
                       </h3>
						<?php get_search_form(); ?>
					</div><!-- .entry-content -->
				</div><!-- #post-0 -->
<?php endif; ?>
			</div>
            
            <div class="clearer"></div><!--fin de clearer-->
            
            </div><!--fin content  / fin de la zone dont le texte peut être agrandi / réduit-->
    
    <div class="clearer"></div><!--fin de clearer-->
    
    </div><!--fin la page-->
   

<?php get_footer(); ?>
