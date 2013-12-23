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

class Teacher
  include DataMapper::Resource

  property :id, Serial
  property :first_name, String
  property :last_name, String
  property :period, String
  property :course, String
  property :email, String
end
DataMapper.auto_upgrade!

def hash_teachers raw_schedule
  all = []
  options = { headers: true, 
              header_converters: :symbol,
              converters: :all,
              col_sep: ",",
              quote_char: "~" }
  CSV.foreach(raw_schedule, options) do |row|
    all << Hash[row.headers[0..-1].zip(row.fields[0..-1])]
  end
  return all
end

# def detect_errors_in hashed_bells
#   days = {}
#   hashed_bells.each do |d|
#     day = d[:start_date]
#     val = "bell:#{d[:title]}, cycle:#{d[:cycle]}"
#     puts "WARNING: Duplicate date! #{day} -- #{val}" if days[day]
#     days[day] = val
#   end
# end

def load_teacher_from hashed_teacher
  h = hashed_teacher

  teacher = Teacher.new( 
              first_name: h[:first_name],
              last_name: h[:last_name],
              email: nil,
              period: h[:block_name],
              course: h[:full_name])
  unless teacher.save
    puts "Error saving teacher!\n#{h}"
  end
end

# Filter for courses for teachers:
# - In upper school
# - Not home room
def selected_teachers hashed_teachers
  hashed_teachers.select do |teacher|
    teacher[:school_id] == "Upper" && 
    teacher[:block_name] != "0HR" && 
    teacher[:block_name].to_s != "0"
  end
end

def load_teachers_from hashed_teachers
  teachers = selected_teachers hashed_teachers
  # detect_errors_in bells
  teachers.each do |teacher|
    load_teacher_from teacher
  end
end

def write_teachers_to_json
  File.open("#{OUTPUT_DIR}/teachers.json","w") do |f|
    f.write(Teacher.all.to_json)
  end
end