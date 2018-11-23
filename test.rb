require 'rest-client'
require 'json'

lat = 45.1280895
lng = -93.3494784

puts 'checking today\'s sunrise and sunset'

json = RestClient::Request.execute(method: :get, url: "https://api.sunrise-sunset.org/json?lat=#{lat}&lng=#{lng}")
response = JSON.parse(json)

sunrise =  Time.parse("#{response['results']['sunrise']} UTC").localtime
sunset = Time.parse("#{response['results']['sunset']} UTC").localtime

if Time.now < sunrise && Time.now < sunset
	puts 'it appears to be after sunset, checking tomorrow\'s sunrise and sunset'
	json = RestClient::Request.execute(method: :get, url: "https://api.sunrise-sunset.org/json?lat=#{lat}&lng=#{lng}&date=tomorrow")
	response = JSON.parse(json)
	sunrise =  Time.parse("#{response['results']['sunrise']} UTC").localtime
	sunset = Time.parse("#{response['results']['sunset']} UTC").localtime
end

puts sunrise
puts sunset

auth = "Bearer #{ENV['lifx_token']}"

while true do
	if Time.now < sunrise
		puts 'it is nighttime'
	elsif Time.now < sunset
		puts 'it is daytime'
		RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'on', fast: 'true'}, headers: {Authorization: auth})
                sleep 1
                RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'off', fast: 'true'}, headers: {Authorization: auth})
	else
		puts 'new day, checking timezones'	
		json = RestClient::Request.execute(method: :get, url: "https://api.sunrise-sunset.org/json?lat=#{lat}&lng=#{lng}&date=tomorrow")
		response = JSON.parse(json)
		sunrise =  Time.parse("#{response['results']['sunrise']} UTC").localtime
		sunset = Time.parse("#{response['results']['sunset']} UTC").localtime
	end
	sleep 10
end


return
1000.times do
	puts 'turning light off'	
	RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'off', fast: 'true'}, headers: {Authorization: auth})
	puts 'turning light on'	
	RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'on', fast: 'true'}, headers: {Authorization: auth})
end

