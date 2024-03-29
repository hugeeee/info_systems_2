require './transaction.rb'

class ScriptReader

	attr_accessor :transactions

	def initialize file
		@file = File.new file
		@transactions = []

		@reading_description = false
		
	end

	def read_file

		while line = @file.gets
			# if the line is empty create a new transaction

			if line_is_empty? line
				if !@transaction.nil?
					@transactions << @transaction					
				end

				@reading_description = true
				next	# skips to the next iteration
			end

			if @reading_description == true # controls description of transaction
				puts "#{line.split[0]} #{line.split[1]} #{line.split[2]}"
				@transaction = Transaction.new line.split[0], line.split[1], line.split[2]
				@reading_description = false
			else # else you add the operations
				@transaction.operations << line
			end

		end
		
	end #TODO: Put the transactions in a list

	# check if the line is empty
	def line_is_empty? line
		check = line.clone

		check.strip!.empty?
	end

end
