require 'csv'

def parse_schedule raw_schedule
  options = { col_sep: "\t",
              quote_char: "~" }
  parsed_file = CSV.read(raw_schedule, options)
  parsed_file.each_with_index do |line, i|
    if block_given?
      stop = yield(line, i)
    end
    break if stop
  end 
end

def hash_schedule raw_schedule
  schedule = []
  options = { headers: true, 
              header_converters: :symbol,
              converters: :all,
              col_sep: "\t",
              quote_char: "~"
            }
  CSV.foreach(raw_schedule, options) do |row|
    schedule << Hash[row.headers[0..-1].zip(row.fields[0..-1])]
  end
  return schedule
end