# Taxi Pickup Location Recommendation: A Learning Approach
This is the repository for Spring 2016 Realtime and Big Data Analytics Course Project at NYU CIMS.

## Overview
In New York City, 13,000 taxis complete over 170 million trips a year. By utilizing the historical NYC Taxi travel data, the pattern of behaviors of taxi riders could be mined. In this paper, an taxi driver recommendation system is formulated to leverage the vacancy of taxis by giving recommendations to taxi drivers to busy blocks. This model is constructed based on the analytic aggregation of existing historical travel data and regression methods. Finally, we construct an individualized recommendation based on the regression results and the status of the requesting taxi in order to avoid giving the same recommendation to all taxis.

However, due to the size of the data, we utilized the Apache Hadoop framework, including Apache Hive for data storage and statistical analysis and Apache Spark MLlib for regression and evaluation. This is the first time that urban computing meets big data.
