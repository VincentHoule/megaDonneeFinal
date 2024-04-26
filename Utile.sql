/*
 Champs de CCroteau -> identifiant de chaine
 actif = 0  statuConfidentialite = 'private' statutTelechargement dureeEnseconde = 0
 Requete video valide :
*/
SELECT * FROM `videos` WHERE actif = 1 AND statuConfidentialite = 'public' AND statutTelechargement = 'processed' AND dureeEnSecondes > 0

 /*
 table utile
 etiquette
 categorie
 video-etiquettes

 table video
 titre
 clés étrangeres
 nombre de jaime
 nombre devues
 nombre de favorie
 actif
 statuConfientialite
 statutTelechargement
 dureeEnSecondes

 table chaines
 nom-titre
 nombre vue
 nombre video
 nombre d'abonnement
 date publication
 pays

 table categories
 titre

 table etiquettes
 nom

 */

 /*
 Stratégie 1
 nb videos par chaine
 nb videos par categorie
 */

select  chaines.titre, count(*) 
from chaines 
inner join videos on videos.identifiantChaine = chaines.identifiantUnique 
where videos.actif = 1 AND videos.statuConfidentialite = 'public' 
AND videos.statutTelechargement = 'processed' AND videos.dureeEnSecondes > 0
group by chaines.identifiantUnique 
order by chaines.titre;
 
select categories.titre , count(*) from categories
inner join videos on videos.identifiantCategorie = categories.id
WHERE videos.actif = 1 AND videos.statuConfidentialite = 'public' 
AND videos.statutTelechargement = 'processed' AND videos.dureeEnSecondes > 0
group by categories.id
order by categories.titre;

/*
Conclusion video par chaine < video par catégorie
*/

/*
selctionner toutes les videos qui ont la même catégories que la video précédante
*/
select * from videos where actif = 1 AND statuConfidentialite = 'public' AND statutTelechargement = 'processed' 
AND dureeEnSecondes > 0 and identifiantCategorie = 
(select identifiantCategorie from videos where videos.id = 1 ) 
order by nombreVues, nombreJaime, nombreFavoris
limit 10;
/*
selctionner toutes les videos qui ont la même catégories que les video précédante
*/

select * from videos where actif = 1 AND statuConfidentialite = 'public' AND statutTelechargement = 'processed' 
AND dureeEnSecondes > 0 and identifiantCategorie in(
(select identifiantCategorie from videos where videos.id = 1 ),
(select identifiantCategorie from videos where videos.id = 2 )  ) 
order by nombreVues, nombreJaime, nombreFavoris DESC
limit 10;

select titre, identifiantChaine, nombreVues , nombreJaime, nombreFavoris, langueParDefaut, identifiantCategorie
FROM videos
WHERE actif = 1 AND statuConfidentialite = 'public' AND statutTelechargement = 'processed' 
AND dureeEnSecondes > 0 or
(identifiantChaine = (select identifiantChaine from videos where videos.id = 5) or
identifiantChaine = (select identifiantChaine from videos where videos.id = 1220))
order by case when identifiantChaine in(
(select identifiantChaine from videos where videos.id = 5 ),
(select identifiantChaine from videos where videos.id = 1220 )) then 1 else 0 end desc,
case when identifiantCategorie in(
(select identifiantCategorie from videos where videos.id = 5 ),
(select identifiantCategorie from videos where videos.id = 1220 )) then 1 else 0 end desc,
case when langueParDefaut in(
(select langueParDefaut from videos where videos.id = 5 ),
(select langueParDefaut from videos where videos.id = 1220 )) then 1 else 0 end desc, nombreVues DESC;


