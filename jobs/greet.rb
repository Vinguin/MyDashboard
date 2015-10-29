
time = Time.new
hour = time.hour

def getGreet(hour)
	return case hour
	when 0..7
		"It's still night man"
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



send_event("welcome", {title: hour})
