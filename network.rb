require File.expand_path('../node.rb', __FILE__)

class Network

  attr_accessor :nodes, :step

  @@badInput = "Input array not same length as amount of nodes in input layer"
  @@badTrain = "Did not run training, inputArray and expectedResults are of
         different length"
  # creates a fully connected network (layer l only outputs to l + 1)
  # with n nodes per hidden layer, i input nodes, h hidden layers, 
  # and o output nodes, transition function tf (according to lookup in node.rb), 
  # and step: learning rate. # each index of nodes represents a different layer
  def initialize(n, i, h, o, tf, step)
    @step = step
    @nodes = []
    @inputWeights = [] #gets set when train is called
    @outputWeights = []
    #input layer
    @nodes[0] = []
    (0..(i - 1)).each do
      @nodes[0].push Node.new(nil, nil, tf, true, false)
    end
    #hidden layers
    for x in 1..h do
      @nodes[x] = []
      (0..(n - 1)).each do
        @nodes[x].push Node.new(@nodes[x - 1], self.initWeights(@nodes[x - 1].count), tf, false, false)
      end
    end
    #output layer
    @nodes[h + 1] = []
    (0..(o - 1)).each do
      @nodes[h + 1].push Node.new(@nodes[h], self.initWeights(@nodes[h].count), tf, false, true)
    end
   end

  def propagate(input)
    raise @@badInput unless input.count == @nodes[0].count
    #set inputs
    for i in 0..(input.count - 1)
      @nodes[0][i].input = input[i]
    end
    #prop
    for i in 0..(@nodes.count - 1)
      for n in @nodes[i]
        n.calculate
      end
    end
  end

  def backPropagate(expected)
    self.resetErrors
    #find the error of the output nodes
    @nodes[@nodes.count - 1].each_with_index do |outputNode, i|
      outputNode.error = expected[i] - outputNode.output
    end
    #from output layer to lowest hidden layer 
    #-- input layers don't have weights, and thus don't have errors
    (@nodes.count - 1).downto(2) do |i|
      for n in @nodes[i]
        n.calculateError
      end
    end
    for i in 1..(@nodes.count - 1)
      for n in @nodes[i]
        n.adjustWeights @step
      end
    end
  end

  def train(inputsArray, expectedResults)
    raise @@badTrain unless inputsArray.count == expectedResults.count
    #set input weights
    for i in 0..(inputsArray[0].count - 1)
      @inputWeights[i] = 1.0/(inputsArray[0][i]) #reduces to 1
    end
    for i in 0 ..(inputsArray.count - 1)
      #did normalize
      propagate(inputsArray[i])
      backPropagate(expectedResults[i])
    end
  end

  #creates an array of n random numbers from -1 to 1
  def initWeights(n)
    ret = []
    (0..(n - 1)).each do
      if rand > 0.5
        ret.push rand
      else
        ret.push -1 * rand
      end
    end
    ret
  end

  def resetErrors
    for i in 0..(@nodes.count - 1)
      for n in @nodes[i]
        n.error = 0
      end
    end
  end

  protected :initWeights

end

