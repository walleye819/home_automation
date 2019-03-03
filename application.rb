require 'logstash-logger'
config = LogStashLogger.configure do |config|
	config.customize_event do |event|
        	event["token"] = ENV['log_token']
                abort 'log_token environment variable not found, exiting now!' if event["token"].nil?
        end
end
