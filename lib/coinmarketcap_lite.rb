#!/usr/bin/env ruby

# file: coinmarketcap_lite.rb

require 'net/http'
require 'uri'


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

    get_request('/map', "symbol" => symbols.map {|x| x.to_s.upcase})

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
