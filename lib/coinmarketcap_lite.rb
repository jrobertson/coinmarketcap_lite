#!/usr/bin/env ruby

# file: coinmarketcap_lite.rb


require 'excon'
require 'did_you_mean'
require 'dynarex-password' # used by CoinmarketlitePlus
require 'remote_dwsregistry'

# see Coinmarketcap API documentation at
#      https://coinmarketcap.com/api/documentation/v1


class CoinmarketcapLiteException < Exception
end

class CoinmarketcapLite
  using ColouredText
  
  def initialize(apikey: '', apiurl: 'https://pro-api.coinmarketcap.com', 
                  apibase: '/v1/cryptocurrency', filepath: '.', dym: true)

    @url_base = apiurl + apibase
    @apikey = apikey
    @filepath = filepath
    
    file = 'coinmarketlite.dat'
    if File.exists? file then
      
      File.open(File.join(@filepath, file)) do |f|  
        @list = Marshal.load(f)  
      end
        
    else

      r = get_map()
      puts 'r: ' +r.inspect[0..2000]
      #exit
      @list = r['data']

      File.open(File.join(@filepath, file), 'w+') do |f|  
        Marshal.dump(@list, f)  
      end      

    end
    
    if dym then

      puts 'loading did_you_mean ...'.info if @debug          

      @dym = DidYouMean::SpellChecker.new(dictionary: @list.flat_map \
                {|x| [x['symbol'], x['name']]})
    end    

  end

  # symbols = %w(BTC USDT BNB)
  #
  def coins(symbols=[])

    if symbols.any? then
      get_map(symbols)
    else
      # return the top 100 coins latest prices
      api_call('/listings/latest',
                  {"convert" => "USD,BTC", "limit" => "1","start" => "1"})
    end

  end
  
  def find_coin(coin_name)

    #return coin_name unless @autofind

    s = coin_name.to_s.downcase
    puts 's: ' + s.inspect if @debug
    r = @list.find {|coin| coin['symbol'].downcase == s || coin['name'].downcase == s}
    puts 'r: ' + r.inspect if @debug
    
    if r.nil? then

      if @dym then

        suggestion = @dym.correct coin_name
        raise CoinmarketcapLiteException, "unknown coin or token name. \n"  \
            + "Did you mean %s?" % [suggestion.first]

      else

        raise CoinmarketcapLiteException, "unknown coin or token name."

      end

    end

    r

  end

  def find_id(name)
    r = find_coin(name)
    r['id']
  end  
  
  def find_name(s)
    r = find_coin s
    r['name']
  end  

  def get_historical_price()
  end
  
  def prices(coins=[])
    a = quotes(coins)
  end
  
  def quotes(coins=[])
    
    coins = [coins] if coins.is_a? String
    ids = coins.map {|x| find_id(x)}
    api_call '/quotes/latest?id=' + ids.compact.join(',')    
  end

  private

  # returns the coin mapping info (i.e. symbol, slug, name etc.)
  #
  def get_map(symbols=[])
    return get_request('/map') if symbols.empty?
    api_call('/map?symbol=' + symbols.map {|x| x.to_s.upcase}).join(',')

  end

  def api_call(api, data={})
    
    url = @url_base + api
    h = {}
    h["X-CMC_PRO_API_KEY"] = @apikey
    h["Accept"] = "application/json"
    connection = Excon.new(url, :headers => h)
    r = connection.request(:method => 'GET')
    #return r
    return JSON.parse(r.body)    

  end
end


class CoinmarketcapLitePlus < CoinmarketcapLite
  
  def self.fetch_apikey(regx)
    
    reg = if regx.is_a? String then
      RemoteDwsRegistry.new domain: regx
    else
      regx
    end

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
