load 'lib/time_zone.rb'
load 'lib/lifx.rb'
load 'lib/logstash.rb'
load 'application.rb'

require 'rest-client'
require 'json'

def time_delay
	60
end

def outside_lights
	['Front', 'Deck', 'Shed', 'Backyard']
end

def outside_light_colors
	['red', 'green']
end

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

@logger.log_and_puts('initial app startup')

@logger.log_and_puts('checking today\'s sunrise and sunset')

lifx = Lifx.new
lifx_config = {}
lifx_config['power'] = 'on'
lifx_config['fast'] = 'true'
lifx_config['color'] = 'kelvin:3500'

@logger.log_and_puts('getting list of lifx lights')

all_lights = lifx.get_all_lights_detailed

abort('no lights found!') if all_lights.nil?

@logger.log_and_puts("Found list of lights: #{all_lights.join(', ')}")

increment = 0

while true do
	start_time = Time.now()
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
		threads = []	
		all_lights.each_with_index  do |light, index|
			threads << Thread.new{
			if outside_lights.include?(light['group'])
				# puts "found outside light"	
				# single color	
				# lifx_config['color'] = outside_light_colors[(index + increment) % outside_light_colors.length()]
				# multiple colors	
				lifx.pulse(light['id'], outside_light_colors[(index + increment) % outside_light_colors.length()], outside_light_colors[(index + increment + 1) % outside_light_colors.length()], 5, 20)
			else
				# puts "found inside light"	
				lifx_config['color'] = 'kelvin:3500'
				lifx.modify_light(light['id'], lifx_config)
			end
			# make sure to disable this before enabling colors
			# lifx.modify_light(light['id'], lifx_config)
               		} 
		end
		threads.each { |thr| thr.join }
	else
		@logger.log_and_puts('it is daytime, turning off all lights')
                lifx_config['power'] = 'off'
                all_lights.each  do |light|
                        lifx.modify_light(light['id'], lifx_config)
                end
	end	
	if increment - 1 == outside_light_colors.length()
		increment = 0
	else
		increment += 1
	end
	@logger.log_and_puts('action completed')
	run_time = Time.now() - start_time
	@logger.log_and_puts('Process took ' + run_time.to_s() + ' seconds, sleeping for ' + (time_delay - run_time).to_s() + ' seconds.')	
	sleep(time_delay - run_time) 
end

