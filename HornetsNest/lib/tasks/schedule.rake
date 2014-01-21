require 'pp'
require 'schedule_parser'
include ScheduleParser

DATA_DIR="data"
DATA_FILE="#{DATA_DIR}/schedule.json"

namespace :io do

  desc "Show first row of schedule."
  task :hash do
    p hash_schedule(DATA_FILE).first
  end

  desc "Import school days into schedule."
  task :import_school_days => :environment do
    puts "Importing school days..."
    import_school_days(DATA_FILE)
  end

  desc "Import period times into schedule."
  task :import_period_times => :environment do
    puts "Importing period times..."
    import_period_times
  end

  desc "Import all schedule data"
  task :import_all => [:import_school_days, :import_period_times]

end