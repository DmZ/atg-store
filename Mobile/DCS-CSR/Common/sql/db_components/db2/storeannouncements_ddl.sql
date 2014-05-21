


--  @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/Mobile/DCS-CSR/Common/sql/ddlgen/storeannouncements_ddl.xml#4 $$Change: 846657 $

create table crs_store_ancmnt (
	id	varchar(40)	not null,
	title	varchar(254)	default null,
	content	varchar(4000)	default null,
	creation_time	timestamp	default null,
	enabled	numeric(1)	not null
,constraint crs_ancmnt_key_p primary key (id));


create table crs_store_ancmnt_sts (
	store_id	varchar(40)	default null,
	announcement_id	varchar(40)	not null
,constraint crs_ancmnt_s_key_p primary key (announcement_id,store_id)
,constraint csr_store_ancmnt_f foreign key (announcement_id) references crs_store_ancmnt (id));

create index csr_store_ancmnt_x on crs_store_ancmnt_sts (announcement_id);
commit;


