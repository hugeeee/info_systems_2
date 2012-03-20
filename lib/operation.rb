class Operation

	def initialize record_location, opcode
		@record_location = record_location
		@opcode = opcode.to_sym
	end

	def perform_operation records, log
		if @opcode == :R			# find the record at this location
			records[@record_location]
			log << self
		elsif @opcode == :A
			records[@record_location] += 1	# find the value and add one
			log << self
		elsif @opcode == :S
			records[@record_location] -= 1	# find the value and add one
			log << self
		elsif @opcode == :M
			records[@record_location] *= 2	# find the value and multiply by 2
			log << self
		elsif @opcode == :D
			records[@record_location] /= 2	# find the value and divide by 2 and round off
			log << self
		end
		
	end

	def to_s
		puts "#{@record_location} #{@opcode}"
	end
end
