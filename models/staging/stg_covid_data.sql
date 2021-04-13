with states as (

    select
        date as collected_at,
        state,
        max(date) over() as max_collected_at,
        max(date) over () - 30 as last30days_collected_at,
        positive as positive_cases,
        positiveIncrease as positive_cases_increase,
        totalTestResults as total_tests,
        totalTestResultsIncrease as total_tests_increase,
    from Covid_Tracking_data.Covid_tracking_state_history

)

select * from states