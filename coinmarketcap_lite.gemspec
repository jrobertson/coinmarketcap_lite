Gem::Specification.new do |s|
  s.name = 'coinmarketcap_lite'
  s.version = '0.1.0'
  s.summary = 'Queries the CoinMarketCap API using your API key.' + 
      ' Returns the latest prices for the top 100 coins etc.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/coinmarketcap_lite.rb']
  s.signing_key = '../privatekeys/coinmarketcap_lite.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/coinmarketcap_lite'
end
