class BellCyclePeriod < ActiveRecord::Base
  belongs_to :bell_cycle
  belongs_to :period

  TIME_FORMAT = "%H:%M"
  DATE_FORMAT = "%Y/%m/%d"

  def local_start_time_on_day(day)
    local_time_on_day(start_time, day)
  end

  def local_end_time_on_day(day)
    local_time_on_day(end_time, day)
  end

  class << self
    def find_or_create_by_bell_cycle_period_times(bell_name, cycle_name, period_name, string_start_time, string_end_time)
      bell_cycle = BellCycle.find_or_create_by_bell_and_cycle_names(bell_name, cycle_name)
      period = Period.find_or_create_by_name period_name

      start_time = Time.strptime("#{string_start_time} HST", "%H:%M %Z")
      end_time = Time.strptime("#{string_end_time} HST", "%H:%M %Z")

      match = self.where(bell_cycle: bell_cycle, period: period)

      bcp = nil
      if match.blank?
        bcp = create(bell_cycle: bell_cycle, 
          period: period,
          start_time: start_time,
          end_time: end_time)
      elsif match.size > 1
        raise "Error! Found too many bell-cycle-period (#{match.size}) for #{bell_cycle} : #{period}"
      else
        bcp = match.first
      end
      return bcp
    end
  end

  private

    def local_time_on_day(time, day)
      yyyymmdd = day.strftime(DATE_FORMAT)

      hhmm = time.in_time_zone("HST").strftime(TIME_FORMAT)
      Time.strptime("#{yyyymmdd} #{hhmm} HST", "#{DATE_FORMAT} #{TIME_FORMAT} %Z")
    end
end
