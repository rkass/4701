require File.expand_path('../node.rb', __FILE__)

class Network

  attr_accessor :nodes

  @@badInput = "Input array not same length as amount of nodes in input layer"
  
  # creates a fully connected network (layer i only outputs to i + 1)
  # with n nodes per layer, i input nodes, h hidden layers, and o output nodes
  # transition function tf--a number--corresponding values available for lookup
  # in Node.calculate
  # each index of nodes represents a different layer
  def initialize(n, i, h, o, tf)
    @nodes = []
    #input layer
    @nodes[0] = []
    (0..(i - 1)).each do
      @nodes[0].push Node.new(nil, nil, tf)
    end
    #hidden layers
    (1..h).each do
      @nodes[h] = []
      (0..(n - 1)).each do
        @nodes[h].push Node.new(@nodes[h - 1], initWeights(@nodes[h - 1].count), tf)
      end
    end
    #output layer
    @nodes[h + 1] = []
    (0..(o - 1)).each do
      @nodes[h + 1].push Node.new(@nodes[h], initWeights(@nodes[h].count), tf)
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
    

  #creates an array of n random numbers from 0 to 1
  def initWeights(n)
    ret = []
    (0..(n - 1)).each do
      ret.push rand
    end
    ret
  end

  private :initWeights

end
