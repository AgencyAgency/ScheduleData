require "csv"
DATA_DIR="data"
# DATA_FILE="#{DATA_DIR}/faculty 2013-2014 Cycles and Schedules 112213.txt"
DATA_FILE="#{DATA_DIR}/converted.txt"
options = { col_sep: "\t",
            quote_char: "~" }
parsed_file = CSV.read(DATA_FILE, options)
parsed_file.each do |line|
  p line
end 