


--      @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/International/sql/ddlgen/multisite_i18n_ddl.xml#3 $$Change: 804933 $  

create table crs_i18n_site_attr (
	asset_version	numeric(19)	not null,
	id	varchar(40)	not null,
	default_lang	varchar(2)	default null
,constraint crs_i18nsite_pattr primary key (id,asset_version));

commit;


