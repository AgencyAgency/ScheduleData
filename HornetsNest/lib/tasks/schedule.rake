require "csv"
require 'pp'

DATA_DIR="../data"
# DATA_FILE="#{DATA_DIR}/faculty 2013-2014 Cycles and Schedules 112213.txt"
DATA_FILE="#{DATA_DIR}/converted.txt"

namespace :io do

  desc "Show just the header"
  task :header do
    parse_schedule do |line, i|
      if i == 0
        line.each_with_index do |col, col_index|
          puts "#{col_index}: #{col}"
        end
        stop = false
      else
        stop = true
      end
      stop
    end
  end

  desc "Show just the data."
  task :data do
    parse_schedule do |line, i|
      if i > 0
        p line
      end
      false
    end
  end

  desc "Hash"
  task :hash do
    p hash_schedule.first
  end

end

def parse_schedule
  options = { col_sep: "\t",
              quote_char: "~" }
  parsed_file = CSV.read(DATA_FILE, options)
  parsed_file.each_with_index do |line, i|
    if block_given?
      stop = yield(line, i)
    end
    break if stop
  end 
end

def hash_schedule
  schedule = []
  options = { headers: true, 
              header_converters: :symbol,
              converters: :all,
              col_sep: "\t",
              quote_char: "~"
            }
  CSV.foreach(DATA_FILE, options) do |row|
    schedule << Hash[row.headers[0..-1].zip(row.fields[0..-1])]
  end
  return schedule
end