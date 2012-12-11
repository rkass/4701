require File.expand_path('../trainNetwork.rb', __FILE__)

#loops over trainAndValidate to find the best result
#returns the best neural net, along with it's squared
#difference average, and the corresponding naive
#squared difference average
#inputs correspond
def findBestIn(x, n, h, step, loops)
  #set initial
  best = trainAndValidate(x, n, h, step)
  for i in 2..loops
    trained = trainAndValidate(x, n, h, step)
    if trained.ann < best.ann
      best = trained
    end
  end
  best
end

def findAverageIn(x, n, h, step, loops)
  total = 0
  for i in 1..loops
    trained = trainAndValidate(x, n, h, step) 
    total += trained.ann
  end
  total/loops
end

