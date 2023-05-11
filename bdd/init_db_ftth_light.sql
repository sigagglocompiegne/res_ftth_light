/*
Base de données "simplifiée" du réseaux FTTH issues des données concessionnaires
Creation du squelette de la structure (table, séquence, ...)
init_bd_ftth_light.sql

GeoCompiegnois - http://geo.compiegnois.fr/
Auteur : Kévin Messager
*/

-- 09/05/2023 : Structure V1 à valider et à contrôler


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SUPPRESSION                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- vue
DROP MATERIALIZED VIEW IF EXISTS m_reseau_sec.geo_vm_ftth_can;
DROP MATERIALIZED VIEW IF EXISTS m_reseau_sec.geo_vm_ftth_ouv;

-- fkey
ATLER TABLE IF EXISTS m_reseau_sec.geo_ftth_can DROP CONSTRAINT geo_ftth_can_fkey;
ATLER TABLE IF EXISTS m_reseau_sec.geo_ftth_can DROP CONSTRAINT geo_ftth_ouv_fkey;

-- classe
DROP TABLE IF EXISTS m_reseau_sec.an_ftth_objet;
DROP TABLE IF EXISTS m_reseau_sec.geo_ftth_can;
DROP TABLE IF EXISTS m_reseau_sec.geo_ftth_ouv;

-- sequence
DROP SEQUENCE IF EXISTS m_reseau_sec.idftth_seq;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SEQUENCE                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Sequence : m_reseau_sec.idftth_seq;
-- DROP SEQUENCE m_reseau_sec.idftth_seq;

CREATE SEQUENCE m_reseau_sec.idftth_seq
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
	idftth biint NOT NULL,
	refprod character varying(254),
	enservice character varying(1),
	andebpose character varying(4),
	anfinpose character varying(4),
	sourmaj character varying(100) NOT NULL,
	datemaj date NOT NULL,
	qualgloc character varying(1) NOT NULL DEFAULT 'C',
	insee character varying(5),
	mouvrage character varying(100),
	libcontrat character varying(100),
	observ character varying(254),
	dbinsert timestamp without time zone NOT NULL DEFAULT now(),
	dbupdate timestamp without time zone,
	CONSTRAINT an_ftth_objet_pkay ORIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);

COMMENT ON TABLE m_reseau_sec.an_ftth_objet
	IS 'Classe abstraite décrivant un objet du réseau ftth';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.refprod IS 'Référence producteur de l''entité'
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.an_ftth_objet.afinpose IS 'Année marquant la fin de la période de pose';
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

ALTER TABLE m_reseau_sec.an_ftth_objet ALTER COLUMN idftth SET DEFAULT nexval('m_reseau_sec.idftth_seq'::regclass);


-- ################################################################ CLASSE OUV ##############################################


-- Table : geo_ftth_ouv
-- DROP TABLE m_reseau_sec.geo_ftth_ouv;

CREATE TABLE m_reseau_sec.geo_ftth_ouv
(
	idftth bigint NOT NULL,
	fnouv character varying(80) NOT NULL,
	x numeric(10,3) NOT NULL,
	y numeric(10,3) NOT NULL,
	ztn numeric(7,3) NOT NULL,
	geom geometry(Point,2154) NO NULL,
	CONSTRAINT geo_ftth_ouv_pkey PRIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);
	
