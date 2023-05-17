![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Modèle simplifié du réseau de fibre optique

Spécification du modèle de données simplifié relatif au réseau de fibre optique sur le territoire du Grand Compiègnois.

- [Script d'initialisation de la base de données](bdd/init_db_ftth_light.sql) 
- [Documentation d'administration de la base](bdd/doc_admin_bd_resh_light.md)

## Contexte

Le déploiement du réseau de fibre optique sur le territoire du Grand Compiégnois faisant intervenir de multiples acteurs (privé et publique) et que l'objectif in fine est la mise à disposition d'une application web-sig de consultation de l'ensemble des réseaux du territoire, il convient de mettre en place une nomenclature simplifiée permettant la centratlisation de l'information du réseau FTTH.

Les attendus de connaissances pour ce modèle simplifié concerne :
* la poistion cartographique des ouvrages du réseau (canalisation, installation)
* la classe de précision cartographique au sens DT-DICT (C à défaut)
* le maitre d'ouvrage, l'exploitant et la référence / nom du contrat
* année ou période de pose
* les métadonnées qualités (date de la source ...)  
  
## Les données de références  
  
SFR :
* Les points de mutualisation avec leur localisation et leurs emprises

Téloise :
* deux tables, une d'infrastructure et une de cable. A regarder car les champs sont les même mais la donnée cataloguée est celle de l'infra.

SMOTHD :
* Les données ont été reçue en décembre 2022. Elle se composent de site technique, d'ouvrages et de câbles.


Actions à mener :
* Pour la donnée sfr, renommer le schéma geo_ftth_sfr_pm pour harmonistation. Le soucis étant la sectorisation des PM qui ne permet pas une intégration au modèle simplifié
* Pour Téloise, intégrer les données d'infrastructure et de cable au modèle simplifié
* Pour le SMOTHD, intégrer les données reçues au modèle simplifié


