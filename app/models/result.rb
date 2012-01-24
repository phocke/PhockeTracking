require "csv"
class Result

  attr_accessor :headers, :results
	
  CSV_PATH = File.expand_path(Rails.root.to_s + "/db/tracking.csv")

  def initialize
    load_headers
    create_attribute_methods
    load_results
  end

  def selfclass
    (class << self; self; end)
  end

  def create_attribute_methods
    @headers.each do |header|
      selfclass.send(:define_method, header) do |date|
        index = 2

        results[date][index]
      end
    end
  end

  def load_results
    @results = {}

    rows = CSV.read(CSV_PATH)
    rows.shift

    rows.each do |result|
      # "1/22/2012 1:40:48"
      # it is parsed incorrectly - it swaps :mday with :mon
      timestamp = Date._parse result[0]
      date = Date.new(timestamp[:year], timestamp[:mday], timestamp[:mon]).to_s
      @results[date] = result[1, result.size] #get rid of timestamp
    end
  end

  def load_headers
    @headers = CSV.read(CSV_PATH).to_a.shift.collect do |name|
      sanitize_attribute_name name
    end 
  end

  def sanitize_attribute_name(attribute)
    attribute.strip.gsub(/[^0-9A-Za-z.\-]+/, '_').gsub(/_$/, '').downcase
  end


end