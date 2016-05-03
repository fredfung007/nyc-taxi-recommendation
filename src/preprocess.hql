--green taxi
CREATE EXTERNAL TABLE greencab (VendorID string,pickup_time timestamp,dropoff_time timestamp,Store_and_fwd_flag string,RateCodeID string,Pickup_longitude float,
  Pickup_latitude float,Dropoff_longitude float,Dropoff_latitude float,Passenger_count int,Trip_distance float,
  Fare_amount float,Extra float,MTA_tax float,Tip_amount float,Tolls_amount float,Ehail_fee float,Total_amount float,Payment_type string,Trip_type string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  location '/user/***/cab/green';

--yellow
CREATE EXTERNAL TABLE yellowcab (VendorID STRING,pickup_time timestamp,dropoff_time timestamp,Passenger_count int,Trip_distance FLOAT, Pickup_longitude float,
  Pickup_latitude float,RateCodeID string,Store_and_fwd_flag string,Dropoff_longitude float,Dropoff_latitude float,
  Payment_type string, Fare_amount float,Extra float,MTA_tax float,Tip_amount float,Tolls_amount float,Total_amount float)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  location '/user/***/cab/yellow/';

--green2015
CREATE EXTERNAL TABLE greencab2015 (VendorID string,pickup_time timestamp,dropoff_time timestamp,Store_and_fwd_flag string,RateCodeID string,Pickup_longitude float,
  Pickup_latitude float,Dropoff_longitude float,Dropoff_latitude float,Passenger_count int,Trip_distance float,
  Fare_amount float,Extra float,MTA_tax float,Tip_amount float,Tolls_amount float,Ehail_fee float,UNKNOWN string,Total_amount float,Payment_type string,Trip_type string,UNKNOWN2 string,UNKNOWN3 string)
  ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
  location '/user/***/cab/green2015';

CREATE VIEW rawcabs
AS
  SELECT pickup_time, dropoff_time,passenger_count,trip_distance,total_amount,payment_type,pickup_longitude,pickup_latitude
  FROM greencab
  UNION ALL
  SELECT pickup_time, dropoff_time,passenger_count,trip_distance,total_amount,payment_type,pickup_longitude,pickup_latitude 
  FROM greencab2015
  UNION ALL
  SELECT pickup_time, dropoff_time,passenger_count,trip_distance,total_amount,payment_type,pickup_longitude,pickup_latitude
  FROM yellowcab WHERE (Dropoff_longitude BETWEEN -74.27 AND -73.70);



--preprocessing
CREATE VIEW cleancab
AS
  SELECT pickup_time, dropoff_time,passenger_count,trip_distance,total_amount,payment_type,pickup_longitude,pickup_latitude
  FROM rawcabs
  where trip_distance<>0 and (pickup_latitude BETWEEN 40.48 AND 40.92) AND (pickup_longitude BETWEEN -74.27 AND -73.70) AND passenger_count IS NOT NULL;
  

--convert GPS to area_code
--row (0-660) col(0-439)
CREATE VIEW cabs (pickup_time, dropoff_time, passenger_count, trip_distance, total_amount, payment_type, pickup_longitude, pickup_latitude, area_code_row, area_code_col)
AS
  SELECT pickup_time, dropoff_time,passenger_count,trip_distance,total_amount,payment_type,pickup_longitude,pickup_latitude, floor( (pickup_latitude - 40.48) * 1000 ), floor ( (pickup_longitude + 74.27 ) * 1000 )
  FROM cleancab;