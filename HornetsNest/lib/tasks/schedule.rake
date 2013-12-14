require 'pp'
require 'schedule_parser'
include ScheduleParser

DATA_DIR="../data"
# DATA_FILE="#{DATA_DIR}/faculty 2013-2014 Cycles and Schedules 112213.txt"
DATA_FILE="#{DATA_DIR}/converted.txt"

namespace :io do

  desc "Show just the header"
  task :header do
    parse_schedule(DATA_FILE) do |line, i|
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
    parse_schedule(DATA_FILE) do |line, i|
      if i > 0
        p line
      end
      false
    end
  end

  desc "Hash"
  task :hash do
    p hash_schedule(DATA_FILE).first
  end

end