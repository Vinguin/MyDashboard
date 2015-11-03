require 'rubygems'
require 'mechanize'
require 'open-uri'

#Lege Daten hier ab.
content_array = []


# Lese Daten ein.
SCHEDULER.every '10m', first_in: '1s' do
	content_array = parseFacts()
end

SCHEDULER.every '30s', first_in: '10s' do
	# Begrüßung
	name = "Vinh"
	time = Time.new
	currenthour = time.hour
	greetmsg = getGreet(currenthour)+ ", "+ name+ "!"
	rand_idx = rand((content_array.size-1))
	send_event("welcome", {title: greetmsg, text: "Did you know that "+content_array[rand_idx].to_s+"?"})

	# Random facts
	#send_event('welcome', {text: "Did you know that "+content_array[rand_idx].to_s+"?"})
	send_event("welcome", {moreinfo: content_array.size.to_s + " facts to learn!"})
end


# Lese die Fakten aus dem Netz ein.
def parseFacts()
	$page_begin = 1
	$page_max = 52
	baseurl = "http://www.did-you-knows.com/?page="
	data_container = []
	while $page_begin < $page_max  do
		agent = Mechanize.new
		agent.get(baseurl+$page_begin.to_s)
		form = agent.page.parser.css('span.dykText')
		form.each do |line|
			data_container << line.content
		end
	   	$page_begin +=1
	end 
	return data_container
end

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
