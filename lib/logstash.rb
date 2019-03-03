class LoggerIO
	def initialize()
		@logger = LogStashLogger.new(type: :tcp, host:'listener.logz.io', port:5050)
        end

	def log_and_puts(string)
  		puts(string)
  		@logger.info(string)
	end
end
