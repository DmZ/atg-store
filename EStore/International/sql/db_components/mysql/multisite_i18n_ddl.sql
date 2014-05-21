


--  @version $Id: //hosting-blueprint/B2CBlueprint/version/10.2.1/EStore/International/sql/ddlgen/multisite_i18n_ddl.xml#3 $$Change: 804933 $

create table crs_i18n_site_attr (
	id	varchar(40)	not null,
	default_lang	varchar(2)	null
,constraint crs_i18nsite_pattr primary key (id)
,constraint crs_i18nsite_fattr foreign key (id) references site_configuration (id));

commit;


