#Monthly Operational Ranking
SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt,

    RANK() OVER (
        ORDER BY total_passengers DESC
    ) AS passenger_rank,

    RANK() OVER (
        ORDER BY total_movements DESC
    ) AS movement_rank,

    RANK() OVER (
        ORDER BY total_freight_mt DESC
    ) AS freight_rank

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#3-Month Rolling Performance
SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt,

    ROUND(
        AVG(total_passengers) OVER (
            ORDER BY report_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS passengers_3m_avg,

    ROUND(
        AVG(total_movements) OVER (
            ORDER BY report_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS movements_3m_avg,

    ROUND(
        AVG(total_freight_mt) OVER (
            ORDER BY report_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS freight_3m_avg

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Monthly Performance vs Overall Average
SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt,

    ROUND(
        (total_passengers - AVG(total_passengers) OVER ())
        / AVG(total_passengers) OVER () * 100,
        2
    ) AS passenger_vs_avg_pct,

    ROUND(
        (total_movements - AVG(total_movements) OVER ())
        / AVG(total_movements) OVER () * 100,
        2
    ) AS movement_vs_avg_pct,

    ROUND(
        (total_freight_mt - AVG(total_freight_mt) OVER ())
        / AVG(total_freight_mt) OVER () * 100,
        2
    ) AS freight_vs_avg_pct

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Outlier / Exceptional Month Analysis
SELECT
    report_month,
    total_passengers,
    total_movements,
    total_freight_mt,

    CASE
        WHEN total_passengers >= AVG(total_passengers) OVER ()
             + STDDEV(total_passengers) OVER ()
            THEN 'High'
        WHEN total_passengers <= AVG(total_passengers) OVER ()
             - STDDEV(total_passengers) OVER ()
            THEN 'Low'
        ELSE 'Normal'
    END AS passenger_status,

    CASE
        WHEN total_movements >= AVG(total_movements) OVER ()
             + STDDEV(total_movements) OVER ()
            THEN 'High'
        WHEN total_movements <= AVG(total_movements) OVER ()
             - STDDEV(total_movements) OVER ()
            THEN 'Low'
        ELSE 'Normal'
    END AS movement_status,

    CASE
        WHEN total_freight_mt >= AVG(total_freight_mt) OVER ()
             + STDDEV(total_freight_mt) OVER ()
            THEN 'High'
        WHEN total_freight_mt <= AVG(total_freight_mt) OVER ()
             - STDDEV(total_freight_mt) OVER ()
            THEN 'Low'
        ELSE 'Normal'
    END AS freight_status

FROM rgia_monthly_operational_kpis
ORDER BY report_month;

#Executive Insight Table
SELECT
    report_month,

    total_passengers,
    total_movements,
    total_freight_mt,

    passengers_per_aircraft_movement,
    freight_per_aircraft_movement_mt,

    international_passenger_share_pct,
    international_movement_share_pct,

    passenger_mom_growth_pct,
    movement_mom_growth_pct,
    freight_mom_growth_pct,

    RANK() OVER (
        ORDER BY total_passengers DESC
    ) AS passenger_rank,

    RANK() OVER (
        ORDER BY total_movements DESC
    ) AS movement_rank,

    RANK() OVER (
        ORDER BY total_freight_mt DESC
    ) AS freight_rank

FROM rgia_monthly_operational_kpis
ORDER BY report_month;