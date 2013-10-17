require 'uri'

class Params
  def initialize(req, route_params)
    @req = req
    @route_params = route_params
    @params = {}
    # 1) query string params
    if @req.query_string
      @params = parse_www_encoded_form(@req.query_string)
    end

    # 2) request body params
    if @req.body
      @params = parse_www_encoded_form(@req.body)
    end

    # 3) route params
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    nested = {}
    keys = []
    values = []

    params = URI.decode_www_form(www_encoded_form)
    params.each do |key_arr, value|
      keys += parse_key(key_arr)
      values << value
    end
    keys = keys.uniq!.reverse
    values = values.reverse

    keys.each_with_index do |key, index|
      if !values.empty?
        nested[key] = values.shift
      else
        nested = Hash[key, nested]
      end
    end

    nested
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
