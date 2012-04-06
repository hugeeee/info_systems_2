require './transaction.rb'
require './operation.rb'
require './lock.rb'

# check if the line is empty
def line_is_empty? line
	check = line.clone
	check.strip!.empty?
end

@lock_matrix = {
:X => {:X => false, :S => false,:IS => false, :SIX => false,:IX => false, :no_access =>true},
:S => {:X => false, :S => true, :IS => true, :SIX => false, :IX =>false, :no_access=>true},
:IS => {:X => false, :S => true, :IS => true, :SIX => true, :IX =>true, :no_access=>true},
:SIX => {:X => false, :S => false, :IS => true, :SIX => false, :IX =>false, :no_access=>true},
:IX => {:X => false, :S => false, :IS => true, :SIX => false, :IX =>true, :no_access=>true},
:no_access => {:X =>true, :S =>true, :IS =>true, :SIX => true, :IX =>true, :no_access=>true}
}

# checks if the lock requested is allowed, and if so it is applied
def request_lock lock

	if @intent_locks[lock.baseset].empty?
		@intent_locks[lock.baseset] << lock.lock_type
		puts @intent_locks
	else
		cloned_locks = @intent_locks[lock.baseset].clone
		cloned_locks.each do |element|
			puts @lock_matrix[element][lock.lock_type]
			if @lock_matrix[element][lock.lock_type]
				@intent_locks[lock.baseset] << lock.lock_type
			else
				return false
			end
		end
	end

	return true
end

# Rollback
def rollback transaction, db, log_file
	while transaction.next_operation >= 0
		transaction.operations[next_operation].undo db, log_file
		next_operation -= 1
		transaction.status = :eligible
	end
	
end

@db = [] # store records here
for i in 0..1000
	@db[i] = 0
end

# track ticks and id's
@actual_tick = 0
@id = 0
@log_file = []

# this keeps track of the locks on each baseset
@intent_locks = {:A => [], :B => [], :C => [], :D => [], :E => [], :F => [], :G => [], :H => [], :I => [], :J => []}

# this method is to determine which baseset the record being accessed is
def baseset? record
	if record.between?(0, 99)
		:A
	elsif record.between?(100, 199)
		:B
	elsif record.between?(200, 299)
		:C
	elsif record.between?(300, 399)
		:D
	elsif record.between?(400, 499)
		:E
	elsif record.between?(500, 599)
		:F
	elsif record.between?(600, 699)
		:G
	elsif record.between?(700, 799)
		:H
	elsif record.between?(800, 899)
		:I
	elsif record.between?(900, 999)
		:J
	end
end

#################################################################
#### 		Read the script and create transaction instances
################################################################
@file = File.new "../scripts\ 2012/five.txt"
@transactions = []

while line = @file.gets

	if line_is_empty? line
		next	# skips to the next iteration
	end
	
	@actual_tick += line.split[0].to_i

	@transaction = Transaction.new @id, line.split[0], @actual_tick
	@id += 1
	# loop through the line to init locks
	# need to increment as a pair
	i = 0
	while i <= line.split[2].to_i
		temp = Lock.new line.split[i + 3], line.split[i + 4]
		@transaction.intent_locks << temp
		i += 2 # increment by 2 because locks are a defined in pairs
	end

	number_of_operations = line.split[1].to_i

	number_of_operations.times do	
		temp = @file.gets
		# first arg is the location in memory. the second arg is the operation
		operation = Operation.new temp.split[0].to_i, temp.split[1]
		@transaction.operations << operation
	end
	@transactions << @transaction

end
# end of reading transactions

#########################################################
######  Perform clock here
#########################################################
@completed_trans = 0
@completed_operations = 0
@rollbacks_made = 0

for @tick in 0..1000
	
	@transactions.each do |transaction|
		if transaction.actual_tick <= @tick
			
			if !transaction.locks_applied

				transaction.intent_locks.each do |element|
					if request_lock element
						transaction.status = :running
						transaction.locks_applied = true
					else
						transaction.status = :eligible
						transaction.locks_applied = false
						transaction.intent_locks.each do |lock|
							@intent_locks[lock.baseset].delete lock.lock_type
						end
					end
				end
			end
	
			if !transaction.transaction_complete? and transaction.status == :running

				transaction.operations[transaction.next_operation].perform_operation @db, @log_file
				@completed_operations += 1
				transaction.next_operation += 1
			elsif transaction.transaction_complete? and !transaction.locks_removed
				# remove the transactions locks if complete
				@completed_trans += 1
				transaction.intent_locks.each do |lock|
					@intent_locks[lock.baseset].delete lock.lock_type

				end
				transaction.locks_removed = true
			end
		end
	end

	if @transactions.size == @completed_trans
		break
	end

end # end of clock

##############################################################
#####		Print out results
##############################################################

# tick all transactions have been completed
puts "final tick = #{@tick}"

# status of all transactions
@transactions.each do |element|
	puts "transaction #{element.id} status = #{element.status}"
end

puts "operations performed = #{@completed_operations}"

@changed_records = []
@log_file.each do |element|
	if !@changed_records.include? element.record_location
		@changed_records << element.record_location
	end
end

@changed_records.each do |element|
	puts "Record #{element} || value = #{@db[element]}"
end

