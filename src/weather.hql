CREATE EXTERNAL TABLE w_d (station string, station_name string, elevation float, latitude float, longitude float, dates date, PRCP float, SNWD float, SNOW float, TMAX float, TMIN float, TOBS float)
          row format delimited fields terminated by ','
          location '/user/***/data/';

CREATE VIEW w_d_raw (dates, prcp, snwd, snow, tmax, tmin)
AS          
SELECT dates, PRCP, SNWD, SNOW, TMAX, TMIN from w_d 
    where ((longitude BETWEEN -74.27 AND -73.70) AND (latitude BETWEEN 40.48 AND 40.92));

CREATE VIEW w_d_prcp (dates, prcp)
AS          
SELECT dates, avg(prcp) from w_d_raw
    where (prcp<>-9999)
    GROUP BY dates;
--
CREATE VIEW w_d_snwd (dates, snwd)
AS          
SELECT dates, avg(snwd) from w_d_raw
    where (snwd<>-9999)
    GROUP BY dates;

CREATE VIEW w_d_snow (dates, snow)
AS          
SELECT dates, avg(snow) from w_d_raw
    where (snow<>-9999)
    GROUP BY dates;

CREATE VIEW w_d_tmax (dates, tmax)
AS          
SELECT dates, avg(tmax) from w_d_raw
    where (tmax<>-9999)
    GROUP BY dates;

CREATE VIEW w_d_tmin (dates, tmin)
AS          
SELECT dates, avg(tmin) from w_d_raw
    where (tmin<>-9999)
    GROUP BY dates;

CREATE VIEW weather_day (dates, prcp, snwd, snow, tmax, tmin)
AS
SELECT w_d_prcp.date, w_d_prcp.prcp, w_d_snwd.snwd, w_d_snow.snow, w_d_tmax.tmax, w_d_tmin.tmin
    from
    w_d_prcp JOIN w_d_snwd on (w_d_prcp.dates = w_d_snwd.dates) JOIN w_d_snow on (w_d_prcp.dates = w_d_snow.dates) JOIN w_d_tmax on (w_d_prcp.dates = w_d_tmax.dates) JOIN (w_d_prcp.dates = w_d_tmin.dates);

CREATE EXTERNAL TABLE w_h (station string, station_name string, elevation float, latitude float, longitude float, dates timestamp, HPCP float, MF string)
          row format delimited fields terminated by ','
          location '/user/***/pre/';
CREATE VIEW weather_hour  (date, hpcp)
AS
SELECT date, AVG(HPCP) from w_h
    where ((longitude BETWEEN -74.27 AND -73.70) AND (latitude BETWEEN 40.48 AND 40.92) AND HPCP <> -9999)
  GROUP BY date;
