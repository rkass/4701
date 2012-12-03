require File.expand_path('../network.rb', __FILE__)
require File.expand_path('../basics.rb', __FILE__)
require 'ostruct'

#x = |training set|(|training set| + |validation set|)
#n = number of nodes per hidden layer
#h = number of hidden layers
#step = learning rate

def trainAndValidate(x, n, h, step)
  basics = Basics.new
  trainingSet = basics.getFirstSnapshotsRatio x
  validationSet = basics.getLastSnapshotsRatio x
  expectedArray = getExpected trainingSet
  trainingSet = trainingSet.slice(0..(trainingSet.count - 25))
  network = Network.new(n, 4, h, 1, 0, step)
  network.train(trainingSet, expectedArray)
  squaredDiffs = getSquaredDiffs(network, validationSet)
  ret = OpenStruct.new
  ret.ann = average squaredDiffs.netResults
  ret.naive = average squaredDiffs.naiveResults
  ret.net = network
  ret
end

#x = number of training examples
#y = number of validation examples
def trainAndValidateTrivial(x, y, n, h, step)
  trainingSet = []
  for i in 0..(x - 1)
    trainingSet.push [(rand 100).to_f]
  end
  validationSet = []
  for i in 0..(y - 1)
    validationSet.push [(rand 100).to_f]
  end
  network = Network.new(n, 1, h, 1, 0, step)
  network.train(trainingSet, trainingSet)
  squaredDiffs = getSquaredDiffsTrivial(network, validationSet, validationSet)
  ret = OpenStruct.new
  ret.ann = average squaredDiffs.netResults
  ret.naive = average squaredDiffs.naiveResults
  ret.net = network
  ret
end
def trainAndValidateNew(x, n, h, step)
  basics = Basics.new
  sets = basics.getSets x
  trainingSet = sets.training
  validationSet = sets.validation
  expectedTraining = sets.expectedTraining
  expectedValidation = sets.expectedValidation
  expectedArray = expectedTraining
  network = Network.new(n, 4, h, 1, 0, step)
  network.train(trainingSet, expectedArray)
  squaredDiffs = getSquaredDiffsNew(network, validationSet, expectedValidation)
  ret = OpenStruct.new
  ret.ann = average squaredDiffs.netResults
  ret.naive = average squaredDiffs.naiveResults
  ret.net = network
  ret
end

def trainWithNoise(x, n, h, step)
  basics = Basics.new
  trainingSet = basics.getFirstSnapshotsRatioNoise x
  trainingSetx = basics.getFirstSnapshotsRatio x
  validationSetx = basics.getLastSnapshotsRatio x
  validationSet = basics.getLastSnapshotsRatioNoise x
  expectedArray = getExpected trainingSetx
  trainingSet = trainingSet.slice(0..(trainingSet.count - 25))
  network = Network.new(n, 4, h, 1, 0, step)
  network.train(trainingSet, expectedArray)
  squaredDiffs = getSquaredDiffsNoise(network, validationSet, validationSetx)
  ret = OpenStruct.new
  ret.ann = average squaredDiffs.netResults
  ret.naive = average squaredDiffs.naiveResults
  ret.net = network
  ret
end




def trainAndValidateContext(x, n, h, step)
  basics = Basics.new
  trainingSet = basics.getFirstSnapshotsRatioWeekAndDay x
  validationSet = basics.getLastSnapshotsRatioWeekAndDay x
  expectedArray = getExpected trainingSet
  trainingSet = trainingSet.slice(0..(trainingSet.count - 25))
  network = Network.new(n, 12, h, 1, 0, step)
  network.train(trainingSet, expectedArray)
  squaredDiffs = getSquaredDiffs(network, validationSet)
  ret = OpenStruct.new
  ret.ann = average squaredDiffs.netResults
  ret.naive = average squaredDiffs.naiveResults
  ret.net = network
  ret
end

def getSquaredDiffsNew(network, validationSet, expectedValidation)
  resultsOnValidation = [] 
  naiveResults = [] 
  for i in 0..(validationSet.count - 25)
    network.propagate validationSet[i]
    #push squared difference of ANN result for 24h from i
    resultsOnValidation.push ((network.nodes[network.nodes.count - 1][0].output - expectedValidation[i][0]) ** 2)
    #push square difference obtained by predicting result strictly from the last price
    naiveResults.push ((validationSet[i][1] - expectedValidation[i][0]) ** 2)
  end
  ret = OpenStruct.new
  ret.netResults = resultsOnValidation
  ret.naiveResults = naiveResults
  ret
end


def getSquaredDiffsTrivial(network, validationSet, expectedValidation)
  resultsOnValidation = [] 
  naiveResults = [] 
  for i in 0..(validationSet.count - 25)
    network.propagate validationSet[i]
    #push squared difference of ANN result for 24h from i
    resultsOnValidation.push ((network.nodes[network.nodes.count - 1][0].output - expectedValidation[i][0]) ** 2)
    #push square difference obtained by predicting result strictly from the last price
    naiveResults.push ((validationSet[i][0] - expectedValidation[i][0]) ** 2)
  end
  ret = OpenStruct.new
  ret.netResults = resultsOnValidation
  ret.naiveResults = naiveResults
  ret
end


def getSquaredDiffs(network, validationSet)
  resultsOnValidation = [] 
  naiveResults = [] 
  for i in 0..(validationSet.count - 25)
    network.propagate validationSet[i]
    #push squared difference of ANN result for 24h from i
    resultsOnValidation.push ((network.nodes[network.nodes.count - 1][0].output - validationSet[i + 24][1]) ** 2)
    #push square difference obtained by predicting result strictly from the last price
    naiveResults.push ((validationSet[i][1] - validationSet[i + 24][1]) ** 2)
  end
  ret = OpenStruct.new
  ret.netResults = resultsOnValidation
  ret.naiveResults = naiveResults
  ret
end

def getSquaredDiffsNoise(network, validationSet, validationSetx)
  resultsOnValidation = [] 
  naiveResults = [] 
  for i in 0..(validationSet.count - 25)
    network.propagate validationSet[i]
    #push squared difference of ANN result for 24h from i
    resultsOnValidation.push ((network.nodes[network.nodes.count - 1][0].output - validationSetx[i + 24][1]) ** 2)
    #push square difference obtained by predicting result strictly from the last price
    naiveResults.push ((validationSet[i][1] - validationSetx[i + 24][1]) ** 2)
  end
  ret = OpenStruct.new
  ret.netResults = resultsOnValidation
  ret.naiveResults = naiveResults
  ret
end



def getExpected(trainingSet)
  expected = []
  for i in 24..(trainingSet.count - 1)
    expected[i - 24] = [trainingSet[i][1]]
  end
  expected
end

def average(arr)
  tot = 0.0
  for i in arr
    tot += i
  end
  tot/arr.count
end

def lostOutput input
  node = Node.new(nil, nil, 0, false, false)
  print "Logistic: #{node.logistic input}"
  print "Derivative: #{node.logisticDeriv input}"
end
