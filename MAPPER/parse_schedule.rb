require 'csv'
require 'json'
require 'sqlite3'
require 'data_mapper' # requires all the gems listed above

unless defined?(LOG_DIRECTORY)
  LOG_DIRECTORY = "log"
  DB_DIRECTORY = "db"
  DB_PATH = "#{DB_DIRECTORY}/hacked_schedule.sqlite"
  DB_CONN_STR = "sqlite://#{Dir.pwd}/#{DB_PATH}"
  OUTPUT_DIR = "output"
end

# DATA MAPPER
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

def detect_errors_in hashed_bells
  days = {}
  hashed_bells.each do |d|
    day = d[:start_date]
    val = "bell:#{d[:title]}, cycle:#{d[:cycle]}"
    puts "WARNING: Duplicate date! #{day} -- #{val}" if days[day]
    days[day] = val
  end
end

def load_schedule_from hashed_day
  h = hashed_day

  start_date = h[:start_date]
  date = Date.strptime start_date, "%m/%d/%Y"
  
  # Clean title of strange characters (presumably from Windows export):
  title = h[:title].strip.gsub(/[^a-zA-Z0-9 ]/, "")

  chapel_title       = "Chapel Schedule"
  assembly1_title    = "Assembly 1 Schedule"
  assembly3_title    = "Assembly 3 Schedule"
  special_fair_title = "Special Fair Day Schedule"
  case 
  when /Chapel.+Schedule/ =~ title
    title = chapel_title
  when /Assembly +1 Schedule/ =~ title
    title = assembly1_title
  when /#{assembly3_title}/ =~ title
    title = assembly3_title
  when /Special Fair Day +Schedule/ =~ title
    title = special_fair_title
  end

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
  detect_errors_in bells
  bells.each do |day|
    load_schedule_from day
  end
end

def write_schedule_to_json
  File.open("#{OUTPUT_DIR}/schedule.json","w") do |f|
    f.write(Schedule.all.to_json)
  end
end