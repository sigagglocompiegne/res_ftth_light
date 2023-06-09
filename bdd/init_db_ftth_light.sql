/*
Base de données "simplifiée" du réseaux FTTH issues des données concessionnaires
Creation du squelette de la structure (table, séquence, ...)
init_db_ftth_light.sql

GeoCompiegnois - http://geo.compiegnois.fr/
Auteur : Kévin Messager


09/05/2023 : Structure V1 à valider et à contrôler
16/05/2023 : Suppression du champ boitier dans la table des ouvrages -> non intégration de la donnée des appareilages. Ine fine -> câbles + ouvrages
18/05/2023 : Ajout d'un champ idext corespondant à l'id externe de l'objet (exemple : id national)
22/05/2023 : Strucure validée à implémenter en base -- Intégration en base de prod
*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SUPPRESSION                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue
DROP MATERIALIZED VIEW IF EXISTS m_reseau_sec.geo_vm_ftth_cable;
DROP MATERIALIZED VIEW IF EXISTS m_reseau_sec.geo_vm_ftth_ouv;

-- fkey
ALTER TABLE IF EXISTS m_reseau_sec.geo_ftth_ouv DROP CONSTRAINT IF EXISTS geo_ftth_ouv_idftth_fkey;
ALTER TABLE IF EXISTS m_reseau_sec.geo_ftth_cable DROP CONSTRAINT IF EXISTS geo_ftth_cable_idftth_fkey;

-- classe
DROP TABLE IF EXISTS m_reseau_sec.an_ftth_objet;
DROP TABLE IF EXISTS m_reseau_sec.geo_ftth_cable;
DROP TABLE IF EXISTS m_reseau_sec.geo_ftth_ouv;

-- sequence
DROP SEQUENCE IF EXISTS m_reseau_sec.an_ftth_objet_idftth_seq;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Sequence : m_reseau_sec.idftth_seq;
-- DROP SEQUENCE m_reseau_sec.idftth_seq;

CREATE SEQUENCE m_reseau_sec.an_ftth_objet_idftth_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                  CLASSE OBJET                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################ CLASSE RESEAU ##############################################


-- Table : m_reseau_sec.an_ftth_objet
-- DROP TABLE m_reseau_sec;an_ftth_objet;

CREATE TABLE m_reseau_sec.an_ftth_objet
(
	idftth bigint NOT NULL,
	idext character varying(254),
	refprod character varying(254),
	enservice character varying(1),
	andebpose character varying(4),
	anfinpose character varying(4),
	sourmaj character varying(100) NOT NULL,
	datemaj date NOT NULL,
	qualgloc character varying(1) NOT NULL DEFAULT 'C',
	insee character varying(5),
	mouvrage character varying(100),
	gexploit character varying(100),
	refcontrat character varying(100),
	libcontrat character varying(100),
	observ character varying(254),
	dbinsert timestamp without time zone NOT NULL DEFAULT now(),
	dbupdate timestamp without time zone,
	CONSTRAINT an_ftth_objet_pkey PRIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);

COMMENT ON TABLE m_reseau_sec.an_ftth_objet
	IS 'Classe abstraite décrivant un objet du réseau ftth';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.idext IS 'identifiant externe de l''objet';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.refprod IS 'Référence producteur de l''entité';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.anfinpose IS 'Année marquant la fin de la période de pose';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.sourmaj IS 'Source de la mise à jour';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.qualgloc IS 'Qualité de la géolocalisation (XYZ)';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.insee IS 'Code INSEE';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.refcontrat IS 'Référence du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.libcontrat IS 'Nom du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.observ IS 'Observations';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.dbinsert IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.dbupdate IS 'Horodatage de la mise à jour en base de l''objet';



-- ################################################################ CLASSE OUV ##############################################


-- Table : geo_ftth_ouv
-- DROP TABLE m_reseau_sec.geo_ftth_ouv;

CREATE TABLE m_reseau_sec.geo_ftth_ouv
(
	idftth bigint NOT NULL,
	typouv character varying(80) NOT NULL,
	x numeric(10,3) NOT NULL,
	y numeric(10,3) NOT NULL,
	ztn numeric(7,3) NOT NULL,
	zouv numeric(7,3) NOT NULL,
	geom geometry(Point,2154) NOT NULL,
	CONSTRAINT geo_ftth_ouv_pkey PRIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);
	
COMMENT ON TABLE m_reseau_sec.geo_ftth_ouv
	IS 'Classe décrivant un ouvrage du réseau ftth';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.idftth IS 'Identifiant unique d''objet';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.typouv IS 'type d''ouvrage du réseau FTTH';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.ztn IS 'Altimétrie du terrain naturel (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.zouv IS 'Altimétrie de l''ouvrage (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.geom IS 'Géométrie ponctuelle de l''objet';


-- ################################################################ CLASSE_CABLE ##############################################


-- Table : m_reseau_sec.geo_ftth_cable
-- DROP TABLE m_reseau_sec.geo_ftth_cable

CREATE TABLE m_reseau_sec.geo_ftth_cable
(
	idftth bigint NOT NULL,
	positio character varying(50),
	longcalc numeric(7,3) NOT NULL,
	geom geometry(LineString,2154) NOT NULL,
	CONSTRAINT geo_ftth_cable_pkey PRIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);

COMMENT ON TABLE m_reseau_sec.geo_ftth_cable
	IS 'Classe décivant un cable du réseau ftth';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_cable.idftth IS 'Identifiant unique d''objet';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_cable.positio IS 'Position du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_cable.longcalc IS 'Longueur du câble calculée en mètre';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_cable.geom IS 'Géométrie linéaire de l''objet';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- idftth

ALTER TABLE m_reseau_sec.geo_ftth_cable
	ADD CONSTRAINT geo_ftth_cable_idftth_fkey FOREIGN KEY (idftth)
	REFERENCES m_reseau_sec.an_ftth_objet (idftth) MATCH SIMPLE
	ON UPDATE NO ACTION
	ON DELETE CASCADE;

ALTER TABLE m_reseau_sec.geo_ftth_ouv
	ADD CONSTRAINT geo_ftth_ouv_idftth_fkey FOREIGN KEY (idftth)
	REFERENCES m_reseau_sec.an_ftth_objet (idftth) MATCH SIMPLE
	ON UPDATE NO ACTION
	ON DELETE CASCADE;


-- #################################################################### VUE OUV ###############################################


-- View : m_reseau_sec.geo_vm_ftth_ouv
-- DROP MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv

CREATE MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv AS
	SELECT
	a.idftth,
	a.idext,
	a.refprod,
	a.enservice,
	g.typouv,
	g.x,
	g.y,
	g.ztn,
	g.zouv,
	a.andebpose,
	a.anfinpose,
	a.sourmaj,
	a.datemaj,
	a.qualgloc,
	a.insee,
	a.mouvrage,
	a.gexploit,
	a.refcontrat,
	a.libcontrat,
	a.observ,
	a.dbinsert,
	a.dbupdate,
	g.geom

FROM m_reseau_sec.geo_ftth_ouv g
	NATURAL JOIN m_reseau_sec.an_ftth_objet a USING (idftth)
ORDER BY a.idftth;
	
COMMENT ON MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv
	IS 'VM joignant les classe d''objets : an_ftth_objet et geo_ftth_ouv';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.idext IS 'identifiant externe de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.refprod IS 'Référence producteur de l''entité';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.typouv IS 'type d''ouvrage du réseau FTTH';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.ztn IS 'Altimétrie du terrain naturel (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.zouv IS 'Altimétrie de l''ouvrage (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.anfinpose IS 'Année marquant la fin de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.sourmaj IS 'Source de la mise à jour';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.qualgloc IS 'Qualité de la géolocalisation (XYZ)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.insee IS 'Code INSEE';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.refcontrat IS 'Référence du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.libcontrat IS 'Nom du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.observ IS 'Observations';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.dbinsert IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.dbupdate IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.geom IS 'Géométrie linéaire de l''objet';


-- #################################################################### VUE_CABLE ###############################################


-- View : m_reseau_sec.geo_vm_ftth_cable
-- DROP MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_cable

CREATE MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_cable AS
	SELECT
	a.idftth,
	a.idext,
	a.refprod,
	a.enservice,
	g.positio,
	g.longcalc,
	a.andebpose,
	a.anfinpose,
	a.sourmaj,
	a.datemaj,
	a.qualgloc,
	a.insee,
	a.mouvrage,
	a.gexploit,
	a.refcontrat,
	a.libcontrat,
	a.observ,
	a.dbinsert,
	a.dbupdate,
	g.geom

FROM m_reseau_sec.geo_ftth_cable g
 NATURAL JOIN m_reseau_sec.an_ftth_objet a
ORDER BY a.idftth;

COMMENT ON MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_cable
	IS 'VM joignant les classe d''objets : an_ftth_objet et geo_ftth_cable';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.idext IS 'identifiant externe de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.refprod IS 'Référence producteur de l''entité';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.positio IS 'Position du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.longcalc IS 'Longueur du câble calculée';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.anfinpose IS 'Année marquant la fin de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.sourmaj IS 'Source de la mise à jour';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.datemaj IS 'Date de la dernière mise à jour des informations';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.qualgloc IS 'Qualité de la géolocalisation (XYZ)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.insee IS 'Code INSEE';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.mouvrage IS 'Maître d''ouvrage du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.gexploit IS 'Gestionnaire exploitant du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.refcontrat IS 'Référence du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.libcontrat IS 'Nom du contrat de délégation';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.observ IS 'Observations';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.dbinsert IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.dbupdate IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_cable.geom IS 'Géométrie linéaire de l''objet';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        DROITS                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


ALTER TABLE m_reseau_sec.an_ftth_objet
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.an_ftth_objet TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.an_ftth_objet TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.an_ftth_objet TO create_sig;
GRANT SELECT ON TABLE m_reseau_sec.an_ftth_objet TO sig_edit;

ALTER TABLE m_reseau_sec.geo_ftth_ouv
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_ouv TO create_sig;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_edit;

ALTER TABLE m_reseau_sec.geo_ftth_cable
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_cable TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_cable TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_cable TO create_sig;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_cable TO sig_edit;

ALTER MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO create_sig;
grant SELECT ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_edit;

ALTER MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_cable
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_cable TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_vm_ftth_cable TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_cable TO create_sig;
GRANT SELECT ON TABLE m_reseau_sec.geo_vm_ftth_cable TO sig_edit;

ALTER SEQUENCE m_reseau_sec.an_ftth_objet_idftth_seq OWNER TO create_sig;
GRANT ALL ON SEQUENCE m_reseau_sec.an_ftth_objet_idftth_seq TO create_sig;
GRANT ALL ON SEQUENCE m_reseau_sec.an_ftth_objet_idftth_seq TO public;
