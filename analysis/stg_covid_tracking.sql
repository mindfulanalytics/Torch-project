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

agg_states as (
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
    states.collected_at,
    states.state,
    positive_cases,
    positive_cases_increase,
    total_tests,
    total_tests_increase,
    total_tests_all,
    positive_tests_all,
    new_cases_all
from states
left join agg_states using (collected_at,state)