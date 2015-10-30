require 'rubygems'
require 'mechanize'
require 'open-uri'


content_array = []

#Lesedaten ein.
SCHEDULER.every '1m', first_in: '1s' do
	agent = Mechanize.new
	agent.get("http://www.did-you-knows.com")
	form = agent.page.parser.css('span.dykText')

	form.each do |line|
		content_array << line.content
	end 
	send_event('welcome', {text: "Did you know that... "+ content_array[0] +"?"})
end

#
# Die DCS die in der Rolle eingesetzt werden müssen eingetragen werden.