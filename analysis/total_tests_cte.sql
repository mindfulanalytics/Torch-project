with states as (

     select
        date as collected_at,
        state,
        max(date) over() as max_collected_at,
        max(date) over() -1 as yesterday_max_collected_at,
        positive as positive_cases,
        positiveIncrease as positive_cases_increase,
        totalTestResults as total_tests,
        totalTestResultsIncrease as total_tests_increase,
        totalTestsAntibody as total_tests_antibody,
        totalTestsAntigen as total_tests_antigen,
        totalTestsViral as total_tests_viral,
    from Covid_Tracking_data.Covid_tracking_state_history

),

agg_state as (

    select
        collected_at,
        state,
        SUM( coalesce(total_tests_antibody,0) + coalesce(total_tests_antigen,0) + coalesce(total_tests_viral,0) ) as total_tests_all,
    from states
    group by collected_at, state
    ORDER BY collected_at desc, state asc

), final as (
select
    states.collected_at,
    sum(states.total_tests) as total_tests_as_of_yesterday_us,
    sum(coalesce(total_tests_all,0)) as total_tests_as_of_yesterday_us_ -- discrepancies due to states having different reporting methods, highlighting for context
from states
left join agg_state using(collected_at,state)
where collected_at = yesterday_max_collected_at
group by collected_at

)

select collected_at, total_tests_as_of_yesterday_us from final

