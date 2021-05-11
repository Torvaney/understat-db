{{
    config(materialized='table')
}}

with


matches as (

  select * from {{ ref('match') }}

),


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


base_shots as (

  select
    (json ->> 'id')::int           as id,
    match_id                       as match_id,
    (json ->> 'minute')::int       as minute,
    (json ->> 'X')::float          as x,
    (json ->> 'Y')::float          as y,
    (json ->> 'xG')::float         as xg,
    (json ->> 'shotType')          as type,
    (json ->> 'result')            as result,
    (json ->> 'situation')         as situation,
    (json ->> 'lastAction')        as previous_action,
    (json ->> 'player_id')::int    as player_id,
    (json ->> 'h_a') = 'h'         as is_home
  from shots_json

),


-- Join back to the matches table to get the shooting team ID
shots as (

  select
    base_shots.*,
    case
      when is_home then home_team_id
      when not is_home then away_team_id
    end as team_id,
    case
      when is_home then away_team_id
      when not is_home then home_team_id
    end as opponent_id
  from base_shots
  left join matches
    on matches.id = base_shots.match_id

)

select * from shots order by id
