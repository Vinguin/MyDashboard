
name = "Vinh"

# Diese Methode gibt zu einer Zeit eine passende Begrüßung.
def getGreet(hour)
	return case hour
	when 0..7
		"It's still night"
	when 7..12
		"Good morning"
	when 12..17
		"Good afternoon"
	when 17..21
		"Good evening"
	when 21..22
		"It's bedtime soon"
	when 22..24
		"Go sleep"
	else
		"Eh... Hey"
	end
end

SCHEDULER.every '30s', first_in: '1s' do
	time = Time.new
	currenthour = time.hour
	greetmsg = getGreet(currenthour)+ ", "+ name+ "!"
	send_event("welcome", {title: greetmsg})
end


