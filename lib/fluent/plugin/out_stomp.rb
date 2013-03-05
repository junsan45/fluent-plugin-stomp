# -*- coding: utf-8 -*-

module Fluent
    
    class StompOutput < BufferedOutput

        Plugin.register_output('stomp', self)
    end

    #config_param :port

    def initialize
        super
        #require
    end

    def configure(conf)
        super
    end

    def start
        super

    end

    def shutdown
        super
    end

    def write(chunk)
        data = chunk.read
    end

end
