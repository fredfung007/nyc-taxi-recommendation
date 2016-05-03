import org.apache.spark.mllib.regression.LabeledPoint;
import org.apache.spark.mllib.linalg.Vectors;
import org.apache.spark.mllib.evaluation.RegressionMetrics;
import org.apache.spark.mllib.util.MLUtils;

import org.apache.spark.mllib.tree.RandomForest;
import org.apache.spark.mllib.tree.model.RandomForestModel;
import org.apache.spark.mllib.tree.GradientBoostedTrees;
import org.apache.spark.mllib.tree.configuration.BoostingStrategy;
import org.apache.spark.mllib.tree.model.GradientBoostedTreesModel;
import org.apache.spark.SparkContext._;
import org.apache.spark.mllib.feature.Normalizer;

implicit def bool2int(b:Boolean) = if (b) 1 else 0

// Load and parse the data
val data = sc.textFile("/user/qf264/midtown-2012");
val parsedData = data.map { line =>
  val parts = line.split('\t')
  val year = parts(0).toInt
  val month = parts(1).toInt
  val isWeekday =bool2int( parts(3).toBoolean)
  val hour = parts(4).toInt
  val row = parts(5).toInt
  val col = parts(6).toInt
  val prcp = parts(14).toDouble
  val snwd = parts(15).toDouble
  val snow = parts(16).toDouble
  val tmax = parts(17).toDouble
  val tmin = parts(18).toDouble

  val bias = 1
  val count = parts(7).toInt
  val total = parts(11).toDouble

  LabeledPoint(total, Vectors.dense(year,month,isWeekday,hour,prcp,snwd,snow,tmax,tmin))
}.cache()

val normalizer = new Normalizer()
val data_norm = parsedData.map(x => (x.label, normalizer.transform(x.features)))
val parsedData_norm = data_norm.map { x =>
  LabeledPoint(x._1, x._2)
}.cache()

val splits = parsedData_norm.randomSplit(Array(0.7, 0.15, 0.15))
val (trainingData, valData, testData) = (splits(0), splits(1), splits(2))

// Train a RandomForest model.
val categoricalFeaturesInfo = Map[Int, Int]()
val numTrees = 22 
val featureSubsetStrategy = "all" 
val impurity = "variance"
val maxDepth = 20
val maxBins = 32

val RFmodel = RandomForest.trainRegressor(trainingData, categoricalFeaturesInfo,
  numTrees, featureSubsetStrategy, impurity, maxDepth, maxBins)

//Evaluation
val trainresult = trainingData.map { point =>
  val prediction = RFmodel.predict(point.features)
  (point.label, prediction)
}

val metrics = new RegressionMetrics(trainresult)
println(s"training R-squared = ${metrics.r2}")

val valresult = valData.map { point =>
  val prediction = RFmodel.predict(point.features)
  (point.label, prediction)
}

val metrics = new RegressionMetrics(valresult)
println(s"validation R-squared = ${metrics.r2}")

val testresult = testData.map { point =>
  val prediction = RFmodel.predict(point.features)
  (point.label, prediction)
}
val metrics = new RegressionMetrics(testresult)
println(s"test R-squared = ${metrics.r2}")

//GradientBoostedTrees
val boostingStrategy = BoostingStrategy.defaultParams("Regression")
boostingStrategy.numIterations = 3 // Note: Use more iterations in practice.
boostingStrategy.treeStrategy.maxDepth = 5
boostingStrategy.treeStrategy.categoricalFeaturesInfo = Map[Int, Int]()

val GBTmodel = GradientBoostedTrees.train(trainingData, boostingStrategy)

//Evaluation
val trainresult = trainingData.map { point =>
  val prediction = GBTmodel.predict(point.features)
  (point.label, prediction)
}

val metrics = new RegressionMetrics(trainresult)
println(s"training R-squared = ${metrics.r2}")

val valresult = valData.map { point =>
  val prediction = GBTmodel.predict(point.features)
  (point.label, prediction)
}

val metrics = new RegressionMetrics(valresult)
println(s"validation R-squared = ${metrics.r2}")

val testresult = testData.map { point =>
  val prediction = GBTmodel.predict(point.features)
  (point.label, prediction)
}
val metrics = new RegressionMetrics(testresult)
println(s"test R-squared = ${metrics.r2}")

exit
