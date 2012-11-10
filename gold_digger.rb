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

def findBestInContext(x, n, h, step, loops)
  best = trainAndValidateContext(x, n, h, step)
  for i in 2..loops
    trained = trainAndValidate(x, n, h, step)
    if trained.ann < best.ann
      best = trained
    end
  end
  best
end

def findBestCombos(nplRange, hlRange, lrRange, iters, samples, processes)
  startTime = Time.now
  results = []
  (1..samples).each do
    threeTup = OpenStruct.new
    threeTup.npl = pickIntFromRange nplRange[0], nplRange[1]
    threeTup.hl = pickIntFromRange hlRange[0], hlRange[1]
    threeTup.lr = pickFloatFromRange lrRange[0], lrRange[1]
    threeTup.val = findBestIn(0.9, threeTup.npl, threeTup.hl, threeTup.lr, iters).ann
    results.push threeTup
  end
  (1..processes).each do
    npl = []
    hl = []
    lr = []
    total = (results.count * (results.count + 1.0)) / 2.0
    for i in 0..(results.count - 1)
      for n in i..(results.count - 1) do
        if rand < (results.count / total)  
          npl.push results[i].npl
          hl.push results[i].hl
          lr.push results[i].lr
        end
      end
    end
    results = []
    for i in 1..(samples)
      threeTup = OpenStruct.new
      threeTup.npl = npl[rand npl.count]
      threeTup.hl = hl[rand hl.count]
      threeTup.lr = lr[rand lr.count]
      threeTup.val = findBestIn(0.9, threeTup.npl, threeTup.hl, threeTup.lr, iters).ann
      results.push threeTup
    end
    results = insertionSort(results)
  end
  ret = OpenStruct.new
  ret.results = results
  ret.runTime = Time.now - startTime
  ret
end

def insertionSort(threeTupArray)
  sorted = []
  for i in threeTupArray
    inserted = false
    for n in 0..(sorted.count - 1)
      if i.val < sorted[n].val
        sorted.insert(n, i)
        inserted = true
        break
      end
    end
    sorted.insert(sorted.count, i) unless inserted
  end
  sorted
end

    

def pickIntFromRange(min, max)
  (rand (max - min + 1)) + min
end

def pickFloatFromRange(min, max)
  rand * (max - min) + min
end  
