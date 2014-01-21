require 'json'

module ScheduleParser
  def hash_schedule data_file
    JSON.parse(File.read(data_file));
  end

  def load_bell_cycle_periods_times(bell_name, cycle_name, period_names, times)
    period_names.each_with_index do |period_name, i|
      string_start_time = times[i][:start]
      string_end_time   = times[i][:end]
      BellCyclePeriod.find_or_create_by_bell_cycle_period_times(bell_name, cycle_name, period_name, string_start_time, string_end_time)
    end
  end

  def load_basic_periods
    times = [ {start: "07:40", end: "07:45"},
              {start: "07:50", end: "08:34"},
              {start: "08:39", end: "09:23"},
              {start: "09:28", end: "10:12"},
              {start: "10:17", end: "11:01"},
              {start: "11:06", end: "11:50"},
              {start: "11:50", end: "12:33"},
              {start: "12:38", end: "13:22"},
              {start: "13:27", end: "14:11"},
              {start: "14:16", end: "15:00"}]
    periods = [PERIOD_HOME_ROOM,
                PERIOD_1,
                PERIOD_2,
                PERIOD_3,
                PERIOD_4,
                PERIOD_5,
                PERIOD_LUNCH,
                PERIOD_6,
                PERIOD_7,
                PERIOD_8]
    load_bell_cycle_periods_times(BELL_BASIC, CYCLE_1, periods, times)
  end

  def import_period_times
    load_basic_periods
  end

  def import_school_days data_file
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