require './script_reader.rb'

script = ScriptReader.new "script.txt"

script.read_file

puts script.transactions.size
