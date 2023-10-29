{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_public",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('covid_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('date'),
        'new_recovered',
        'new_tested',
        'total_deceased',
        'new_deceased',
        'new_confirmed',
        'total_confirmed',
        'total_tested',
        'total_recovered',
        adapter.quote('key'),
    ]) }} as _airbyte_covid_hashid,
    tmp.*
from {{ ref('covid_ab2') }} tmp
-- covid
where 1 = 1

