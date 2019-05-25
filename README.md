# Introducing the coinmarketcap_lite gem


Usage:

    require 'json'
    require 'ostruct'
    require 'coinmarketcap_lite'


    cl = CoinmarketcapLite.new(apikey: 'YOUR-API-KEY')

    coins = JSON.parse(cl.coins.body)['data'].map {|x| OpenStruct.new x }

    lines = coins.take(5).map do |coin|
      "%+15s %9.3f" % [coin.name, coin.quote['USD']['price']]
    end

    puts ([(' ' * 19) + 'USD', '-' * 27 ] + lines).join("\n")

Output:

<pre>

                   USD
---------------------------
        Bitcoin  8044.713
       Ethereum   251.380
            XRP     0.386
   Bitcoin Cash   406.351
       Litecoin   101.598

</pre>


## Resources

* coinmarketcap_lite https://rubygems.org/gems/coinmarketcap_lite

coinmarketcap gem crypto cryptocurrency bitcoin
