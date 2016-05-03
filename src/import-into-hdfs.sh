echo "Import of yellow taxi data begins";
date;
echo "---------------------------------";

YEAR="2009 2010 2011 2012 2013 2014"

MONTH="01 02 03 04 05 06 07 08 09 10 11 12"

for y in ${YEAR}; do
  for m in ${MONTH}; do
    echo "hdfs dfs -put ./yellow_tripdata_${y}-${m}.csv cab/y-${y}${m}.data"
    (hdfs dfs -put ./yellow_tripdata_${y}-${m}.csv cab/y-${y}${m}.data) &
  done
  wait
done

M="01 02 03 04 05 06"
for m in ${M}; do
  echo "hdfs dfs -put ./yellow_tripdata_2015-${m}.csv cab/y-${y}${m}.data"
  (hdfs dfs -put ./yellow_tripdata_2015-${m}.csv cab/y-2015${m}.data) &
done
wait
echo "---------------------------------";
echo "Import of yellow taxi data ends";
date;
echo "---------------------------------";
