require 'rubygems'
require 'mechanize'
require 'open-uri'

#Lege Daten hier ab.
content_array = []

#Lese Daten ein.
SCHEDULER.every '60m', first_in: '1s' do
	content_array = parseFacts()
end

SCHEDULER.every '30s', first_in: '1s' do
	rand_idx = rand((content_array.size-1))
	send_event('welcome', {text: "Did you know that "+content_array[rand_idx].to_s+"?"})
end



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

