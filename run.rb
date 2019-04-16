load 'lib/time_zone.rb'
load 'lib/lifx.rb'
load 'lib/logstash.rb'
load 'application.rb'

require 'rest-client'
require 'json'

def log_times
	@logger.log_and_puts("Current time: #{Time.now.utc}")
	@logger.log_and_puts("Sunrise: #{@tz.sunrise.utc}")
	@logger.log_and_puts("Sunset: #{@tz.sunset.utc}")
end

def plus_minus_sunset_sunrise
	plus_minus = 1800
	@tz.sunrise = @tz.sunrise + plus_minus
	@tz.sunset = @tz.sunset - plus_minus
end

@logger = LoggerIO.new

@logger.log_and_puts('checking today\'s sunrise and sunset')

lifx = Lifx.new
lifx_config = {}
lifx_config['power'] = 'on'
lifx_config['fast'] = 'true'

@logger.log_and_puts('getting list of lifx lights')

all_lights = lifx.get_all_light_ids

abort('no lights found!') if all_lights.nil?

@logger.log_and_puts("Found list of lights: #{all_lights.join(', ')}")

while true do
	if @tz.nil?
		@logger.log_and_puts('checking timezones')	
		@tz = TimeZone.new
		@tz.get_sunrise_sunset(Date.today)
		plus_minus_sunset_sunrise	
	end
	if (Time.now.utc > @tz.sunrise.utc && Time.now.utc > @tz.sunset.utc)
		@logger.log_and_puts('new day, checking timezones for tomorrow')
                @tz.get_proper_sunrise_sunset
        	plus_minus_sunset_sunrise        
	end
	log_times
	if Time.now.utc < @tz.sunrise.utc
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

