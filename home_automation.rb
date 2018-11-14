require 'rest-client'
require 'json'

auth = "Bearer #{ENV['lifx_token']}"

response = RestClient::Request.execute(method: :get, url: 'https://api.lifx.com/v1/lights/all', headers: {Authorization: auth})

puts response.code

JSON.parse(response.body).each do |light|
	puts "Found light #{light['label']} (#{light['id']}) power is #{light['power']}"
	next if light['label'] == 'Micah 1'
	response = RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/#{light['id']}/state", payload: 'power=off', headers: {Authorization: auth})
end

response = RestClient::Request.execute(method: :get, url: 'https://api.lifx.com/v1/lights/all', headers: {Authorization: auth})

JSON.parse(response.body).each do |light|
	puts "Found light #{light['label']} (#{light['id']}) power is #{light['power']}"
	next if light['label'] == 'Micah 1'
	response = RestClient::Request.execute(method: :put, url: "https://api.lifx.com/v1/lights/#{light['id']}/state", payload: 'power=on', headers: {Authorization: auth})
end

