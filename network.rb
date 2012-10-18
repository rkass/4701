require File.expand_path('../node.rb', __FILE__)

class Network

  attr_accessor :nodes
  
  # creates a fully connected network with 
  # n nodes per layer, i input nodes, h hidden layers
  # each index of nodes represents a different layer
  def initialize(n, i, h)
    @nodes = []
    #input layer
    @nodes[0] = []
    (0..(i - 1)).each do
      @nodes[0].push Node.new(nil, nil)
    end
    #hidden layers
    (1..h).each do
      @nodes[h] = []
      (0..(n - 1)).each do
        @nodes[h].push Node.new(@nodes[h - 1], initWeights(@nodes[h - 1].count))
      end
    end
    #output layer
    @nodes[h + 1] = [Node.new(@nodes[h], initWeights(@nodes[h].count))]
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
