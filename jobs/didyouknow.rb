require 'rubygems'
require 'mechanize'
require 'open-uri'

#Lege Daten hier ab.
content_array = []

#Lese Daten ein.
SCHEDULER.every '60m', first_in: '1s' do
	agent = Mechanize.new
	agent.get("http://www.did-you-knows.com")
	form = agent.page.parser.css('span.dykText')
	form.each do |line|
		content_array << line.content
	end 
end

SCHEDULER.every '1m', first_in: '1s' do
	rand_idx = rand((content_array.size-1))
	send_event('welcome', {text: "Did you know that "+content_array[rand_idx].to_s+"?"})
end