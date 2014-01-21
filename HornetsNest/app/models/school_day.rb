class SchoolDay < ActiveRecord::Base
  belongs_to :bell_cycle

  BellPeriod = Struct.new(:_period, :_bell_cycle_period, :_start_time, :_end_time) do
    def period
      _period
    end

    def bell_cycle_period
      _bell_cycle_period
    end

    def start_time
      _start_time
    end

    def end_time
      _end_time
    end
  end

  def bell_periods
    bcps = self.bell_cycle.bell_cycle_periods.inject([]) do |mem, bcp|
      mem << BellPeriod.new(bcp.period, bcp, bcp.local_start_time_on_day(day), bcp.local_end_time_on_day(day))
    end
    bcps
  end

  def bell_period_with_name period_name
    bcp = BellCyclePeriod.where(bell_cycle: bell_cycle, period: Period.find_by_name(period_name)).first
    BellPeriod.new(bcp.period, bcp, bcp.local_start_time_on_day(day), bcp.local_end_time_on_day(day))
    # bell_periods.find { |bpd| bpd.period.name == period_name }
  end

  def home_room; bell_period_with_name PERIOD_HOME_ROOM; end
  def p1; bell_period_with_name PERIOD_1; end
  def p2; bell_period_with_name PERIOD_2; end
  def p3; bell_period_with_name PERIOD_3; end
  def p4; bell_period_with_name PERIOD_4; end
  def p5; bell_period_with_name PERIOD_5; end
  def p6; bell_period_with_name PERIOD_6; end
  def p7; bell_period_with_name PERIOD_7; end
  def p8; bell_period_with_name PERIOD_8; end
  def assembly; bell_period_with_name PERIOD_ASSEMBLY; end
  def chapel; bell_period_with_name PERIOD_CHAPEL; end
  def lunch; bell_period_with_name PERIOD_LUNCH; end
  def meeting; bell_period_with_name PERIOD_MEETING; end
  def convocation; bell_period_with_name PERIOD_CONVOCATION; end
  def ceremony; bell_period_with_name PERIOD_ceremony; end

  class << self

    def today
      find_by_day Date.today
    end

    def find_or_create_by_bell_and_cycle_names_and_day(bell_name, cycle_name, string_day)
      bell_cycle = BellCycle.find_or_create_by_bell_and_cycle_names(bell_name, cycle_name)
      day = Date.parse(string_day)

      match = find_all_by_day day

      school_day = nil
      if match.blank?
        school_day = create(day: day, bell_cycle: bell_cycle)
      elsif match.size > 1
        raise "Error! Found too many school days (#{match.size}) for #{day}"
      else
        school_day = match.first
      end
      return school_day
    end
  end
end
