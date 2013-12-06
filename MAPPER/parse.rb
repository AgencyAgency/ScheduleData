require 'csv'
require 'sqlite3'
require 'data_mapper' # requires all the gems listed above

unless LOG_DIRECTORY
  LOG_DIRECTORY = "log"
  DB_DIRECTORY = "db"
  DB_PATH = "#{DB_DIRECTORY}/hacked_schedule.sqlite"
  DB_CONN_STR = "sqlite://#{Dir.pwd}/#{DB_PATH}"
end

# DATA MAPPER
# If you want the logs displayed you have to do this before the call to setup
# DataMapper::Logger.new($stdout, :debug)
DataMapper::Logger.new("#{LOG_DIRECTORY}/data_mapper.log", :debug)
DataMapper::Model.raise_on_save_failure = true

DataMapper.setup(:default, DB_CONN_STR)

class Schedule
  include DataMapper::Resource

  property :id, Serial
  property :day, Date
  property :cycle, Integer
  property :title, String
end
DataMapper.auto_upgrade!

def parse_schedule raw_schedule
  options = { col_sep: "\t",
              quote_char: "~" }
  parsed_file = CSV.read(raw_schedule, options)
  parsed_file.each_with_index do |line, i|
    if block_given?
      stop = yield(line, i)
    end
    break if stop
  end 
end

def hash_schedule raw_schedule
  all = []
  options = { headers: true, 
              header_converters: :symbol,
              converters: :all,
              col_sep: "\t",
              quote_char: "~" }
  CSV.foreach(raw_schedule, options) do |row|
    all << Hash[row.headers[0..-1].zip(row.fields[0..-1])]
  end
  return all
end

def load_schedule_from hashed_day
  h = hashed_day

  start_date = h[:start_date]
  date = Date.strptime start_date, "%m/%d/%Y"
  title = h[:title].strip.gsub(/[^a-zA-Z0-9 ]/, "")
  schedule = Schedule.new( day: date,
                cycle: h[:cycle].to_i,
                title: title)
  unless schedule.save
    puts "Error saving schedule!\n#{h}"
  end
end

def bell_schedules_from hashed_schedule
  hashed_schedule.select { |day| day[:type] != "Cycle" }
end

def load_bell_schedules_from hashed_schedule
  bells = bell_schedules_from hashed_schedule
  bells.each do |day|
    load_schedule_from day
  end
end
