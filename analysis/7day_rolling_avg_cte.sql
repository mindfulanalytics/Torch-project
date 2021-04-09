with states as (

select
        date as collected_at,
        state,
        positive as positive_cases,
        positiveIncrease as positive_cases_increase,
        totalTestResults as total_tests,
        totalTestResultsIncrease as total_tests_increase,
        totalTestsAntibody as total_tests_antibody,
        totalTestsAntigen as total_tests_antigen,
        totalTestsViral as total_tests_viral,
        positiveTestsAntibody as positive_tests_antibody,
        positiveTestsAntigen as positive_tests_antigen,
        positiveTestsViral as positive_tests_viral,
        positiveTestsPeopleAntibody as positive_cases_antibody,
        positiveTestsPeopleAntigen as positive_cases_antigen,
        positiveCasesViral as positive_cases_viral,
    from Covid_Tracking_data.Covid_tracking_state_history

),

agg_new_cases as (

    select
        collected_at,
        sum(positive_increase_cases_all) as us_new_cases_all,
        max(collected_at) as max_collected_at
    from states
    group by collected_at

)

select collected_at,
      round(avg(us_new_cases_all) over(
          order by collected_at
          rows between 6 preceding and current row), 2)
          as seven_day_moving_average
from agg_new_cases
where collected_at > '2021-02-01' -- need to figure out a way to use max_collected_at, if this was a connected data source I would use getdate()
order by collected_at desc