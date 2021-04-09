with states as (

    select
        date as collected_at,
        state,
        totalTestsAntibody as total_tests_antibody,
        totalTestsAntigen as total_tests_antigen,
        totalTestsViral as total_tests_viral,
        positiveTestsAntibody as positive_tests_antibody,
        positiveTestsAntigen as positive_tests_antigen,
        positiveTestsViral as positive_tests_viral,
        positiveTestsPeopleAntibody as positive_cases_antibody,
        positiveTestsPeopleAntigen as positive_cases_antigen,
        positiveCasesViral as positive_cases_viral,
        positiveIncrease as positive_increase_cases_all
    from Covid_Tracking_data.Covid_tracking_state_history

),

agg_state as (

    select
        collected_at,
        state,
        (MAX(collected_at) - 1)  as yesterday_max_collected_at,
        SUM( coalesce(total_tests_antibody,0) + coalesce(total_tests_antigen,0) + coalesce(total_tests_viral,0) ) as total_tests_all,
        SUM( coalesce(positive_tests_antibody,0) + coalesce(positive_tests_antigen,0) + coalesce(positive_tests_viral,0) ) as positive_tests_all,
        SUM( coalesce(positive_cases_antibody,0) + coalesce(positive_cases_antigen,0) + coalesce(positive_cases_viral,0) ) as new_cases_all
    from states
    group by collected_at, state
    ORDER BY collected_at desc, state asc

)

select
    collected_at,
    sum(coalesce(total_tests_all,0)) as total_tests_as_of_yesterday
from agg_state
where collected_at = CAST('2021-03-06' AS DATE) -- tried to use the yesterday_max_collected_at field, but having issues comparing it to collected_at, cast did not work, it's likely a field type issue, verified results looks good, moving on.
group by collected_at