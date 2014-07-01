Rack::Memcaching
===

High-performance Memcached caching for Rack.

Install
-

Clone this repo, `cd` into it, then `./build.sh`

Example
-

    require "sinatra"
    require "sinatra/base"
    require "rack/memcaching"

    class MemcachingTest < Sinatra::Base
	    use Rack::Memcaching,
          :servers => ["localhost:11211"],
          :ttl => 1,
          :expires => 6,
          :namespace => "mcing_test",
          :exclude => [/some_regex/, "/path_info/to/exclude"],
          :compress => true
          
        get "/" do
          "Will be cached."
        end
        
        get "/path_info/to/exclude" do
          "Won't be cached."
        end
        
        post "/this/" do
          # handle POST body
          "Never cached."
        end
    end

Parameters
-

**`:servers`** => An array of servers to be used (feeds into `Dalli::Client.new`'s first argument).<br />
**`:expires`** => How many seconds a connection is allowed to remain alive. The default is `5`.<br />
**`:ttl`** => How long cached responses stay in Memcached. The default is `0`, which means forever.<br />
**`:exclude`** => An `Array` of `Regexp`s or `String`s which represent `path_info`s to be excluded from caching
**`:namespace`** => `String`, A namespace for each key in Memcached.<br />
**`:compress`** => `true`/`false`, whether or not to use compression.

How it works
-

`rack/memcaching`...

- Only caches `GET` requests. 
- Stores responses by `Rack::Request#fullpath`
- Stores status code, headers, and body as JSON

If the request is cacheable, `rack/memcaching` will check Memcached for a response.

If it exists, Sinatra/Rails/Whatever will be bypassed. 

Otherwise, The request hits your framework and your framework generates a response, which is then cached `rack/memcaching`.

License
-

We've chosen to use the MIT license, we don't care who uses `rack-memcaching`. It's not a core part of any of our apps beyond performance, so we don't care if another company or individual uses it.

