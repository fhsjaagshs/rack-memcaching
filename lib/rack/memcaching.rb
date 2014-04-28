#!/usr/bin/env ruby

require "dalli"
require "json"

module Rack
  class Memcaching
    def initialize(app, opts={})
      @app = app
      @@exclusion_regex = opts[:exclude] || opts["exclude"]

      @@memcached ||= Dalli::Client.new(
        *(opts[:servers] || opts["servers"]),
        :expires_in => opts[:expires_in] || opts["expires_in"],
        :namespace => opts[:namespace] || opts["namespace"],
        :compress => (opts[:compress] || opts["compress"]) || false
      )
    end
 
    def call(env)
      return @app.call(env) unless env["REQUEST_METHOD"] == "GET" && env["PATH_INFO"] =~ @@exclusion_regex
      
      raw_cached = @@memcached.get(env["REQUEST_URI"])
      
      return JSON.parse(raw_cached) unless raw_cached.nil?
      
      res = @app.call(env)
      
      @@memcached.set(env["REQUEST_URI"], res.to_json)
      
      res
    end
  end
end