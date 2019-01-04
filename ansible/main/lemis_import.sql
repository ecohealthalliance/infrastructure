CREATE TABLE lemisdb 
(
  species_code varchar, control_number varchar, genus varchar, species varchar,
  subspecies varchar, specific_name varchar, generic_name varchar, wildlife_description varchar,
  quantity varchar, unit varchar, value varchar, country_origin_iso2c varchar,
  country_imp_exp_iso2c varchar, purpose varchar, source_ varchar, action varchar,
  disposition varchar, disposition_date varchar, shipment_date date, import_export varchar,
  port varchar, us_co varchar, foreign_co varchar, binomial varchar, shipment_year varchar,
  country_origin varchar, continent_origin varchar, region_origin varchar,
  quantity_bkp varchar, unit_bkp varchar, taxa varchar, Wild integer, Live integer, NonAq integer
);
\copy lemisdb FROM '/shared/lemis_2000_2013_cleaned.utf8.csv' WITH (FORMAT csv, NULL 'NA', HEADER true)

ALTER TABLE lemisdb
    ADD COLUMN parsed_value NUMERIC,
    ADD COLUMN parsed_quantity NUMERIC;
UPDATE
    lemisdb 
SET
    parsed_value=CAST(NULLIF(regexp_replace(value, ',|\$|NA|value', '', 'gi'), '') AS NUMERIC),
    parsed_quantity=CAST(NULLIF(quantity, '') AS NUMERIC);
