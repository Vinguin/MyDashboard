require 'rubygems'
require 'mechanize'
require 'open-uri'

#Lesedaten ein.
SCHEDULER.every '30m', first_in: '1s' do
	agent = Mechanize.new
	agent.get("http://www.did-you-knows.com")
	form = agent.page.parser.css('span.dykText')
	content_array = []

	form.each do |line|
		content_array << line.content
	end 
end


SCHEDULER.every '30m', first_in: '1s' do
	idx = 0
	send_event('welcome', {text: "Did you know that... "+ content_array[0	] +"?"})
end
