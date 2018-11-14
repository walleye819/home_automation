require 'rest-client'
require 'json'

auth = "Bearer #{ENV['lifx_token']}"

response = RestClient::Request.execute(method: :get, url: 'https://api.lifx.com/v1/lights/all', headers: {Authorization: auth})

JSON.parse(response.body).each do |light|
	puts "Found light #{light['label']} (#{light['id']}) power is #{light['power']}"
	next if light['label'] == 'Micah 1'
	action = light['power'] == 'on' ? 'off' : 'on'
	puts "turning light #{action}"
	RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/#{light['id']}/state", payload: "power=#{action}", headers: {Authorization: auth})
	puts 'setting brightness to 100%'
	RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/#{light['id']}/state", payload: "brightness=1.0", headers: {Authorization: auth})
end

response = RestClient::Request.execute(method: :get, url: 'https://api.lifx.com/v1/lights/all', headers: {Authorization: auth})

JSON.parse(response.body).each do |light|
	puts "Found light #{light['label']} (#{light['id']}) power is #{light['power']}"
	next if light['label'] == 'Micah 1'
	action = light['power'] == 'on' ? 'off' : 'on'
	puts "turning light #{action}"
	response = RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/#{light['id']}/state", payload: "power=#{action}", headers: {Authorization: auth})
end

