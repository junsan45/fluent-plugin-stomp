module Fluent
	class ActivemqOutput < BufferedOutput
		Plugin.register_output("stomp", self)

		# First connect is to host1
		config_param :host1, :string, :default => nil
		config_param :port1, :integer, :default => 61612
		config_param :ssl1, :bool, :default => true
		config_param :user1, :string, :default => "guest"
		config_param :pass1, :string, :default => "guest"

		# First failover connect to host2
		config_param :host2, :string, :default => nil
		config_param :port2, :integer, :default => 61613
		config_param :ssl2, :bool, :default => false
		config_param :user2, :string, :default => "guest"
		config_param :pass2, :string, :default => "guest"

		config_param :queue_name, :string, :default => nil

		# other config for activemq (optional)
		config_param :reliable, :bool, :default => true                     # reliable (use failover)  
		config_param :initial_reconnect_delay, :float, :default => "0.01f"  # initial delay before reconnect (secs)
		config_param :max_reconnect_delay, :float, :default => "30.0"       # max delay before reconnect
		config_param :use_exponential_back_off, :bool, :default => true     # increase delay between reconnect attempts
		config_param :back_off_multiplier, :integer, :default => 2          # next delay multiplier
		config_param :max_reconnect_attempts, :integer, :default => 0       # retry forever, use # for maximum attempts
		config_param :randomize, :bool, :default => false                   # do not randomize hosts hash before reconnect
		config_param :connect_timeout, :integer, :default => 0              # timeout for tcp/tls connects, use # for max seconds
		config_param :parse_timeout, :integer, :default => 5                # receive / read timeout, secs
		config_param :logger, :string, :default => nil                      # user suplied callback logger instance
		config_param :dmh, :bool, :default => false                         # do not support multihomed IPV4/IPV6 hosts during failover
		config_param :closed_check, :bool, :default => true                 # check first if closed in each protocol method
		config_param :hbser, :bool, :default => false                       # raise on heartbeat send exception
		config_param :stompconn, :bool, :default => false                   # use stomp instead of connect
		config_param :usecrlf, :bool, :default => false                     # use crlf command and header line ends (1.2+)

		def initialize
			super
			require "stomp"
		end

		def configure(conf)
			super
			@conf = conf
			unless @host1 && @queue_name
				raise ConfigError, "'host1', 'queue_name'  must be specified."
			end
			
			@hash = {
					:hosts => [
						{:login => @user1, :passcode => @pass1, :host => @host1, :port => @port1, :ssl => @ssl1},
						{:login => @user2, :passcode => @pass2, :host => @host2, :port => @prot2, :ssl => @ssl2},
					],

					:reliable => @reliable
					:initial_reconnect_delay => @initial_reconnect_delay
					:max_reconnect_delay => @max_reconnect_delay 
					:use_exponential_back_off => @use_exponential_back_off
					:back_off_multiplier => @back_off_multiplier
					:max_reconnect_attempts => @max_reconnect_attempts
					:randomize => @randomize
					:connect_timeout => @connect_timeout
					:connect_headers => @connect_headers
					:parse_timeout => @parse_timeout
					:logger => @logger
					:dmh => @dmh
					:closed_check => @closed_check
					:hbser => @hbser
					:stompconn => @stompconn
					:usecrlf => @usecrlf
			}
		end

		def start
			super
			@client = Stormp::Client.new(@hash)
	  end 	
		
    def shutdown
			super
		end

		def format(tag, time, record)
			record.to_msgpack
		end

		def write(chunk)
			chunk.msgpack_each do |data|
				@client.publish(:destination => @queue_name, data)
			end
		end
	end
end