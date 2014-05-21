


--  @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/Common/International/sql/ddlgen/storeannouncements_i18n_ddl.xml#1 $$Change: 847017 $

create table crs_ancmnt_cntnt_xlate (
	asset_version	numeric(19)	not null,
	workspace_id	varchar(40)	not null,
	branch_id	varchar(40)	not null,
	is_head	tinyint	not null,
	version_deleted	numeric(1)	not null,
	version_editable	numeric(1)	not null,
	pred_version	numeric(19)	null,
	checkin_date	datetime	null,
	translation_id	varchar(40)	not null,
	title	varchar(254)	null,
	content	longtext	null
,constraint crs_ancmnt_xkey_p primary key (translation_id,asset_version));

create index crs_ancmnt_cnt_wsx on crs_ancmnt_cntnt_xlate (workspace_id);
create index crs_ancmnt_cnt_cix on crs_ancmnt_cntnt_xlate (checkin_date);

create table crs_ancmnt_xlate (
	asset_version	numeric(19)	not null,
	announcement_id	varchar(40)	not null,
	locale	varchar(40)	not null,
	translation_id	varchar(254)	not null
,constraint crs_ancmnt_xlt_p primary key (announcement_id,locale,asset_version));

create index crs_ancmnt_xlt_tr_id on crs_ancmnt_xlate (translation_id);
commit;


