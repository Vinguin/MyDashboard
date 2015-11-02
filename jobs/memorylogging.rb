

SCHEDULER.every '5s', first_in: '1s' do
	memory_stats = %x(free).split(" ")
	result_in_percent = Integer(memory_stats[8])/Integer(memory_stats[7])
	#send_event('abc', {min: 0})
	one_percent_value = Integer(memory_stats[7]).to_f / 100.00
	current_mem_load = Integer(memory_stats[8]).to_f / one_percent_value

	send_event('abc', {value: "#{'%.2f' % current_mem_load}", max: 100} )

#	send_event('memory', {value: Integer(memory_stats[8])})
#	send_event("memory", {max: Integer(memory_stats[7])})
end




