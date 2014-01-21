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

  desc "Import schedule."
  task :import_schedule => :environment do
    import_schedule(DATA_FILE)
  end

end