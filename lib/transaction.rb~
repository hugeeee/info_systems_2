class Transaction

attr_accessor :operations, :name, :id, :status, :intent_locks, :next_operation, 
							:actual_tick, :locks_applied, :locks_removed
	
	def initialize id, ticks, actual_tick
		@id = id
		@ticks = ticks
		@actual_tick = actual_tick
		@intent_locks = []

		@locks_applied = false
		@locks_removed = false
		
		@intent_locks_applied = [] # not used

		@status = :elegible
		@operations = []
		@next_operation = 0
	end

	# checks if the transaction is complete
	def transaction_complete?
		if @next_operation + 1 <= @operations.size
			false
		else
			@status = :complete
			true
		end
	end

end
