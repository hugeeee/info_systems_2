class Lock

attr_accessor :baseset, :lock_type

	def initialize baseset, lock_type
		@baseset = baseset.to_sym
		@lock_type = lock_type.to_sym
	end

	# debugging purposes
	def to_s
		puts "Baseset = #{@baseset} : Lock_type = #{@lock_type}"
	end

end
