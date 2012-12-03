require 'rubygems'
require 'json'
require 'time'
require 'ostruct'
require File.expand_path('../trainNetwork.rb', __FILE__)

class Basics

  attr_accessor :snapshots

  #a 2d array with length of inner array = 5
  #index 0 = spread
  #index 1 = last trade
  #index 2 = amount bid
  #index 3 = amount asked
  #index 4 = time
  @@snapshots = JSON.load(File.read("data"))

  #month should be an int from 5 to 10
  #day should be an int from 1 to 31
  #hour should be an int from 0 to 23
  #returns unix time
  def getUnixTime(month, day, hour)
    if month < 10 then months = "0#{month}" else months = "#{month}" end 
    if day < 10 then days = "0#{day}" else days = "#{day}" end 
    if hour < 10 then hours = "0#{hour}" else hours = "#{hour}" end 
    time = Time.parse("2012-#{months}-#{days} #{hours}:00:00")
    time.to_i
  end 

  #return closest snapshot to this point in time
  def getSnapshot(month, day, hour)
    time = getUnixTime(month, day, hour)
    difference = false
    index = 0 
    for i in @@snapshots
      diff = ((Time.parse(i[4])).to_i - time).abs
      if (not difference or diff < difference)
        difference = diff
        index = i 
      end 
    end 
    index
  end 

  def getFirstSnapshots(x)
    ret = []
    for i in 0..(x - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      ret.push thisArr
    end 
    ret 
  end 

def getExpected(trainingSet)
  expected = []
  for i in 24..(trainingSet.count - 1)
    expected[i - 24] = [trainingSet[i][1]]
  end   
  expected
end


  def getSets(x)
    indexList = []
    for i in 0..(((@@snapshots.count - 24) * (1 - x)).to_int)
      indexList.push rand (@@snapshots.count - 24)
    end
    training = []
    validation = []
    expectedTraining = []
    expectedValidation = []
    for i in 0..(@@snapshots.count - 25)
      thisArr = []
      thisArr.push 5# @@snapshots[i][0].to_f
      thisArr.push 5 #@@snapshots[i][1].to_f
      thisArr.push 5 #@@snapshots[i][2].to_f
      thisArr.push 5 #@@snapshots[i][3].to_f
      if indexList.include? i
        validation.push thisArr 
        expectedValidation.push [@@snapshots[i + 24][1].to_f]
      else
        training.push thisArr
        expectedTraining.push [@@snapshots[i + 24][1].to_f]
      end
    end
    ret = OpenStruct.new
    ret.training = training
    ret.validation = validation
    ret.expectedTraining = expectedTraining
    ret.expectedValidation = expectedValidation
    ret
  end
    
       

  #from x onward
  def getLastSnapshots(x)
    ret = []
    for i in x..(@@snapshots.count - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      ret.push thisArr
    end 
    ret 
  end 

  def getLastNoise(x)
    ret = []
    for i in x..(@@snapshots.count - 1)
      thisArr = []
      thisArr.push rand 100.to_f
      thisArr.push 5 #thisArr.push @@snapshots[i][2].to_f
      thisArr.push rand 100.to_f
      thisArr.push rand 100.to_f
      ret.push thisArr
    end
    ret
  end
  def getFirstNoise(x)
    ret = []
    for i in 0..(x - 1)
      thisArr = []
      thisArr.push rand 100.to_f
      thisArr.push 5#thisArr.push @@snapshots[i][2].to_f
      thisArr.push rand 100.to_f
      thisArr.push rand 100.to_f
      ret.push thisArr
    end
    ret
  end  


  def getLastWithWeek(x)
    ret = []
    for i in x..(@@snapshots.count - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      weekAvg = getPastAverage(i, 24 * 7)
      thisArr.push weekAvg.spread
      thisArr.push weekAvg.price
      thisArr.push weekAvg.bid
      thisArr.push weekAvg.ask
      ret.push thisArr
    end 
    ret 
  end 

  def getFirstWithWeek(x)
    ret = []
    for i in 167..(x - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      weekAvg = getPastAverage(i, 24 * 7)
      thisArr.push weekAvg.spread
      thisArr.push weekAvg.price
      thisArr.push weekAvg.bid
      thisArr.push weekAvg.ask
      ret.push thisArr
    end 
    ret 
  end 
     
  def getFirstWithDay(x)
    ret = []
    for i in 23..(x - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      dayAvg = getPastAverage(i, 24)
      thisArr.push dayAvg.spread
      thisArr.push dayAvg.price
      thisArr.push dayAvg.bid
      thisArr.push dayAvg.ask
      ret.push thisArr
    end 
    ret 
  end 
  
  def getLastWithDay(x)
    ret = []
    for i in x..(@@snapshots.count - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      dayAvg = getPastAverage(i, 24)
      thisArr.push dayAvg.spread
      thisArr.push dayAvg.price
      thisArr.push dayAvg.bid
      thisArr.push dayAvg.ask
      ret.push thisArr
    end 
    ret 
  end 

  def getFirstWithWeekAndDay(x)
    ret = []
    for i in 167..(x - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      dayAvg = getPastAverage(i, 24)
      thisArr.push dayAvg.spread
      thisArr.push dayAvg.price
      thisArr.push dayAvg.bid
      thisArr.push dayAvg.ask
      weekAvg = getPastAverage(i, 24 * 7)
      thisArr.push weekAvg.spread
      thisArr.push weekAvg.price
      thisArr.push weekAvg.bid
      thisArr.push weekAvg.ask
      ret.push thisArr
    end 
    ret 
  end 


  def getLastWithWeekAndDay(x)
    ret = []
    for i in x..(@@snapshots.count - 1)
      thisArr = []
      thisArr.push @@snapshots[i][0].to_f
      thisArr.push @@snapshots[i][1].to_f
      thisArr.push @@snapshots[i][2].to_f
      thisArr.push @@snapshots[i][3].to_f
      dayAvg = getPastAverage(i, 24)
      thisArr.push dayAvg.spread
      thisArr.push dayAvg.price
      thisArr.push dayAvg.bid
      thisArr.push dayAvg.ask
      weekAvg = getPastAverage(i, 24 * 7)
      thisArr.push weekAvg.spread
      thisArr.push weekAvg.price
      thisArr.push weekAvg.bid
      thisArr.push weekAvg.ask
      ret.push thisArr
    end 
    ret 
  end 

  def getPastAverage(x, length)
    spreadAvg = []
    priceAvg = []
    bidAvg = []
    askAvg = []   
    for i in (x - length - 1)..x
      spreadAvg.push @@snapshots[i][0].to_f
      priceAvg.push @@snapshots[i][1].to_f
      bidAvg.push @@snapshots[i][2].to_f
      askAvg.push @@snapshots[i][3].to_f
    end
    ret = OpenStruct.new
    ret.spread = average spreadAvg
    ret.price = average priceAvg
    ret.bid = average bidAvg
    ret.ask = average askAvg
    ret
  end

  def getFirstSnapshotsRatioWeekAndDay(x)
    getFirstWithWeekAndDay((x * @@snapshots.count).to_i)
  end

   def getFirstSnapshotsRatioNoise(x)
    getFirstNoise((x * @@snapshots.count).to_i)
  end

  def getLastSnapshotsRatioNoise(x)
    getLastNoise((x * @@snapshots.count).to_i)
  end 
  
  def getLastSnapshotsRatioWeekAndDay(x)
    getLastWithWeekAndDay((x * @@snapshots.count).to_i)
  end
    
  def getFirstSnapshotsRatio(x)
    getFirstSnapshots((x * @@snapshots.count).to_i)
  end 
  
  def getLastSnapshotsRatio(x)
    getLastSnapshots((x * @@snapshots.count).to_i)
  end 

 #return string of getSnapshot
 def getSnapshotFloats(month,day,hour)
   strA = getSnapshot(month,day,hour)
   floatA = []
   strA.each do |s| 
      floatA.push s.to_f
   end 
   floatA
 end 
   
end
