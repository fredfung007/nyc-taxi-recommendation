CREATE VIEW finalcabs
AS
SELECT YEAR(pickup_time) AS year ,MONTH(pickup_time) AS mon,DAY(pickup_time) AS day,from_unixtime(unix_timestamp(pickup_time,'yyyyMMdd'),'u') <=5 AS weekday,HOUR(pickup_time) AS hour,
  passenger_count, trip_distance, total_amount , area_code_row, area_code_col, 
  unix_timestamp(dropoff_time)-unix_timestamp(pickup_time) AS traveltime,
  (payment_type == "1" OR LOWER(payment_type) == "credit" OR LOWER(payment_type) == "cre" OR LOWER(payment_type) == "crd") AS credit
  FROM cabs
  WHERE ((payment_type <> "3") AND (payment_type <> "4") AND (payment_type <> "5") AND
  (payment_type <> "NA") AND LOWER(payment_type) <> "dis" AND LOWER(payment_type) <> "no" AND
  LOWER(payment_type)<>"no charge" AND LOWER(payment_type)<>"noc" AND (payment_type <> "Dispute"));

CREATE VIEW aggdcabs
AS
SELECT year,mon,day,weekday,hour,area_code_row, area_code_col,
  COUNT(passenger_count) AS count,AVG(passenger_count) AS avg_pass,AVG(trip_distance) AS avg_dis,
  AVG(total_amount) AS avg_total,SUM(total_amount) AS sum_total,AVG(traveltime) AS avg_time,credit
  FROM finalcabs
  GROUP BY year,mon,day,weekday,hour,area_code_row,area_code_col,credit;

CREATE VIEW aggdcabs_weather( year, mon, day, weekday, hour, area_code_row, area_code_col, count, avg_pass, avg_dis, avg_total, sum_total, avg_time, credit, prcp, snwd, snow, tmax, tmin)
AS
SELECT aggdcabs.year, aggdcabs.mon, aggdcabs.day, aggdcabs.weekday, aggdcabs.hour, 
  aggdcabs.area_code_row, aggdcabs.area_code_col, 
  aggdcabs.count, aggdcabs.avg_pass, aggdcabs.avg_dis, aggdcabs.avg_total, 
  aggdcabs.sum_total, aggdcabs.avg_time, aggdcabs.credit, 
  weather_day.prcp, weather_day.snwd, weather_day.snow, weather_day.tmax, weather_day.tmin
  FROM weather_day LEFT JOIN aggdcabs 
  on(aggdcabs.year = YEAR(weather_day.dates) AND aggdcabs.mon = MONTH(weather_day.dates) AND aggdcabs.day = DAY(weather_day.dates) );

CREATE VIEW aggdcabs_weather_midtown( year, mon, day, weekday, hour, area_code_row, area_code_col, count, avg_pass, avg_dis, avg_total, sum_total, avg_time, credit, prcp, snwd, snow, tmax, tmin)
AS
select * from aggdcabs_weather where (area_code_row between 267 and 281) AND (area_code_col between 279 and 287 );

CREATE VIEW aggdcabs_weather_midtown_2012( year, mon, day, weekday, hour, area_code_row, area_code_col, count, avg_pass, avg_dis, avg_total, sum_total, avg_time, credit, prcp, snwd, snow, tmax, tmin)
AS
select * from aggdcabs_weather_midtown where ( year = 2012 );

CREATE VIEW aggdcabs_weather_midtown_small( year, mon, day, weekday, hour, area_code_row, area_code_col, count, avg_pass, avg_dis, avg_total, sum_total, avg_time, credit, prcp, snwd, snow, tmax, tmin)
AS
select * from aggdcabs_weather_midtown where (area_code_row between 272 and 276) AND (area_code_col between 281 and 285 );

CREATE VIEW aggdcabs_weather_midtown_small_2012 ( year, mon, day, weekday, hour, area_code_row, area_code_col, count, avg_pass, avg_dis, avg_total, sum_total, avg_time, credit, prcp, snwd, snow, tmax, tmin)
AS
select * from aggdcabs_weather_midtown_small where ( year = 2012 );



INSERT OVERWRITE LOCAL DIRECTORY '/home/***/mt-2012/' 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t' 
select * from aggdcabs_weather_midtown_2012;