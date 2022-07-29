require 'colorize'
require "functionalities"


class Date
    attr_accessor :year, :month, :day
   
   def initialize(year, month, day)
        @year = year
        @month = month
        @day = day
   end
end

def get_month_string(num)
  case num
  when 1
    'Jan'
  when 2
    'Feb'
  when 3
    'Mar'
  when 4
    'Apr'
  when 5
    'May'
  when 6
    'Jun'
  when 7
    'Jul'
  when 8
    'Aug'
  when 9
    'Sep'
  when 10
    'Oct'
  when 11
    'Nov'
  when 12
    'Dec'
  end
end



def a_function(arguments)
    filename = Dir.entries(arguments[2])
    filename.reject!{|i| !i.include?(arguments[1].year)}
    max_temprature= -99999
    min_temprature=99999
    max_humid = -99999
    for i in filename
        hash = extract_data("#{arguments[2]}/#{i}")
        max = hash["Max TemperatureC"]
        min = hash["Min TemperatureC"]
        maxh = hash["Max Humidity"]
        
        if(max_temprature<max.compact.max)
            max_temprature = max.compact.max
            max_day = hash["PKT"][max.index(max_temprature)]
        end
        if(min_temprature>min.compact.min)
            min_temprature = min.compact.min
            min_day = hash["PKT"][min.index(min_temprature)]
        end
        if(max_humid<maxh.compact.max)
            max_humid = maxh.compact.max
            max_humid_day = hash["PKT"][maxh.index(max_humid)]
        end
    end
    puts "Highest: #{max_temprature} on #{get_full_month_string(max_day[1].to_i)} #{max_day[2]}"
    puts "Lowest: #{min_temprature} on #{get_full_month_string(min_day[1].to_i)} #{min_day[2]}"
    puts "Humid: #{max_humid} on #{get_full_month_string(max_humid_day[1].to_i)} #{max_humid_day[2]}"    
    # p max_temprature
    # p max_day
    # p min_temprature
    # p min_day
    # p max_humid
    # p max_humid_day

end




def e_function(arguments)
    filename = Dir.entries(arguments[2])
    filename.reject!{|i| !i.include?(arguments[1].year)}
    
    filename.reject!{|i| !i.include?("#{get_month_string(arguments[1].month)}")}
    filename = filename[0]
    # p filename
    hash = extract_data("#{arguments[2]}/#{filename}")
    avg_max_temp= hash["Max TemperatureC"].compact.sum/hash["Max TemperatureC"].compact.size
    avg_min_temp = hash["Min TemperatureC"].compact.sum/hash["Min TemperatureC"].compact.size
    maxh = hash["Max Humidity"].compact.sum/hash["Max Humidity"].compact.size
        
    puts "Highest Average: #{avg_max_temp} "
    puts "Lowest Average: #{avg_min_temp}"
    puts "Average Humidity: #{maxh}"    
end


def c_function(arguments)
    filename = Dir.entries(arguments[2])
    filename.reject!{|i| !i.include?(arguments[1].year)}
    
    filename.reject!{|i| !i.include?("#{get_month_string(arguments[1].month)}")}
    filename = filename[0]
    # p filename
    hash = extract_data("#{arguments[2]}/#{filename}")

    max_temp = hash["Max TemperatureC"]

    min_temp = hash["Min TemperatureC"]
    values= max_temp.zip(min_temp)
    
    values.each_with_index do |i,ind|
        i.compact!
        if(i.length==2)

            print "#{ind} " 
            i[0].times { print "+".blue }

            i[1].times { print "+".red }
            print "#{i[0]}C - #{i[1]}C"
            puts ""
        end
    end
        
end
    





def get_full_month_string(num)
    case num
    when 1
      "January"
    when 2
        "February"
    when 3
        "March"
    when 4
        "April"
    when 5
        "May"
    when 6
        "June"
    when 7
        "July"
    when 8
        "August"
    when 9
        "September"
    when 10
        "October"
    when 11
        "Novembber"
    when 12
       return "December"                
    end
    
end

def extract_arg
  args = [].new
  args << ARGV[0][-1]
  temp = ARGV[1].split('/')
  args << Date.new(temp[0], temp[1], temp[2])
  args << ARGV[2]
end
# Extracting Data from File
def extract_data(filename)
  file = File.open(filename, 'r')
  data = file.readlines
  keys = data[0].split(',') # spliting the first line that contains the column name
  data.delete_at(0)
  keys.map!(&:strip)
  hash = {}.new # hash that will store extracted data
  keys.each do |i|
    hash[i] = []
  end
  data.each do |d| # extracting numeric values from each line provided
    values = d.split(',')
    pkt = values[0].split('-')
    values.map! { |i| i == '' ? nil : i.to_i }
    values[0] = pkt
    values.each_with_index do |num, index| # adding data to the hash
      hash[keys[index]].push(num)
    end
  end
  hash # returning extracted values
end

def weather_man
  arguments = extract_arg
  # p arguments
  case arguments[0]
  when 'a'
    a_function(arguments)
  when 'e'
    e_function(arguments)
  when 'c'
    c_function(arguments)
  end
end
weather_man
# [].methods