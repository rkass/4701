class Node

  attr_accessor :incomingNodes, :incomingWeights, :input, :output, :error

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
      @output = logistic(@input)
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

  def logisticDeriv(x)
      Math.exp(x)/((1.0 + Math.exp(x))**2.0)
  end 

  private :logistic
    

end
