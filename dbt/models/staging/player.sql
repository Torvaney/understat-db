{{
    config(materialized='table')
}}

with


shots_json as (

  -- Home shots
  select
    match_id,
    json_array_elements(json -> 'h') as json
  from base_shots

  union all

  -- Away shots
  select
    match_id,
    json_array_elements(json -> 'a') as json
  from base_shots

),


base_players as (

  select
    (json ->> 'player_id')::int as id,
    (json ->> 'player') as name
  from shots_json

),


players as (

  select distinct on (id)
    id,
    name
  from base_players

)

select * from players order by id
