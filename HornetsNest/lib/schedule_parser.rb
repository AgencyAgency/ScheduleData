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
      day = Date.parse(day_info['day'])

      bell_name = day_info['title']
      cycle_name = day_info['cycle'].to_s
      bell_cycle = BellCycle.find_or_create_by_bell_and_cycle_names(bell_name, cycle_name)
      
      return unless bell_cycle


    end
  end
end