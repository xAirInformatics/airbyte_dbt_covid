{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "public",
    post_hook = ["
                    {%
                        set scd_table_relation = adapter.get_relation(
                            database=this.database,
                            schema=this.schema,
                            identifier='covid_scd'
                        )
                    %}
                    {%
                        if scd_table_relation is not none
                    %}
                    {%
                            do adapter.drop_relation(scd_table_relation)
                    %}
                    {% endif %}
                        "],
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('covid_ab3') }}
select
    {{ adapter.quote('date') }},
    new_recovered as zizo,
    new_tested,
    total_deceased,
    new_deceased,
    new_confirmed,
    total_confirmed,
    total_tested,
    total_recovered,
    {{ adapter.quote('key') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_covid_hashid
from {{ ref('covid_ab3') }}
-- covid from {{ source('public', '_airbyte_raw_covid') }}
where 1 = 1

