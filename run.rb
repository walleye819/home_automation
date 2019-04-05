load 'lib/time_zone.rb'
load 'lib/lifx.rb'
load 'lib/logstash.rb'
load 'application.rb'

require 'rest-client'
require 'json'

@logger = LoggerIO.new

@logger.log_and_puts('checking today\'s sunrise and sunset')

tz = TimeZone.new
tz.get_sunrise_sunset(Date.today) 

lifx = Lifx.new
lifx_config = {}
lifx_config['power'] = 'on'
lifx_config['fast'] = 'true'

# Modifying so lights turn on 30 minutes
# before sunset and off 30 minutes after sunset
sunrise = tz.sunrise + 1800
sunset = tz.sunset - 1800

@logger.log_and_puts("Current time: #{Time.now.utc}")
@logger.log_and_puts("Sunrise: #{sunrise.utc}")
@logger.log_and_puts("Sunset: #{sunset.utc}")

@logger.log_and_puts('getting list of lifx lights')

all_lights = lifx.get_all_light_ids

abort('no lights found!') if all_lights.nil?

@logger.log_and_puts("Found list of lights: #{all_lights.join(', ')}")

while true do
	if Time.now.utc > sunrise.utc && Time.now.utc > sunset.utc
		@logger.log_and_puts('new day, checking timezones for tomorrow')
                tz.get_sunrise_sunset(Date.today + 1)

                
		# Modifying so lights turn on 30 minutes
		# before sunset and off 30 minutes after sunset
		sunrise = tz.sunrise + 1800
		sunset = tz.sunset - 1800
		@logger.log_and_puts("Current time: #{Time.now.utc}")
		@logger.log_and_puts("Sunrise: #{sunrise.utc}")
		@logger.log_and_puts("Sunset: #{sunset.utc}")	
	end	
	if Time.now.utc < sunrise.utc
		@logger.log_and_puts('it is nighttime, turning on all lights')
		lifx_config['power'] = 'on'
		all_lights.each  do |light_id|
			lifx.modify_light(light_id, lifx_config)
                end
	else
		@logger.log_and_puts('it is daytime, turning off all lights')
                lifx_config['power'] = 'off'
                all_lights.each  do |light_id|
                        lifx.modify_light(light_id, lifx_config)
                end
	end
	@logger.log_and_puts('action completed')
	sleep 60
end

