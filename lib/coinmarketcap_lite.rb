#!/usr/bin/env ruby

# file: coinmarketcap_lite.rb

require 'net/http'
require 'uri'
require 'dynarex-password' # used by CoinmarketlitePlus


class CoinmarketcapLite
  
  def initialize(apikey: '', apiurl: 'https://pro-api.coinmarketcap.com', 
                  apibase: '/v1/cryptocurrency')

    @url_base = apiurl + apibase
    @apikey = apikey 

  end

  # symbols = %w(BTC USDT BNB)
  #
  def coins(symbols=[])

    if symbols.any? then
      get_map(symbols)
    else
      get_request('/listings/latest',
                  {"convert" => "USD,BTC", "limit" => "1","start" => "1"})
    end

  end

  def get_historical_price()
  end

  private

  def get_map(symbols=[])

    get_request('/map?symbol=' + symbols.map {|x| x.to_s.upcase}).join(',')

  end

  def get_request(api, data={})

    uri = URI.parse(@url_base + api)

    request = Net::HTTP::Get.new(uri)
    request["X-CMC_PRO_API_KEY"] = @apikey
    request["Accept"] = "application/json"
    request.set_form_data( data )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

  end
end


class CoinmarketcapLitePlus < CoinmarketcapLite
  
  def self.fetch_apikey(reg)

    decipher = ->(lookup_file, s) {
      DynarexPassword.new.reverse_lookup(s, lookup_file)
    }
    
    key = 'hkey_apps/coinmarketcap'
    e = reg.get_key(key)
    lookup_file = e.text('lookup_file').to_s
    
    apikey = decipher.call(lookup_file, e.text('apikey').to_s)
    
  end  
  
  def initialize(reg, debug: false)

    @debug = debug
        
    apikey = CoinmarketcapLitePlus.fetch_apikey(reg)

    super(apikey: apikey)

  end
  
  
end
