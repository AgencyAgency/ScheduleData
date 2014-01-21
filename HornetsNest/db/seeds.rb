# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
def create klass, name
  klass.create(name: name) unless klass.find_by_name(name)
end

create Bell, BELL_ASSEMBLY_1
create Bell, BELL_ASSEMBLY_2
create Bell, BELL_ASSEMBLY_3
create Bell, BELL_BASIC
create Bell, BELL_CHAPEL
create Bell, BELL_EXTENDED_1_1357
create Bell, BELL_EXTENDED_1_2468
create Bell, BELL_EXTENDED_2_7153
create Bell, BELL_EXTENDED_2_8264
create Bell, BELL_EXTENDED_3_3751
create Bell, BELL_EXTENDED_3_4862
create Bell, BELL_SPECIAL_CONVOCATION
create Bell, BELL_SPECIAL_FAIR_DAY
create Bell, BELL_SPECIAL_MAY_DAY
create Bell, BELL_VARIETY_ATHLETIC_ASSEMBLY
create Bell, BELL_CHAPEL_MOVING_UP

create Cycle, CYCLE_1
create Cycle, CYCLE_3
create Cycle, CYCLE_7

create Period, PERIOD_HOME_ROOM
create Period, PERIOD_1
create Period, PERIOD_2
create Period, PERIOD_3
create Period, PERIOD_4
create Period, PERIOD_5
create Period, PERIOD_6
create Period, PERIOD_7
create Period, PERIOD_8
create Period, PERIOD_ASSEMBLY
create Period, PERIOD_CHAPEL
create Period, PERIOD_LUNCH
create Period, PERIOD_MEETING
create Period, PERIOD_CONVOCATION
create Period, PERIOD_CEREMONY


