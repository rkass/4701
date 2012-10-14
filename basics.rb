require 'rubygems'
require 'json'
class Basics

  #a 2d array with length of inner array = 5
  #index 0 = spread
  #index 1 = last trade
  #index 2 = amount bid
  #index 3 = amount asked
  #index 4 = time
  @@snapshots = JSON.load (File.read("data"))

  #month should be an int from 5 to 10
  #day should be an int from 1 to 31
  #hour should be an int from 0 to 23
  #returns unix time
  def getUnixTime(month, day, hour)
    if month < 10 then months = "0#{month}" else months = "#{month}" end
    if day < 10 then days = "0#{day}" else days = "#{day}" end
    if hour < 10 then hours = "0#{hour}" else hours = "#{hour}" end
    time = "2012-#{months}-#{days} #{hours}:00:00".to_time
    time.to_i
  end

  #return closest snapshot to this point in time
  def getSnapshot(month, day, hour)
    time = getUnixTime(month, day, hour)
    difference = false
    index = 0
    for i in @@snapshots
      diff = (i[4].to_time.to_i - time).abs
      if (not difference or diff < difference)
        difference = diff
        index = i
      end
    end
    index
  end
end




