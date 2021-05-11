{% macro test_between_0_and_1(model, column_name) %}

with validation as (

    select
        {{ column_name }} as percent_field
    from {{ model }}

),

validation_errors as (

    select
        even_field
    from validation
    where percent_field < 0
       or percent_field > 1

)

select count(*)
from validation_errors

{% endmacro %}
