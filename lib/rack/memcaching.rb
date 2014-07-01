#!/usr/bin/env ruby

require "rack"
require "dalli"
require "json"
require "access_stack"

module Rack
  class Memcaching
    def initialize(app, params={})
			opts = Hash[params.map{ |k,v| [k.to_sym, v] }]
			
      @app = app
      @@exclude = opts[:exclude] || []
			@@expires = opts[:expires] || 5
			@@ttl = opts[:ttl] || 0
			@@compress = opts[:compress] || false
			@@namespace = opts[:namespace] || ""
			@@servers = opts[:servers] || ["localhost:11211"]
			
			# Just in case :exclude is a single rule
			@@exclude = [@@exclude] unless Array === @@exclude
    end
		
		def mc_stack
			@@mc_stack ||= AccessStack.new(
				:size => 10,
				:timeout => 3, # how long to wait for access to the stack
				:expires => @@expires, # how long an object lasts in the stack
				:create => lambda {
					Dalli::Client.new(
						*@@servers,
						:expires_in => @ttl,
						:namespace => @@namespace,
						:compress => @@compress
					)
				},
				:destroy => lambda { |m| m.close }
			)
		end
 
    def call(env)
			req = Rack::Request.new env
			
			return @app.call env unless req.get?

			exclude = @@exclude.map { |obj|
				return !(obj.match(req.path_info).nil?) if Regexp === obj
				return obj == req.path_info if String === obj
			}.any?
			
			return @app.call env if exclude

      cached = mc_stack.with { |m| m.get req.fullpath }
      return JSON.parse cached unless cached.nil?
      
      res = @app.call env
      
			mc_stack.with { |m| m.set req.fullpath, res.to_json }
      
      res
    end
  end
end