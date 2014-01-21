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
  property :room, String
  property :section, String
  property :m, Boolean, default: false
  property :tu, Boolean, default: false
  property :w, Boolean, default: false
  property :th, Boolean, default: false
  property :f, Boolean, default: false
  property :q1, Boolean, default: false
  property :q2, Boolean, default: false
  property :q3, Boolean, default: false
  property :q4, Boolean, default: false
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

def quarters_from section
  q1 = q2 = q3 = q4 = false

  # Sequence Course
  if section =~ /^[Q]/
    if section[3] == "1"
      q1 = true
    elsif section[3] == "2"
      q2 = true
    elsif section[3] == "3"
      q3 = true
    elsif section[3] == "4"
      q4 = true
    end

  # Life Skills
  elsif section =~ /^Y30/
    if section[3] == "1"
      q1 = q2 = true
    elsif section[3] == "2"
      q3 = q4 = true
    end

  # Non-Sequence
  else
    if section[3] == "1"
      q1 = q2 = true
    elsif section[3] == "2"
      q3 = q4 = true
    elsif section[3] == "3"
      q1 = q2 = q3 = q4 = true
    end
  end

  [q1, q2, q3, q4]
end

def load_teacher_from hashed_teacher
  h = hashed_teacher

  period = h[:block_name]
  period = "Home Room" if period == "0HR"
  section = h[:section_id]

  teacher = Teacher.first_or_create(
      first_name: h[:first_name],
      last_name: h[:last_name],
      room: h[:room],
      period: period,
      course: h[:full_name],
      section: section
    )

  # p h
  # p teacher

  monday    = teacher[:m]  || h[:weekday_name] == "Monday"
  tuesday   = teacher[:tu] || h[:weekday_name] == "Tuesday"
  wednesday = teacher[:w]  || h[:weekday_name] == "Wednesday"
  thursday  = teacher[:th] || h[:weekday_name] == "Thursday"
  friday    = teacher[:f]  || h[:weekday_name] == "Friday"

  # puts "monday: #{monday}"
  # puts "tuesday: #{tuesday}"
  # puts "wednesday: #{wednesday}"
  # puts "thursday: #{thursday}"
  # puts "friday: #{friday}"

  q1, q2, q3, q4 = quarters_from section
  q1 = teacher[:q1] || q1
  q2 = teacher[:q2] || q2
  q3 = teacher[:q3] || q3
  q4 = teacher[:q4] || q4

  unless teacher.update(
      email: nil,
      m: monday,
      tu: tuesday,
      w: wednesday,
      th: thursday,
      f: friday,
      q1: q1,
      q2: q2,
      q3: q3,
      q4: q4
    )
    puts "Error saving teacher!\n#{h}"
  end
end

# Filter for courses for teachers:
# - In upper school
# - Not home room
ALLOWED_PERIODS = %w[0HR 1 2 3 4 5 6 7 8 Assembly Chapel Lunch Meeting]
def selected_teachers hashed_teachers
  hashed_teachers.select do |teacher|
    teacher[:school_id] == "Upper" && 
    ALLOWED_PERIODS.include?(teacher[:block_name].to_s) #&&
    # teacher[:section_id] =~ /^[^Q]/ &&   # Remove quarter-long sequence courses
    # teacher[:section_id] =~ /^(?!SH)/ && # Remove Study Hall
    # teacher[:section_id] =~ /^(?!Y)/    # Remove Life Skills
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

def write_teachers_to_xls
  CSV.open("#{OUTPUT_DIR}/teachers.xls","w") do |csv|
    csv << Teacher.first.attributes.keys
    Teacher.all.each do |teacher|
      csv << teacher.attributes.values
    end
  end
end