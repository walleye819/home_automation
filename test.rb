load 'time_zone.rb'
require 'rest-client'
require 'json'

puts 'checking today\'s sunrise and sunset'

tz = TimeZone.new
tz.get_sunrise_sunset(Date.today) 

sunrise = tz.sunrise
sunset = tz.sunset

puts sunrise
puts sunset

auth = "Bearer #{ENV['lifx_token']}"

while true do
	if Time.now > sunrise && Time.now > sunset
		puts 'new day, checking timezones for tomorrow'
                tz.get_sunrise_sunset(Date.today + 1)

                sunrise = tz.sunrise
                sunset = tz.sunset
                puts sunrise
                puts sunset
	elsif Time.now < sunrise
		puts 'it is nighttime'
                RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'on', fast: 'true', color: 'yellow'}, headers: {Authorization: auth})
                sleep 5
                RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'off', fast: 'true'}, headers: {Authorization: auth})
	else
		puts 'it is daytime'
		RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'on', fast: 'true', color: 'purple'}, headers: {Authorization: auth})
                sleep 5
                RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/d073d5301ba7/state", payload: {power: 'off', fast: 'true'}, headers: {Authorization: auth})
	end
	sleep 5
end

