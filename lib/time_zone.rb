class TimeZone
	attr_accessor :sunrise, :sunset

	def initialize
		@latitude = 45.1280895
		@longitude = -93.3494784
		@sunrise = nil	
		@sunset = nil
	end

	def get_proper_sunrise_sunset
		date = Date.today
		get_sunrise_sunset(date)
		x = 1
		while Time.now.utc > @sunrise && Time.now.utc > @sunset
			get_sunrise_sunset(date + x)
			x += 1
		end	
	end

	def get_sunrise_sunset(date)
		url = "https://api.sunrise-sunset.org/json?lat=#{@latitude}&lng=#{@longitude}&date=#{date}&formatted=0"
		puts url
		json = RestClient::Request.execute(method: :get, url: url)
		response = JSON.parse(json)
		@sunrise = Time.parse(response['results']['sunrise'])
		@sunset = Time.parse(response['results']['sunset'])
	end
end
