class Lifx
	def initialize
		@auth = "Bearer #{ENV['lifx_token']}"
		@lifx_url = "https://api.lifx.com/v1/lights/"	
	end

	def modify_light(id, config)
		payload = {}
		payload['power'] = config['power'] unless config['power'].nil?
		payload['fast'] = config['fast'] unless config['fast'].nil?
		payload['color'] = config['color'] unless config['color'].nil?
		RestClient::Request.execute(method: :put, url: "#{@lifx_url}#{id}/state", payload: payload, headers: {Authorization: @auth})
	end

	def get_all_light_ids
		response = RestClient::Request.execute(method: :get, url: "#{@lifx_url}all" , headers: {Authorization: @auth})
		array =	JSON.parse(response.body)
		array.map! {|light| light['id']}
		array.reject! {|id| id == 'd073d5324c3d'}
	end
end
