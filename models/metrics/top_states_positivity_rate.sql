with states as (

    select *
    from {{ ref('stg_covid_data' ) }}
),

last30days_tests as (

    select
        state,
        sum(case 
            when collected_at > last30days_collected_at 
            then coalesce(positive_cases_increase,0)
        end) as last30days_positive_tests,
        sum(case 
            when collected_at > last30days_collected_at 
            then coalesce(total_tests_increase,0)
        end) as last30days_total_tests,
    from states 
    group by 1

), test_rate as (

    select 
        state,
        round(case 
            when last30days_total_tests = 0 
            then null
            else 100.0*(last30days_positive_tests/last30days_total_tests) 
        end,2) as positivity_rate
    from last30days_tests

), final as (

select
    state,
    rank() over(order by positivity_rate desc) as state_rate_rank,
    positivity_rate
from test_rate
where positivity_rate is not null and positivity_rate between 0 and 99      -- filtered out dirty data states PR, MP, WY and AS, have to look into it
order by positivity_rate desc

)

select * from final limit 10
