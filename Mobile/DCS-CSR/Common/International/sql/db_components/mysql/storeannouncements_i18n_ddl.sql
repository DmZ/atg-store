


--  @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/Common/International/sql/ddlgen/storeannouncements_i18n_ddl.xml#1 $$Change: 847017 $

create table crs_ancmnt_cntnt_xlate (
	translation_id	varchar(40)	not null,
	title	varchar(254)	null,
	content	longtext	null
,constraint crs_ancmnt_xkey_p primary key (translation_id));


create table crs_ancmnt_xlate (
	announcement_id	varchar(40)	not null,
	locale	varchar(40)	not null,
	translation_id	varchar(254)	not null
,constraint crs_ancmnt_xlt_p primary key (announcement_id,locale)
,constraint crs_ancmnt_xlate_f foreign key (translation_id) references crs_ancmnt_cntnt_xlate (translation_id));

create index crs_ancmnt_xlt_tr_id on crs_ancmnt_xlate (translation_id);
commit;


