# Document d'administration de la base de donnée "Réseau FTTH"  

## Principes  

## Schéma fonctionnel 

## Dépendances (non critiques)  
La base de données simplifiée du réseau FTTH ne présente aucune dépendance à des données tierces.

## Classes d'objets  
L'ensemble des classes d'objets sont stockées dans le schéma `m_reseau_sec`.  

`[m_reseau_sec].[an_ftth_objet]` : Classe abstraite décrivant un objet d''un réseau humide  

| Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idftth|Identifiant unique de l'objet|bigint||
|idext|Identifiant externe de l'objet|character varying(254)||
|refprod|Référence producteur de l'entité|character varying(254)||
|enservice|Objet en service ou non (abandonné)|character varying(1)||
|andebpose|Année marquant le début de la période de pose|character varying(4)||
|anfinpose|Année marquant la fin de la période de pose|character varying(4)||
|sourmaj|Source de la mise à jour|character varying(100)||
|datemaj|Date de la dernière mise à jour des informations|date||
|qualgloc|Qualité de la géolocalisation (XYZ)|character varying(1)|C|
|insee|Code INSEE|character varying(5)||
|mouvrage|Maître d'ouvrage du réseau|character varying(100)||
|gexploit|Gestionnaire exploitant du réseau|character varying(100)||
|refcontrat|Références du contrat de délégation|character varying(100)||
|libcontrat|Nom du contrat de délégation|character varying(254)||
|observ|Observations|character varying(254)||
|dbinsert|Horodatage de l'intégration en base de l'objet|timestamp without time zone|now()|
|dbupdate|Horodatage de la mise à jour en base de l'objet|timestamp without time zone||

Particularité(s) à noter :  
* Une clé primaire existe sur le champ `idftth`  

--- 

`[m_reseau_sec].[geo_ftth_ouv]` : Classe décrivant un ouvrage du réseau FTTH  

| Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idftth|Identifiant unique de l'objet|bigint|
|typouv|Type d'ouvrage du réseau FTTH|character varying(80)||
|x|Coordonnée X Lambert 93 (en mètres)|numeric(10,3)||
|y|Coordonnée Y Lambert 93 (en mètres)|numeric(10,3)||
|ztn|Altimétrie du terrain naturel (en mètres, Référentiel NGFIGN69|numeric(7,3)||
|zouv|Altimétrie de l'ouvrage (en mètres, Référentiel NGFIGN69)|numeric(7,3)||
|geom|Géométrie ponctuelle de l'objet|geometry(Point,2154)||

Particularité(s) à noter : 
* Une clé primaire existe sur le champ idftth
* Une clé étrangère existe sur le champ idftth vers l'attribut du même nom de la classe an_ftth_objet

---

`[m_reseau_sec].[geo_ftth_cable]` : Classe décrivant un câble du réseau FTTH  

| Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idftth|Identifiant unique de l'objet|bigint||
|position|Position du câble du réseau FTTH|character varying(50)||
|longcalc|Longueur calculée du câble en mètre|numeric(7,3)||
|geom|Géométrie linéaire de l'objet|geometry(LineString,2154)||

Particularité(s) à noter : 
* Une clé primaire existe sur le champ idftth
* Une clé étrangère existe sur le champ idftth vers l'attribut du même nom de la classe an_ftth_objet

---

## Vues d'exploitation  

2 Vues **matérialisée** sont intégrées au schéma métier pour rendre compte des données ouvrages et câble du réseau FTT :

| Nom | Description |
|:---|:---|
|geo_vm_ftth_ouv|Ouvrages du réseau FTTH|
|geo_vm_ftth_cable|Câbles du réseau FTTH|