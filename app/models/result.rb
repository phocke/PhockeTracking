require "csv"
class Result

  attr_accessor :results, :selected_habits
	
  CSV_PATH = File.expand_path(Rails.root.to_s + "/db/tracking.csv")

  def initialize
    @results = {}
    @selected_habits = YAML::load( File.open Rails.root.to_s + "/config/tracked-habits.yml" )[:now]
    load_headers
    load_results
  end

  def load_results
    CSV.foreach CSV_PATH,  headers: true do |results|
      # "1/22/2012 1:40:48"
      # it is parsed incorrectly - it swaps :mday with :mon
      # timestamp = Date._parse result[0]
      # date = Date.new(timestamp[:year], timestamp[:mday], timestamp[:mon]).to_s
      # @results[date] = result[1, result.size] #get rid of timestamp
      results = results.to_a
      results = results.map do |pair| 
        pair[0] = sanitize_attribute_name pair[0]
        pair[1] = digitize pair[1]
        pair
      end
      results = Hash[results]
      results.each{|key, value| @results[key] << value}
    end
  end

  def load_headers
    CSV.read(CSV_PATH).to_a.shift.collect do |name|
      @results[sanitize_attribute_name name] = []
    end
  end

  def sanitize_attribute_name(attribute)
    attribute.strip.gsub(/[^0-9A-Za-z.\-]+/, '_').gsub(/_$/, '').downcase.to_sym
  end

  def which_habit
    arr = []; (1..13).each{|num| 10.times{ arr << num}}
    arr.reverse
  end

  def habits
    @selected_habits.map do |habit_name| 
      habit_name.to_s[0,40]
    end
  end

  def digitize(string)
    return 1 unless string and string.strip =~ /yes/
    return 3
  end

  def which_day
    a = []; 13.times{a << (1..10).to_a}
    a.flatten
  end

  def output
    a = []
    @selected_habits.each do |habit|
      a << @results[habit]
    end
    return a.flatten
  end
end