require 'json'

module ScheduleParser
  def hash_schedule data_file
    JSON.parse(File.read(data_file));
  end

  def import_schedule data_file
    hash_schedule(data_file).each do |day_info|
      # {"id"=>1, 
      # "day"=>"2013-08-26",
      # "cycle"=>1,
      # "title"=>"Special Convocation Schedule"}
      bell_name = day_info['title']
      cycle_name = day_info['cycle'].to_s
      string_day = day_info['day']
      SchoolDay.find_or_create_by_bell_and_cycle_names_and_day bell_name, cycle_name, string_day
    end
  end
end