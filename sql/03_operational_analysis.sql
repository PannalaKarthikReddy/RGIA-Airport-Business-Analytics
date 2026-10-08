#Monthly Traffic Trend
SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt
FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#strongest and weakest months
SELECT
    'Highest Passenger Month' AS metric,
    report_month,
    total_passengers AS value
FROM rgia_monthly_operational_kpis
WHERE total_passengers = (
    SELECT MAX(total_passengers)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Passenger Month' AS metric,
    report_month,
    total_passengers AS value
FROM rgia_monthly_operational_kpis
WHERE total_passengers = (
    SELECT MIN(total_passengers)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Highest Movement Month' AS metric,
    report_month,
    total_movements AS value
FROM rgia_monthly_operational_kpis
WHERE total_movements = (
    SELECT MAX(total_movements)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Movement Month' AS metric,
    report_month,
    total_movements AS value
FROM rgia_monthly_operational_kpis
WHERE total_movements = (
    SELECT MIN(total_movements)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Highest Freight Month' AS metric,
    report_month,
    total_freight_mt AS value
FROM rgia_monthly_operational_kpis
WHERE total_freight_mt = (
    SELECT MAX(total_freight_mt)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Freight Month' AS metric,
    report_month,
    total_freight_mt AS value
FROM rgia_monthly_operational_kpis
WHERE total_freight_mt = (
    SELECT MIN(total_freight_mt)
    FROM rgia_monthly_operational_kpis
);

#Domestic vs International Traffic Mix
SELECT
    report_month,

    domestic_passenger_share_pct,
    international_passenger_share_pct,

    domestic_movement_share_pct,
    international_movement_share_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Passenger & Freight Efficiency
SELECT
    report_month,
    passengers_per_aircraft_movement,
    freight_per_aircraft_movement_mt
FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Month-over-Month Performance
SELECT
    report_month,
    passenger_mom_growth_pct,
    movement_mom_growth_pct,
    freight_mom_growth_pct
FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#International vs Domestic Volume
SELECT
    report_month,

    domestic_passengers,
    international_passengers,

    domestic_movements,
    international_movements,

    domestic_freight_mt,
    international_freight_mt

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#strongest/weakest months by efficiency
SELECT
    'Highest Passenger Throughput per Movement' AS metric,
    report_month,
    passengers_per_aircraft_movement AS value
FROM rgia_monthly_operational_kpis
WHERE passengers_per_aircraft_movement = (
    SELECT MAX(passengers_per_aircraft_movement)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Passenger Throughput per Movement',
    report_month,
    passengers_per_aircraft_movement
FROM rgia_monthly_operational_kpis
WHERE passengers_per_aircraft_movement = (
    SELECT MIN(passengers_per_aircraft_movement)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Highest Freight per Movement',
    report_month,
    freight_per_aircraft_movement_mt
FROM rgia_monthly_operational_kpis
WHERE freight_per_aircraft_movement_mt = (
    SELECT MAX(freight_per_aircraft_movement_mt)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Freight per Movement',
    report_month,
    freight_per_aircraft_movement_mt
FROM rgia_monthly_operational_kpis
WHERE freight_per_aircraft_movement_mt = (
    SELECT MIN(freight_per_aircraft_movement_mt)
    FROM rgia_monthly_operational_kpis
);

#Domestic vs International Growth
SELECT
    report_month,

    domestic_passengers,
    international_passengers,

    ROUND(
        (domestic_passengers -
         LAG(domestic_passengers) OVER (ORDER BY report_month))
        / NULLIF(
            LAG(domestic_passengers) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS domestic_passenger_mom_pct,

    ROUND(
        (international_passengers -
         LAG(international_passengers) OVER (ORDER BY report_month))
        / NULLIF(
            LAG(international_passengers) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS international_passenger_mom_pct,

    domestic_movements,
    international_movements,

    ROUND(
        (domestic_movements -
         LAG(domestic_movements) OVER (ORDER BY report_month))
        / NULLIF(
            LAG(domestic_movements) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS domestic_movement_mom_pct,

    ROUND(
        (international_movements -
         LAG(international_movements) OVER (ORDER BY report_month))
        / NULLIF(
            LAG(international_movements) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS international_movement_mom_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#passenger vs movement growth
SELECT
    report_month,
    passenger_mom_growth_pct,
    movement_mom_growth_pct,

    CASE
        WHEN passenger_mom_growth_pct > 0
             AND movement_mom_growth_pct > 0
            THEN 'Both Increased'

        WHEN passenger_mom_growth_pct < 0
             AND movement_mom_growth_pct < 0
            THEN 'Both Decreased'

        WHEN passenger_mom_growth_pct > 0
             AND movement_mom_growth_pct < 0
            THEN 'Passengers Increased, Movements Decreased'

        WHEN passenger_mom_growth_pct < 0
             AND movement_mom_growth_pct > 0
            THEN 'Passengers Decreased, Movements Increased'

        ELSE 'N/A'
    END AS traffic_pattern

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Freight Growth by Traffic Type
SELECT
    report_month,
    domestic_freight_mt,
    international_freight_mt,

    ROUND(
        (
            domestic_freight_mt -
            LAG(domestic_freight_mt) OVER (ORDER BY report_month)
        )
        / NULLIF(
            LAG(domestic_freight_mt) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS domestic_freight_mom_pct,

    ROUND(
        (
            international_freight_mt -
            LAG(international_freight_mt) OVER (ORDER BY report_month)
        )
        / NULLIF(
            LAG(international_freight_mt) OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS international_freight_mom_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

SELECT
    report_month,
    domestic_freight_mt,
    international_freight_mt,
    domestic_movements,
    international_movements,
    ROUND(
        domestic_freight_mt / NULLIF(domestic_movements, 0),
        4
    ) AS domestic_freight_per_movement_mt,
    ROUND(
        international_freight_mt / NULLIF(international_movements, 0),
        4
    ) AS international_freight_per_movement_mt
FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Overall Period Summary
SELECT
    MIN(report_month) AS period_start,
    MAX(report_month) AS period_end,

    SUM(total_passengers) AS total_passengers,
    SUM(total_movements) AS total_movements,
    SUM(total_freight_mt) AS total_freight_mt,

    ROUND(
        SUM(international_passengers)
        / NULLIF(SUM(total_passengers), 0) * 100,
        2
    ) AS international_passenger_share_pct,

    ROUND(
        SUM(international_movements)
        / NULLIF(SUM(total_movements), 0) * 100,
        2
    ) AS international_movement_share_pct,

    ROUND(
        SUM(international_freight_mt)
        / NULLIF(SUM(total_freight_mt), 0) * 100,
        2
    ) AS international_freight_share_pct

FROM rgia_monthly_operational_kpis;

#Monthly Contribution to the 8-Month Period
SELECT
    report_month,

    total_passengers,
    ROUND(
        total_passengers /
        SUM(total_passengers) OVER () * 100,
        2
    ) AS passenger_contribution_pct,

    total_movements,
    ROUND(
        total_movements /
        SUM(total_movements) OVER () * 100,
        2
    ) AS movement_contribution_pct,

    total_freight_mt,
    ROUND(
        total_freight_mt /
        SUM(total_freight_mt) OVER () * 100,
        2
    ) AS freight_contribution_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Data Quality
SELECT
    report_month,

    total_passengers,
    domestic_passengers + international_passengers AS calculated_passengers,
    ROUND(
        total_passengers -
        (domestic_passengers + international_passengers),
        2
    ) AS passenger_difference,

    total_movements,
    domestic_movements + international_movements AS calculated_movements,
    ROUND(
        total_movements -
        (domestic_movements + international_movements),
        2
    ) AS movement_difference,

    total_freight_mt,
    domestic_freight_mt + international_freight_mt AS calculated_freight,
    ROUND(
        total_freight_mt -
        (domestic_freight_mt + international_freight_mt),
        2
    ) AS freight_difference

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#percentage Validation
SELECT
    report_month,

    domestic_passenger_share_pct,
    international_passenger_share_pct,
    ROUND(
        domestic_passenger_share_pct +
        international_passenger_share_pct,
        4
    ) AS passenger_share_total,

    domestic_movement_share_pct,
    international_movement_share_pct,
    ROUND(
        domestic_movement_share_pct +
        international_movement_share_pct,
        4
    ) AS movement_share_total

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Overall KPI averages
-- STEP 16: Average Monthly Operating KPIs

SELECT
    ROUND(AVG(total_passengers), 2) AS avg_monthly_passengers,
    ROUND(AVG(total_movements), 2) AS avg_monthly_movements,
    ROUND(AVG(total_freight_mt), 2) AS avg_monthly_freight_mt,

    ROUND(AVG(passengers_per_aircraft_movement), 4)
        AS avg_passengers_per_movement,

    ROUND(AVG(freight_per_aircraft_movement_mt), 4)
        AS avg_freight_per_movement_mt,

    ROUND(AVG(international_passenger_share_pct), 2)
        AS avg_international_passenger_share_pct,

    ROUND(AVG(international_movement_share_pct), 2)
        AS avg_international_movement_share_pct

FROM rgia_monthly_operational_kpis;

-- STEP 17: Strongest and Weakest Months

SELECT
    'Highest Passenger Month' AS metric,
    report_month,
    total_passengers AS value
FROM rgia_monthly_operational_kpis
WHERE total_passengers = (
    SELECT MAX(total_passengers)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Passenger Month',
    report_month,
    total_passengers
FROM rgia_monthly_operational_kpis
WHERE total_passengers = (
    SELECT MIN(total_passengers)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Highest Movement Month',
    report_month,
    total_movements
FROM rgia_monthly_operational_kpis
WHERE total_movements = (
    SELECT MAX(total_movements)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Movement Month',
    report_month,
    total_movements
FROM rgia_monthly_operational_kpis
WHERE total_movements = (
    SELECT MIN(total_movements)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Highest Freight Month',
    report_month,
    total_freight_mt
FROM rgia_monthly_operational_kpis
WHERE total_freight_mt = (
    SELECT MAX(total_freight_mt)
    FROM rgia_monthly_operational_kpis
)

UNION ALL

SELECT
    'Lowest Freight Month',
    report_month,
    total_freight_mt
FROM rgia_monthly_operational_kpis
WHERE total_freight_mt = (
    SELECT MIN(total_freight_mt)
    FROM rgia_monthly_operational_kpis
);

#Cumulative Operational Performance
-- STEP 17: Cumulative Operational Performance

SELECT
    report_month,

    total_passengers,
    SUM(total_passengers) OVER (
        ORDER BY report_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_passengers,

    total_movements,
    SUM(total_movements) OVER (
        ORDER BY report_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_movements,

    total_freight_mt,
    ROUND(
        SUM(total_freight_mt) OVER (
            ORDER BY report_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_freight_mt

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Month-over-Month Change in Efficiency
SELECT
    report_month,

    passengers_per_aircraft_movement,
    ROUND(
        (
            passengers_per_aircraft_movement -
            LAG(passengers_per_aircraft_movement)
            OVER (ORDER BY report_month)
        )
        / NULLIF(
            LAG(passengers_per_aircraft_movement)
            OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS passenger_efficiency_mom_pct,

    freight_per_aircraft_movement_mt,
    ROUND(
        (
            freight_per_aircraft_movement_mt -
            LAG(freight_per_aircraft_movement_mt)
            OVER (ORDER BY report_month)
        )
        / NULLIF(
            LAG(freight_per_aircraft_movement_mt)
            OVER (ORDER BY report_month), 0
        ) * 100,
        2
    ) AS freight_efficiency_mom_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Efficiency Improvement / Decline Classification
SELECT
    report_month,

    passenger_efficiency_mom_pct,
    freight_efficiency_mom_pct,

    CASE
        WHEN passenger_efficiency_mom_pct IS NULL
            THEN 'N/A'

        WHEN passenger_efficiency_mom_pct > 0
             AND freight_efficiency_mom_pct > 0
            THEN 'Both Improved'

        WHEN passenger_efficiency_mom_pct < 0
             AND freight_efficiency_mom_pct < 0
            THEN 'Both Declined'

        WHEN passenger_efficiency_mom_pct > 0
             AND freight_efficiency_mom_pct < 0
            THEN 'Passenger Improved, Freight Declined'

        WHEN passenger_efficiency_mom_pct < 0
             AND freight_efficiency_mom_pct > 0
            THEN 'Passenger Declined, Freight Improved'

        ELSE 'No Change'
    END AS efficiency_direction

FROM (
    SELECT
        report_month,

        ROUND(
            (
                passengers_per_aircraft_movement -
                LAG(passengers_per_aircraft_movement)
                OVER (ORDER BY report_month)
            )
            / NULLIF(
                LAG(passengers_per_aircraft_movement)
                OVER (ORDER BY report_month), 0
            ) * 100,
            2
        ) AS passenger_efficiency_mom_pct,

        ROUND(
            (
                freight_per_aircraft_movement_mt -
                LAG(freight_per_aircraft_movement_mt)
                OVER (ORDER BY report_month)
            )
            / NULLIF(
                LAG(freight_per_aircraft_movement_mt)
                OVER (ORDER BY report_month), 0
            ) * 100,
            2
        ) AS freight_efficiency_mom_pct

    FROM rgia_monthly_operational_kpis
) AS efficiency_changes

ORDER BY report_month;

#Average Domestic vs International Performance
SELECT
    ROUND(AVG(domestic_passengers), 2) AS avg_domestic_passengers,
    ROUND(AVG(international_passengers), 2) AS avg_international_passengers,

    ROUND(AVG(domestic_movements), 2) AS avg_domestic_movements,
    ROUND(AVG(international_movements), 2) AS avg_international_movements,

    ROUND(AVG(domestic_freight_mt), 2) AS avg_domestic_freight_mt,
    ROUND(AVG(international_freight_mt), 2) AS avg_international_freight_mt

FROM rgia_monthly_operational_kpis;

#International Freight vs Passenger Mix Gap
SELECT
    report_month,

    ROUND(international_passenger_share_pct, 2)
        AS international_passenger_share_pct,

    ROUND(
        international_freight_mt /
        total_freight_mt * 100,
        2
    ) AS international_freight_share_pct,

    ROUND(
        (international_freight_mt / total_freight_mt * 100)
        - international_passenger_share_pct,
        2
    ) AS freight_vs_passenger_mix_gap_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Freight Intensity: Domestic vs International
SELECT
    report_month,

    ROUND(
        domestic_freight_mt /
        NULLIF(domestic_movements, 0),
        4
    ) AS domestic_freight_per_movement_mt,

    ROUND(
        international_freight_mt /
        NULLIF(international_movements, 0),
        4
    ) AS international_freight_per_movement_mt,

    ROUND(
        (
            international_freight_mt /
            NULLIF(international_movements, 0)
        )
        -
        (
            domestic_freight_mt /
            NULLIF(domestic_movements, 0)
        ),
        4
    ) AS international_minus_domestic_mt

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#International Freight Intensity Multiple
SELECT
    report_month,

    ROUND(
        domestic_freight_mt /
        NULLIF(domestic_movements, 0),
        4
    ) AS domestic_freight_per_movement_mt,

    ROUND(
        international_freight_mt /
        NULLIF(international_movements, 0),
        4
    ) AS international_freight_per_movement_mt,

    ROUND(
        (
            international_freight_mt /
            NULLIF(international_movements, 0)
        )
        /
        NULLIF(
            domestic_freight_mt /
            NULLIF(domestic_movements, 0),
            0
        ),
        2
    ) AS international_intensity_multiple

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Final Operational KPI Summary
SELECT
    COUNT(*) AS months_analyzed,

    MIN(report_month) AS first_month,
    MAX(report_month) AS last_month,

    SUM(total_passengers) AS total_passengers,
    SUM(total_movements) AS total_movements,
    ROUND(SUM(total_freight_mt), 2) AS total_freight_mt,

    ROUND(AVG(total_passengers), 2) AS avg_monthly_passengers,
    ROUND(AVG(total_movements), 2) AS avg_monthly_movements,
    ROUND(AVG(total_freight_mt), 2) AS avg_monthly_freight_mt,

    ROUND(AVG(passengers_per_aircraft_movement), 4)
        AS avg_passengers_per_movement,

    ROUND(AVG(freight_per_aircraft_movement_mt), 4)
        AS avg_freight_per_movement_mt,

    ROUND(AVG(international_passenger_share_pct), 2)
        AS avg_international_passenger_share_pct,

    ROUND(AVG(international_movement_share_pct), 2)
        AS avg_international_movement_share_pct

FROM rgia_monthly_operational_kpis;

#Data Quality Check
-- STEP 25: Final Data Quality Check

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT report_month) AS distinct_months,
    SUM(report_month IS NULL) AS null_report_month,
    SUM(total_passengers IS NULL) AS null_total_passengers,
    SUM(total_movements IS NULL) AS null_total_movements,
    SUM(total_freight_mt IS NULL) AS null_total_freight,
    SUM(total_passengers < 0) AS negative_passengers,
    SUM(total_movements < 0) AS negative_movements,
    SUM(total_freight_mt < 0) AS negative_freight
FROM rgia_monthly_operational_kpis;
