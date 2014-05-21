


--  @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/Common/sql/ddlgen/storeannouncements_ddl.xml#4 $$Change: 846657 $

create table crs_store_ancmnt (
	asset_version	numeric(19)	not null,
	workspace_id	varchar(40)	not null,
	branch_id	varchar(40)	not null,
	is_head	tinyint	not null,
	version_deleted	numeric(1)	not null,
	version_editable	numeric(1)	not null,
	pred_version	numeric(19)	null,
	checkin_date	datetime	null,
	id	varchar(40)	not null,
	title	varchar(254)	null,
	content	text	null,
	creation_time	datetime	null,
	enabled	tinyint	not null
,constraint crs_ancmnt_key_p primary key (id,asset_version))

create index crs_store_ancm_wsx on crs_store_ancmnt (workspace_id)
create index crs_store_ancm_cix on crs_store_ancmnt (checkin_date)

create table crs_store_ancmnt_sts (
	asset_version	numeric(19)	not null,
	store_id	varchar(40)	null,
	announcement_id	varchar(40)	not null
,constraint crs_ancmnt_s_key_p primary key (announcement_id,store_id,asset_version))



go
