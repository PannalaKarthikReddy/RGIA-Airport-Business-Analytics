
SELECT COUNT(*) AS total_rows
FROM rgia_monthly_operational_kpis;

INSERT INTO rgia_monthly_operational_kpis (
    report_month,
    total_passengers,
    domestic_passengers,
    international_passengers,
    total_movements,
    domestic_movements,
    international_movements,
    total_freight_mt,
    domestic_freight_mt,
    international_freight_mt,
    passengers_per_aircraft_movement,
    freight_per_aircraft_movement_mt,
    domestic_passenger_share_pct,
    international_passenger_share_pct,
    domestic_movement_share_pct,
    international_movement_share_pct,
    passenger_mom_growth_pct,
    movement_mom_growth_pct,
    freight_mom_growth_pct
)
VALUES
('2026-01-01',2652779,2129340,523439,16894,13999,2895,14908.4,9311.5,5596.8,157.0249,0.8825,80.2683,19.7317,82.8637,17.1363,NULL,NULL,NULL),

('2026-02-01',2317113,1878622,429491,14901,12324,2577,15447.9,9457.0,5990.9,155.5005,1.0367,81.4596,18.5404,82.7327,17.2673,-12.6534,-11.7971,3.6188),

('2026-03-01',2288274,1972261,316013,15907,13955,1952,15840.1,10247.2,5592.9,143.8533,0.9958,86.2003,13.7997,87.7161,12.2839,-1.2446,6.7512,2.5389),

('2026-04-01',2249965,1909103,340862,15829,13821,2008,16160.6,10507.0,5653.6,142.1420,1.0209,84.8488,15.1512,87.3018,12.6982,-1.6741,-0.4904,2.0233),

('2026-05-01',2549700,2135192,414508,17306,14915,2391,16549.3,10902.0,5647.3,147.3304,0.9563,83.7487,16.2513,86.1840,13.8160,13.3218,9.3310,2.4052),

('2026-06-01',2287844,1858417,429427,15356,12736,2620,17970.2,11421.8,6548.4,148.9870,1.1702,81.1978,18.8022,82.9187,17.0813,-10.2701,-11.2678,8.5859),

('2026-07-01',2223504,1743877,479627,14364,11613,2751,18070.8,11644.7,6426.1,154.7970,1.2581,78.4148,21.5852,80.8549,19.1451,-2.8123,-6.4600,0.5598),

('2026-08-01',2185934,1733770,452164,14812,12082,2730,17489.1,5848.5,11640.6,147.5786,1.1807,79.3148,20.6852,81.5690,18.4310,-1.6897,3.1189,-3.2190);

SELECT COUNT(*) AS total_rows
FROM rgia_monthly_operational_kpis;

SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt
FROM rgia_monthly_operational_kpis
ORDER BY report_month;

SELECT
    report_month,
    COUNT(*) AS row_count
FROM rgia_monthly_operational_kpis
GROUP BY report_month
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_rows,
    MIN(report_month) AS first_month,
    MAX(report_month) AS last_month
FROM rgia_monthly_operational_kpis;

SELECT
    SUM(report_month IS NULL) AS null_report_month,
    SUM(total_passengers IS NULL) AS null_total_passengers,
    SUM(domestic_passengers IS NULL) AS null_domestic_passengers,
    SUM(international_passengers IS NULL) AS null_international_passengers,
    SUM(total_movements IS NULL) AS null_total_movements,
    SUM(domestic_movements IS NULL) AS null_domestic_movements,
    SUM(international_movements IS NULL) AS null_international_movements,
    SUM(total_freight_mt IS NULL) AS null_total_freight,
    SUM(domestic_freight_mt IS NULL) AS null_domestic_freight,
    SUM(international_freight_mt IS NULL) AS null_international_freight,
    SUM(passengers_per_aircraft_movement IS NULL) AS null_pax_per_movement,
    SUM(freight_per_aircraft_movement_mt IS NULL) AS null_freight_per_movement,
    SUM(domestic_passenger_share_pct IS NULL) AS null_domestic_pax_share,
    SUM(international_passenger_share_pct IS NULL) AS null_international_pax_share,
    SUM(domestic_movement_share_pct IS NULL) AS null_domestic_movement_share,
    SUM(international_movement_share_pct IS NULL) AS null_international_movement_share,
    SUM(passenger_mom_growth_pct IS NULL) AS null_passenger_mom,
    SUM(movement_mom_growth_pct IS NULL) AS null_movement_mom,
    SUM(freight_mom_growth_pct IS NULL) AS null_freight_mom
FROM rgia_monthly_operational_kpis;

USE rgia_airport_analytics;

SELECT
    report_month,
    total_passengers,
    domestic_passengers + international_passengers AS calculated_total,
    total_passengers - (
        domestic_passengers + international_passengers
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    total_passengers - (
        domestic_passengers + international_passengers
    )
) > 0.01;

