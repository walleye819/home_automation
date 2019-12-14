class Lifx
	def initialize
		token = ENV['lifx_token']
		abort 'lifx_token environment variable not found, exiting now!' if token.nil?
		@auth = "Bearer #{token}"
		@lifx_url = "https://api.lifx.com/v1/lights/"	
	end

	def modify_light(id, config)
		payload = {}
		payload['power'] = config['power'] unless config['power'].nil?
		payload['fast'] = config['fast'] unless config['fast'].nil?
		payload['color'] = config['color'] unless config['color'].nil?
		api_call('put', "#{id}/state", payload)
	end

	def get_all_light_ids
		response = api_call('get', 'all')
		return if response.nil?	
		array =	JSON.parse(response.body)
		print(array)
		array.map! {|light| light['id']}
	end

	def get_all_lights_detailed
		response = api_call('get', 'all')
		return if response.nil?
		array = JSON.parse(response.body)
		new_array = []
		array.each do |light|
			l = {}
			l['id'] = light['id']
			l['group'] = light['group']['name']
			new_array << l
		end
		return new_array		
	end

	private

	def rest_client 
		 RestClient::Resource.new("#{@lifx_url}" , headers: {Authorization: @auth})
	end

	def api_call(action, path, payload = nil)
		begin
			if payload
				response = rest_client[path].send(action, payload)
			else
				response = rest_client[path].send(action)
			end
		rescue RestClient::ExceptionWithResponse, SocketError, Errno::ECONNREFUSED, Timeout::Error  => err
			puts("Found and handled exception in lifx.rb when calling API: #{err}")
		rescue => err
			abort("Unhandled exception found in lifx.rb when calling API: #{err}")
		end
		response
	end
end
