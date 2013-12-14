require 'csv'
module ScheduleParser
  def parse_schedule data_file
    options = { col_sep: "\t",
                quote_char: "~" }
    parsed_file = CSV.read(data_file, options)
    parsed_file.each_with_index do |line, i|
      if block_given?
        stop = yield(line, i)
      end
      break if stop
    end 
  end

  def hash_schedule data_file
    schedule = []
    options = { headers: true, 
                header_converters: :symbol,
                converters: :all,
                col_sep: "\t",
                quote_char: "~"
              }
    CSV.foreach(data_file, options) do |row|
      schedule << Hash[row.headers[0..-1].zip(row.fields[0..-1])]
    end
    return schedule
  end
end