class TimeZone
	def initialize
		@latitude = 45.1280895
		@longitude = -93.3494784
		@sunrise = nil	
		@sunset = nil
	end

	def get_sunrise_sunset(date = Date.today)
		json = RestClient::Request.execute(method: :get, url: "https://api.sunrise-sunset.org/json?lat=#{@latitude}&lng=#{@longitude}&date=#{date}")
		response = JSON.parse(json)
		# puts response
		@sunrise =  Time.parse("#{date} #{response['results']['sunrise']} UTC").localtime
		@sunset = Time.parse("#{date} #{response['results']['sunset']} UTC").localtime
	end

	def sunrise
		@sunrise
	end

	def sunset
		@sunset
	end
end