#Identify Febraruary Values
SELECT
    report_month,
    total_passengers,
    domestic_passengers,
    international_passengers,
    domestic_passengers + international_passengers AS calculated_total,
    total_passengers - (
        domestic_passengers + international_passengers
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE report_month = '2026-02-01';

UPDATE rgia_monthly_operational_kpis
SET domestic_passengers = 1887622
WHERE report_month = '2026-02-01';

SELECT
    report_month,
    total_passengers,
    domestic_passengers + international_passengers AS calculated_total,
    total_passengers - (
        domestic_passengers + international_passengers
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    total_passengers - (
        domestic_passengers + international_passengers
    )
) > 0.01;

SELECT
    report_month,
    total_movements,
    domestic_movements + international_movements AS calculated_total,
    total_movements - (
        domestic_movements + international_movements
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    total_movements - (
        domestic_movements + international_movements
    )
) > 0.01;

SELECT
    report_month,
    total_freight_mt,
    domestic_freight_mt + international_freight_mt AS calculated_total,
    total_freight_mt - (
        domestic_freight_mt + international_freight_mt
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    total_freight_mt - (
        domestic_freight_mt + international_freight_mt
    )
) > 0.10;

SELECT
    report_month,
    domestic_passenger_share_pct,
    international_passenger_share_pct,
    domestic_passenger_share_pct
        + international_passenger_share_pct AS total_share
FROM rgia_monthly_operational_kpis
WHERE ABS(
    (
        domestic_passenger_share_pct
        + international_passenger_share_pct
    ) - 100
) > 0.01;

SELECT
    report_month,
    domestic_movement_share_pct,
    international_movement_share_pct,
    domestic_movement_share_pct
        + international_movement_share_pct AS total_share
FROM rgia_monthly_operational_kpis
WHERE ABS(
    (
        domestic_movement_share_pct
        + international_movement_share_pct
    ) - 100
) > 0.01;

SELECT
    report_month,
    passengers_per_aircraft_movement AS stored_value,
    ROUND(
        total_passengers / NULLIF(total_movements, 0),
        4
    ) AS calculated_value,
    ROUND(
        passengers_per_aircraft_movement -
        (total_passengers / NULLIF(total_movements, 0)),
        4
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    passengers_per_aircraft_movement -
    (total_passengers / NULLIF(total_movements, 0))
) > 0.01;

SELECT
    report_month,
    freight_per_aircraft_movement_mt AS stored_value,
    ROUND(
        total_freight_mt / NULLIF(total_movements, 0),
        4
    ) AS calculated_value,
    ROUND(
        freight_per_aircraft_movement_mt -
        (total_freight_mt / NULLIF(total_movements, 0)),
        4
    ) AS difference
FROM rgia_monthly_operational_kpis
WHERE ABS(
    freight_per_aircraft_movement_mt -
    (total_freight_mt / NULLIF(total_movements, 0))
) > 0.01;

DESCRIBE rgia_monthly_operational_kpis;

WITH calculated_growth AS (
    SELECT
        report_month,
        total_passengers,
        total_movements,
        total_freight_mt,

        passenger_mom_growth_pct,
        movement_mom_growth_pct,
        freight_mom_growth_pct,

        LAG(total_passengers) OVER (
            ORDER BY report_month
        ) AS previous_passengers,

        LAG(total_movements) OVER (
            ORDER BY report_month
        ) AS previous_movements,

        LAG(total_freight_mt) OVER (
            ORDER BY report_month
        ) AS previous_freight

    FROM rgia_monthly_operational_kpis
)

SELECT
    report_month,

    passenger_mom_growth_pct,
    ROUND(
        (
            (total_passengers - previous_passengers)
            / previous_passengers
        ) * 100,
        4
    ) AS calculated_passenger_mom,

    movement_mom_growth_pct,
    ROUND(
        (
            (total_movements - previous_movements)
            / previous_movements
        ) * 100,
        4
    ) AS calculated_movement_mom,

    freight_mom_growth_pct,
    ROUND(
        (
            (total_freight_mt - previous_freight)
            / previous_freight
        ) * 100,
        4
    ) AS calculated_freight_mom

FROM calculated_growth
WHERE previous_passengers IS NOT NULL;

SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt,
    passengers_per_aircraft_movement,
    freight_per_aircraft_movement_mt
FROM rgia_monthly_operational_kpis
WHERE
    total_passengers < 0
    OR total_movements < 0
    OR total_freight_mt < 0
    OR passengers_per_aircraft_movement < 0
    OR freight_per_aircraft_movement_mt < 0;
    
    SELECT
    report_month,
    domestic_passenger_share_pct,
    international_passenger_share_pct,
    domestic_movement_share_pct,
    international_movement_share_pct
FROM rgia_monthly_operational_kpis
WHERE
    domestic_passenger_share_pct < 0
    OR domestic_passenger_share_pct > 100
    OR international_passenger_share_pct < 0
    OR international_passenger_share_pct > 100
    OR domestic_movement_share_pct < 0
    OR domestic_movement_share_pct > 100
    OR international_movement_share_pct < 0
    OR international_movement_share_pct > 100;
    
    SELECT
    report_month,

    total_passengers,
    (domestic_passengers + international_passengers) AS calculated_passengers,
    total_passengers -
        (domestic_passengers + international_passengers) AS passenger_difference,

    total_movements,
    (domestic_movements + international_movements) AS calculated_movements,
    total_movements -
        (domestic_movements + international_movements) AS movement_difference,

    total_freight_mt,
    (domestic_freight_mt + international_freight_mt) AS calculated_freight,
    total_freight_mt -
        (domestic_freight_mt + international_freight_mt) AS freight_difference

FROM rgia_monthly_operational_kpis
WHERE
    ABS(
        total_passengers -
        (domestic_passengers + international_passengers)
    ) > 0.01

    OR ABS(
        total_movements -
        (domestic_movements + international_movements)
    ) > 0.01

    OR ABS(
        total_freight_mt -
        (domestic_freight_mt + international_freight_mt)
    ) > 0.11;