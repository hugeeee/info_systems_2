def request_lock transaction
	r_locks = @record_locks.clone	

	transaction.intent_locks.each do |element|

		if @record_locks[element.baseset].empty?
			@record_locks[element.baseset] << element.lock_type
			puts "Adding #{element.lock_type}"
			transaction.status = :running
		else
			r_locks[element.baseset].each do |e|
				if @lock_matrix[element.lock_type][e] # checks if lock can be applied
					@record_locks[element.baseset] << element.lock_type
					puts "Adding #{element.lock_type}"
					# TODO Something here
					transaction.status = :running
				else
					transaction.status = :elegible
					return false
				end	# end of if
			end	# end of each
		end # end of else
	end	# end of each
	
	return true

end
