{% macro test_between_0_and_1(model, column_name) %}

with validation as (

    select
        {{ column_name }} as percent_field
    from {{ model }}

),

validation_errors as (

    select
        percent_field
    from validation
    where (percent_field < 0 or percent_field > 1)
       -- allow null values since this test can be combined with
       -- a not_null test
       and (percent_field is not null)

)

select count(*)
from validation_errors

{% endmacro %}
