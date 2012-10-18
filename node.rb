class Node

  attr_accessor :incomingNodes, :incomingWegihts, :input

  def initialize(nodes, weights)
    @incomingNodes = nodes #nodes receiving this as input
    @incomingWeights = weights #weights 
  end

end
