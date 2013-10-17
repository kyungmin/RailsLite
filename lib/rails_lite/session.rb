require 'json'
require 'webrick'

class Session
  def initialize(req)
    @cookie_value = {}
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @cookie_value = JSON.parse(cookie.value)
      end
    end
  end

  def [](key)
    @cookie_value[key]
  end

  def []=(key, val)
    @cookie_value[key] = val
  end

  def store_session(res)
    new_cookie = WEBrick::Cookie.new("_rails_lite_app", @cookie_value.to_json)
    res.cookies << new_cookie
  end
end
