![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Modèle simplifié du réseau de fibre optique

Spécification du modèle de données simplifié relatif au réseau de fibre optique sur le territoire du Grand Compiègnois.

- [Script d'initialisation de la base de données](bdd/init_db_ftth_light.sql) 
- [Documentation d'administration de la base](bdd/doc_admin_bd_resh_light.md)

## Contexte

Le déploiement du réseau de fibre optique sur le territoire du Grand Compiégnois faisant intervenir de multiples acteurs (privé et publique) et que l'objectif in fine est la mise à disposition d'une application web-sig de consultation de l'ensemble des réseaux du territoire, il convient de mettre en place une nomenclature simplifiée permettant la centratlisation de l'information du réseau FTTH.

Les attendus de connaissances pour ce modèle simplifié concerne :
* la position cartographique des ouvrages du réseau (câbles, installations)
* la classe de précision cartographique au sens DT-DICT (C à défaut)
* le maitre d'ouvrage, l'exploitant et la référence / nom du contrat
* année ou période de pose
* les métadonnées qualités (date de la source ...)  
  
## Les données de références  
  
SFR :
* Les points de mutualisation avec leurs localisations et leurs emprises. Cette donnée est issue du déploiement initial des PM de la zone AMII sur le territoire de l'Agglmération de la Région de Compiègne.

Téloise :
* Il s'agit d'une table 

SMOTHD :
* Les données ont été reçue en décembre 2022. Elle se composent de site technique, d'ouvrages et de câbles.


Actions à mener :
* Pour la donnée sfr, renommer le schéma geo_ftth_sfr_pm pour harmonistation. Le soucis étant la sectorisation des PM qui ne permet pas une intégration au modèle simplifié
* Pour Téloise, intégrer les données d'infrastructure et de cable au modèle simplifié
* Pour le SMOTHD, intégrer les données reçues au modèle simplifié

## Modifications à effectuer suite à l'intégration du modèle en base

### Dans la base de données

`m_reseau_sec.geo_fo_sfr_pm` à renommer en `m_reseau_sec.geo_ftth_sfr_pm` pour un souci de cohérence.  la table est à conserver dans le cadre du maintient de l'application de développement de fibre optique et aussi car elle contient des données métiers non reprise dans le modèle simplifié.

`m_reseau_sec.geo_fo_teloise_infra`  à renommer en `m_reseau_sec.geo_ftth_teloise_infra` pour un souci de cohérence.  La table est à conserver car elle contient des données métiers non reprises dans le modèle simplifié.  


### Dans le Générateur d'application  

Application `Déploiement de la fibre optique` :
* modification de la carte associée pour prise en compte du renommage de la table `m_reseau_sec.geo_fo_sfr_pm`.

Application `Réseaux`
* Intégration de la donnée simplifiée dans l'application
* Suppression de la table `m_reseau_sec.geo_fo_teloise_infra` 




