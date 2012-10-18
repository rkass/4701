class Node

  attr_accessor :incomingNodes, :incomingWegihts, :input, :output

  def initialize(nodes, weights, transition)
    @incomingNodes = nodes #nodes receiving this as input
    @incomingWeights = weights #weights 
    @transitionFunction = transition
  end

  def calculate
    if @input == nil
      input = sumWithWeights
      case @transitionFunction
      when 0
        @output = logistic input
      end
    else
      @output = @input
    end
  end 

  def sumWithWeights
    ret = 0
    for i in 0..(@incomingNodes.count - 1)
      ret += @incomingNodes[i].output * @incomingWeights[i]
    end
    ret
  end
    
  #Transition Functions:
  
  def logistic(x)
    1/(1 + Math.exp(-x))
  end

  private :sumWithWeights, :logistic
    

end
