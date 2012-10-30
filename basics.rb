require 'rubygems'
require 'json'
require 'time'
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
