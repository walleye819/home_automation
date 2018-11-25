load 'time_zone.rb'
load 'lifx.rb'
require 'rest-client'
require 'json'

puts 'checking today\'s sunrise and sunset'

tz = TimeZone.new
tz.get_sunrise_sunset(Date.today) 

lifx = Lifx.new
lifx_config = {}
lifx_config['power'] = 'on'
lifx_config['fast'] = 'true'

sunrise = tz.sunrise
sunset = tz.sunset

puts sunrise
puts sunset

all_lights = lifx.get_all_light_ids

while true do
	if Time.now > sunrise && Time.now > sunset
		puts 'new day, checking timezones for tomorrow'
                tz.get_sunrise_sunset(Date.today + 1)

                sunrise = tz.sunrise
                sunset = tz.sunset
                puts sunrise
                puts sunset
	end	
	if Time.now < sunrise
		puts 'it is nighttime'
		lifx_config['power'] = 'on'
		all_lights.each  do |light_id|
			lifx.modify_light(light_id, lifx_config)
                end
	else
		puts 'it is daytime'
                lifx_config['power'] = 'off'
                all_lights.each  do |light_id|
                        lifx.modify_light(light_id, lifx_config)
                end
	end
	sleep 60
end

