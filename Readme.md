Rack::Memcaching
===

Memcached caching for Rack.

Install
-

Clone this repo, `cd` into it, then `./build.sh`

Usage
-

    require "sinatra"
    require "sinatra/base"
    require "rack/memcaching"

    class MemcachingTest < Sinatra::Base
	    use Rack::Memcaching,
          :servers => ["localhost:11211"],
          :expires_in => 1,
          :namespace => "mcing_test",
          :exclude => /some_regex/
          
        get "/" do
          "some HTML or JSON"
        end
    end
    
All of these parameters mirror the Dalli gem, except `:servers` (just feeds into `Dalli::Client.new`'s first argument) and `:exclude`.

The `:exclude` parameter
-

You can use the `:exclude` parameter to limit which endpoints are cached.

Say you have an endpoint which must return unique results ever time, you can write a regex to exclude it.

How it works
-

Caching only happens for `GET` requests. `Rack::Memcaching` stores all cached responses by `REQUEST_URI` (it includes parameters, so you're good if you're using those).

Whenever `call` is called, `Rack::Memcaching` checks to see if Memcached has a stored response. If not, it calls through to your application and caches the result.

The response's `code`, `headers`, and `body` are serialized into JSON when stored in Memcached.

License
-

We've chosen to use the MIT license, we don't care who uses rack-memcaching. It's not a core part of any of our apps beyond performance, so we don't care if another company or individual uses it.

