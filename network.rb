require File.expand_path('../node.rb', __FILE__)

class Network

  attr_accessor :nodes, :step

  @@badInput = "Input array not same length as amount of nodes in input layer"
  
  # creates a fully connected network (layer i only outputs to i + 1)
  # with n nodes per layer, i input nodes, h hidden layers, and o output nodes,
  # a transition function tf--a number--corresponding values available for 
  # lookup and step  -- a decimal number representing learning rate in 
  # Node.calculate
  # each index of nodes represents a different layer
  def initialize(n, i, h, o, tf, step)
    @step = step
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
    

  def backPropagate(expected)
    #find the error of the output node
    @nodes[(@nodes.count-1)][0].error = expected - @nodes[(@nodes.count-1)][0].output
    
    #find the errors for all the hidden layers
    @nodes.slice(1..(@nodes.count-1)).reverse.each_with_index do |x,i|
     layer = @nodes.count-1-i
     #update the next layers error values with each of the incoming weights
     #need old weights so do here.
     @nodes[layer].each do |n|
        @nodes[(layer-1)].each_with_index do |nextN,index|
          nextN.error =0
        end
        @nodes[(layer-1)].each_with_index do |nextN,index|
          nextN.error += n.error*n.incomingWeights[index]
        end

    #TODO scoping issue derivative, talk with Ryan

      sum = n.sumWithWeights
      n.incomingWeights.each_with_index do |w,index|
        derivative = 0
        case @transitionFunction
        when 0 
          derivative = n.logisticDeriv(sum)
        end
        delta = @step*n.error*(n.logisticDeriv(sum))*@nodes[layer-1][index].output
        n.incomingWeights[index] = w+delta
      end
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
