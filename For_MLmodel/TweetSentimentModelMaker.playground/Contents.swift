import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath:"Users/lijingyan/Desktop/twitter-sanders-apple3.csv"))

let(trainingData, testingData) = data.randomSplit(by: 0.8, seed:5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: "text", labelColumn: "class")

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: "text", labelColumn: "class")

let evaluationAccurrancy = (1.0 - evaluationMetrics.classificationError)

let metaData = MLModelMetadata(author: "Sherry Li", shortDescription: "A model trained to classify sentiment on tweets", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "Users/lijingyan/Desktop/TweetSentimentClassifier.mlmodel"))

// testing positive
try sentimentClassifier.prediction(from: "@Apple is a good company!")
// texting negative
try sentimentClassifier.prediction(from: "@Apple is a just ok company!")
