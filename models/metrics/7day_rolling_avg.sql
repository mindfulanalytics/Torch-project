with states as (

    select *
    from {{ ref('stg_covid_data' ) }}
),

agg_new_cases as (

    select
        collected_at,
        sum(positive_cases_increase) as us_new_cases,
    from states
    group by collected_at

), final as (

select collected_at,
      round(avg(us_new_cases) over(
          order by collected_at
          rows between 6 preceding and current row), 2)
          as seven_day_rolling_average
from agg_new_cases
order by collected_at desc

)

select * from final limit 30



