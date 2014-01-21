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

Bell.find_or_create_by_name BELL_ASSEMBLY_1
Bell.find_or_create_by_name BELL_ASSEMBLY_2
Bell.find_or_create_by_name BELL_ASSEMBLY_3
Bell.find_or_create_by_name BELL_BASIC
Bell.find_or_create_by_name BELL_CHAPEL
Bell.find_or_create_by_name BELL_EXTENDED_1_1357
Bell.find_or_create_by_name BELL_EXTENDED_1_2468
Bell.find_or_create_by_name BELL_EXTENDED_2_7153
Bell.find_or_create_by_name BELL_EXTENDED_2_8264
Bell.find_or_create_by_name BELL_EXTENDED_3_3751
Bell.find_or_create_by_name BELL_EXTENDED_3_4862
Bell.find_or_create_by_name BELL_SPECIAL_CONVOCATION
Bell.find_or_create_by_name BELL_SPECIAL_FAIR_DAY
Bell.find_or_create_by_name BELL_SPECIAL_MAY_DAY
Bell.find_or_create_by_name BELL_VARIETY_ATHLETIC_ASSEMBLY
Bell.find_or_create_by_name BELL_CHAPEL_MOVING_UP

Cycle.find_or_create_by_name CYCLE_1
Cycle.find_or_create_by_name CYCLE_3
Cycle.find_or_create_by_name CYCLE_7

Period.find_or_create_by_name PERIOD_HOME_ROOM
Period.find_or_create_by_name PERIOD_1
Period.find_or_create_by_name PERIOD_2
Period.find_or_create_by_name PERIOD_3
Period.find_or_create_by_name PERIOD_4
Period.find_or_create_by_name PERIOD_5
Period.find_or_create_by_name PERIOD_6
Period.find_or_create_by_name PERIOD_7
Period.find_or_create_by_name PERIOD_8
Period.find_or_create_by_name PERIOD_ASSEMBLY
Period.find_or_create_by_name PERIOD_CHAPEL
Period.find_or_create_by_name PERIOD_LUNCH
Period.find_or_create_by_name PERIOD_MEETING
Period.find_or_create_by_name PERIOD_CONVOCATION
Period.find_or_create_by_name PERIOD_CEREMONY