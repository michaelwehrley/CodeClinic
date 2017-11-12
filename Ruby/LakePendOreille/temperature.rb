require "net/http"

class Temperature
  WEATHER_DATA_SRC = URI('https://raw.githubusercontent.com/lyndadotcom/LPO_weatherdata/master/Environmental_Data_Deep_Moor_2012.txt')
  attr_reader :temperatures

  def initialize
    @sum = 0.0
    @temperatures = temperatures
  end

  def average
    (sum / count).round(2)
  end

  def median
    if count % 2 == 0
      ((temp_to_float + temp_to_float(1)) / 2).round(2)
    else
      temp_to_float.round(2)
    end
  end

  private

  def count
    temperatures.count
  end

  def sum
    temperatures.each do |temperature|
      @sum += temperature[0].to_f
    end
    @sum
  end

  def request_temperature_data
    res = Net::HTTP.get_response(WEATHER_DATA_SRC)
    res.body.scan(/\w*\s\d{2}:\d{2}:\d{2}\s(\d{2}\.\d{2})/)
  end

  def temperatures
    @temperatures ||= request_temperature_data
  end

  def temp_to_float(num = 0)
    temperatures[count / 2 + num][0].to_f
  end
end

temperature = Temperature.new

puts "Average = #{temperature.average}"
puts "Median = #{temperature.median}"
