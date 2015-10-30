

SCHEDULER.every '5s', first_in: '1s' do
	memory_stats = %x(free).split(" ")
	result_in_percent = Integer(memory_stats[8])/Integer(memory_stats[7])
	#send_event('abc', {min: 0})
	send_event('abc', {value: memory_stats[8]})
	send_event('abc', {max: Integer(memory_stats[7])})

#	send_event('memory', {value: Integer(memory_stats[8])})
#	send_event("memory", {max: Integer(memory_stats[7])})
end




