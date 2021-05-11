{% macro test_not_negative(model, column_name) %}

with validation as (

    select
        {{ column_name }} as not_negative_field
    from {{ model }}

),

validation_errors as (

    select
        not_negative_field
    from validation
    where (not_negative_field < 0)
       -- allow null values since this test can be combined with
       -- a not_null test
       and (not_negative_field is not null)

)

select count(*)
from validation_errors

{% endmacro %}
