class Transaction

attr_accessor :operations, :name, :id, :status, :intent_locks, :next_operation, :actual_tick, :locks_applied
	
	def initialize ticks, actual_tick
		@ticks = ticks
		@actual_tick = actual_tick
		@intent_locks = []

		@locks_applied = false

		@status = :elegible		# FAULTY RUNNING ELEGIBLE AND COMPLETE
		@operations = []
		@next_operation = 0
	end

	def transaction_complete?
		if @next_operation + 1 <= @operations.size
			false
		else
			@status = :complete
			puts "Transaction is complete"
			true
		end
			
	end
end
