with states as (

    select *
    from {{ ref('stg_covid_data' ) }}
),

final as (

    select
        states.collected_at,
        sum(states.total_tests) as total_tests_as_of_yesterday_us,
    from states
    where collected_at = max_collected_at
    group by collected_at

)

select collected_at, total_tests_as_of_yesterday_us from final