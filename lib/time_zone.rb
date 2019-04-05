class TimeZone
	def initialize
		@latitude = 45.1280895
		@longitude = -93.3494784
		@sunrise = nil	
		@sunset = nil
	end

	def get_sunrise_sunset(date = Date.today)
		url = "https://api.sunrise-sunset.org/json?lat=#{@latitude}&lng=#{@longitude}&date=#{date}&formatted=0"
		puts url
		json = RestClient::Request.execute(method: :get, url: url)
		response = JSON.parse(json)
		puts response
		# @sunrise =  Time.parse("#{date} #{response['results']['sunrise']} UTC")
		@sunrise = Time.parse(response['results']['sunrise'])
		# @sunset = Time.parse("#{date + 1} #{response['results']['sunset']} UTC")
		@sunset = Time.parse(response['results']['sunset'])
		puts @sunrise
		puts @sunset
	end

	def sunrise
		@sunrise
	end

	def sunset
		@sunset
	end
end
