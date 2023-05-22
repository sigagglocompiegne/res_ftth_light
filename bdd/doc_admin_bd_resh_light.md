# Document d'administration de la base de donnée "Réseau FTTH"  

## Principes  

## Schéma fonctionnel 

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
|dbinsert|Horodatage de l'intégration en base de l'objet|timestamp without time zone||
|dbupdate|Horodatage de la mise à jour en base de l'objet|timestamp without time zone||

Particularité(s) à noter :  
* Une clé primaire existe sur le champ `idftth`  

--- 

`[m_reseau_sec].[geo_ftth_ouv]` : Classe décrivant un ouvrage du réseau FTTH  

| Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|