class Node

  attr_accessor :incomingNodes, :incomingWeights, :input, :output, :error

  def initialize(nodes, weights, transition, inputNode, outputNode)
    @incomingNodes = nodes #nodes receiving this as input
    @incomingWeights = weights #weights  
    @inputNode = inputNode
    @outputNode = outputNode
    #transition function lookup
    #0 -> logistic function
    #--------------------------
    @transitionFunction = transition
  end 

  def calculate
    if !@inputNode
      @input = self.sumWithWeights
    end 
    if @inputNode or @outputNode  
      @output = @input
    else
      @output = case @transitionFunction
      when 0
        self.logistic @input
      end 
    end 
  end 

  def adjustWeights(step)
    derivative = case @transitionFunction
    when 0
      self.logisticDeriv @input
    end 
    derivative = 0 if derivative.nan?
    for i in 0..(@incomingNodes.count - 1)
      delta = step * @error * incomingNodes[i].output * derivative
      @incomingWeights[i] += delta
      if @incomingWeights[i].nan?
        abort("Step: #{step}\nError: #{@error}\nOutput: #{incomingNodes[i].output}Derivative: #{derivative}")
      end 
    end 
  end 

  def calculateError
    for i in 0..(@incomingNodes.count - 1)
      @incomingNodes[i].error += @error * @incomingWeights[i]
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
    1.0/(1.0 + Math.exp(-x))
  end 

  def logisticDeriv(x)
      Math.exp(x)/((1.0 + Math.exp(x)) ** 2.0)
  end 

  #protected :logistic, :logisticDeriv

end

