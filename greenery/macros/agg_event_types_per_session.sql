{% macro agg_event_types_per_session(session_id, event_type) %}

select {{session_id}}, count{{(event_type)}}
from {{ ref('stg_postgres__events')}}
group by {{session_id}}

{% endmacro %}