COMMENT ON TABLE m_reseau_sec.geo_ftth_ouv
	IS 'Classe décrivant un ouvrage du réseau ftth';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.idftth IS 'Identifiant unique d''objet';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.fnouv IS 'Fonction de l''ouvrage du réseau FTTH';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.ztn IS 'Altimétrie du terrain naturel (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.zouv IS 'Altimétrie de l''ouvrage (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_ouv.geom IS 'Géométrie ponctuelle de l''objet';


-- ################################################################ CLASSE CAN ##############################################


-- Table : m_reseau_sec.geo_ftth_can
-- DROP TABLE m_reseau_sec.geo_ftth_can

CREATE TABLE m_reseau_sec.geo_ftth_can
(
	idftth bigint NOT NULL,
	position integer,
	longcalc numeric(7,3) NOT NULL,
	geom geometry(LineString,2154) NOT NULL,
	CONSTRAINT geo_ftth_can_pkey PRIMARY KEY (idftth)
)
WITH (
	OIDS=FALSE
);

COMMENT ON TABLE m_reseau_sec.geo_ftth_can
	IS 'Classe décivant un cable du réseau ftth'
COMMENT ON COLUMN m_reseau_sec.geo_ftth_can.idftth IS 'Identifiant unique d''objet';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_can.position IS 'Position du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_can.longcalc IS 'Longueur du câble calculée en mètre';
COMMENT ON COLUMN m_reseau_sec.geo_ftth_can.geom IS 'Géométrie linéaire de l''objet';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                           FKEY (clé étrangère)                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- idftth

ALTER TABLE m_reseau_sec.geo_ftth_can
	ADD CONSTRAINT geo_ftth_can.idftth fkey FOREIGN KEY (idftth)
	REFERENCES m_reseau_sec.an_ftth_objet (idftth) MATCH SIMPLE
	ON UPDATE NO ACTION
	ON DELETE CASCADE;

ALTER TABLE m_reseau_sec.geo_ftth_ouv
	ADD CONSTRAINT geo_ftth_ouv.idftth_fkey FOREIGN KEY (idftth)
	REFERENCES m_reseau_sec.an_ftth_objet (idftth) MATCH SIMPLE
	ON UPDATE NO ACTION
	ON DELETE CASCADE;


-- #################################################################### VUE OUV ###############################################


-- View : m_reseau_sec.geo_vm_ftth_ouv
-- DROP MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv

CREATE MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv AS
	SELECT
	a.idftth
	a.refprod
	a.enservice
	g.fnouv
	g.x
	g.y
	g.ztn
	g.zouv
	a.andebpose
	a.anfinpose
	a.sourmaj
	a.datemaj
	a.qualgloc
	a.insee
	a.mouvrage
	a.gexploit
	a.refcontrat
	a.libcontrat
	a.observ
	a.dbinsert
	a.dbupdate
	g.geom

FROM m_reseau_sec.geo_ftth_ouv g
LEFT JOIN m_reseau_sec.an_ftth_objet a USING (idftth)
ORDER BY a.idftth;
	
COMMENT ON MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv
	IS 'VM joignant les classe d''objets : an_ftth_objet et geo_ftth_ouv';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.refprod IS 'Référence producteur de l''entité'
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.fnouv IS 'Fonction de l''ouvrage du réseau FTTH';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.x IS 'Coordonnée X Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.y IS 'Coordonnée Y Lambert 93 (en mètres)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.ztn IS 'Altimétrie du terrain naturel (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.zouv IS 'Altimétrie de l''ouvrage (en mètres, Référentiel NGFIGN69)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.afinpose IS 'Année marquant la fin de la période de pose';
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


-- #################################################################### VUE CAN ###############################################


-- View : m_reseau_sec.geo_vm_ftth_can
-- DROP MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_can

CREATE MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_can AS
	SELECT
	a.idftth
	a.refprod
	a.enservice
	g.position
	g.longcalc
	a.andebpose
	a.anfinpose
	a.sourmaj
	a.datemaj
	a.qualgloc
	a.insee
	a.mouvrage
	a.gexploit
	a.refcontrat
	a.libcontrat
	a.observ
	a.dbinsert
	a.dbupdate
	g.geom

FROM m_reseau_sec.geo_ftth_can g
LEFT JOIN m_reseau_sec.an_ftth_objet a USING (idftth)
ORDER BY a.idftth;

COMMENT ON MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_can
	IS 'VM joignant les classe d''objets : an_ftth_objet et geo_ftth_can';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.idftth IS 'identifiant unique de l''objet';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.refprod IS 'Référence producteur de l''entité'
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.enservice IS 'Objet en service ou non (abandonné)';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.position IS 'Position du réseau';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.longcalc IS 'Longueur du câble calculée';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.andebpose IS 'Année marquant le début de la période de pose';
COMMENT ON COLUMN m_reseau_sec.geo_vm_ftth_ouv.afinpose IS 'Année marquant la fin de la période de pose';
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
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.an_ftth_objet TO sig_edit;

ALTER TABLE m_reseau_sec.geo_ftth_ouv
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_ouv TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.geo_ftth_ouv TO sig_edit;

ALTER TABLE m_reseau_sec.geo_ftth_can
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_can TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_ftth_can TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_ftth_can TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.geo_ftth_can TO sig_edit;

ALTER MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_ouv
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.geo_vm_ftth_ouv TO sig_edit;

ALTER MATERIALIZED VIEW m_reseau_sec.geo_vm_ftth_can
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_can TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.geo_vm_ftth_can TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.geo_vm_ftth_can TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.geo_vm_ftth_can TO sig_edit;

ALTER SEQUENCE m_reseau_sec.idftth_seq
  OWNER TO sig_create;
GRANT ALL ON TABLE m_reseau_sec.idftth_seq TO sig_create;
GRANT SELECT ON TABLE m_reseau_sec.idftth_seq TO sig_read;
GRANT ALL ON TABLE m_reseau_sec.idftth_seq TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_reseau_sec.idftth_seq TO sig_edit;




