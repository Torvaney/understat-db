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

match as (

  select
    league_id,
    season_id,
    (json ->> 'id')::int                 as id,
    (json ->> 'datetime')::timestamp     as kickoff,
    (json ->> 'isResult')::bool          as is_result,
    (json -> 'h' ->> 'id')::int          as home_team_id,
    (json -> 'a' ->> 'id')::int          as away_team_id,
    (json -> 'goals' ->> 'h')::int       as home_goals,
    (json -> 'goals' ->> 'a')::int       as away_goals,
    (json -> 'xG' ->> 'h')::float        as home_xg,
    (json -> 'xG' ->> 'a')::float        as away_xg,
    (json -> 'forecast' ->> 'w')::float  as forecast_h,
    (json -> 'forecast' ->> 'd')::float  as forecast_d,
    (json -> 'forecast' ->> 'l')::float  as forecast_a
  from unnested

)

select * from match
