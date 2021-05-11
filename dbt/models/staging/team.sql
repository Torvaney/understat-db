{{
    config(materialized='table')
}}

with

unnested as (

  select
    league_id,
    season_id,
    json_array_elements(json) as json
  from base_matches

),


home_teams as (

  select
    (json -> 'h' ->> 'id')::int      as id,
    (json -> 'h' ->> 'title')        as title,
    (json -> 'h' ->> 'short_title')  as short_title
  from unnested

),


away_teams as (

  select
    (json -> 'a' ->> 'id')::int      as id,
    (json -> 'a' ->> 'title')        as title,
    (json -> 'a' ->> 'short_title')  as short_title
  from unnested

),


home_and_away_teams as (

  select * from home_teams
  union all
  select * from away_teams

),


teams as (

  select distinct on (id)
    *
  from home_and_away_teams
  order by id

)


select * from teams
