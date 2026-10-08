CREATE DATABASE rgia_airport_analytics;
USE rgia_airport_analytics;
SELECT DATABASE() AS current_database;
CREATE TABLE rgia_monthly_operational_kpis (
    report_month DATE NOT NULL,
    total_passengers DECIMAL(15,2),
    domestic_passengers DECIMAL(15,2),
    international_passengers DECIMAL(15,2),
    total_movements DECIMAL(12,2),
    domestic_movements DECIMAL(12,2),
    international_movements DECIMAL(12,2),
    total_freight_mt DECIMAL(15,2),
    domestic_freight_mt DECIMAL(15,2),
    international_freight_mt DECIMAL(15,2),
    passengers_per_aircraft_movement DECIMAL(10,4),
    freight_per_aircraft_movement_mt DECIMAL(10,4),
    domestic_passenger_share_pct DECIMAL(8,4),
    international_passenger_share_pct DECIMAL(8,4),
    domestic_movement_share_pct DECIMAL(8,4),
    international_movement_share_pct DECIMAL(8,4),
    passenger_mom_growth_pct DECIMAL(10,4),
    movement_mom_growth_pct DECIMAL(10,4),
    freight_mom_growth_pct DECIMAL(10,4),
    PRIMARY KEY (report_month)
);
DESCRIBE rgia_monthly_operational_kpis;
