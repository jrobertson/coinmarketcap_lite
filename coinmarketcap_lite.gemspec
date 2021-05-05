Gem::Specification.new do |s|
  s.name = 'coinmarketcap_lite'
  s.version = '0.3.0'
  s.summary = 'Queries the CoinMarketCap API using your API key.' + 
      ' Returns the latest prices for the top 100 coins etc.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/coinmarketcap_lite.rb']
  s.add_runtime_dependency('excon', '~> 0.81', '>=0.81.0')  
  s.add_runtime_dependency('dynarex-password', '~> 0.2', '>=0.2.0')
  s.add_runtime_dependency('remote_dwsregistry', '~> 0.4', '>=0.4.1')
  s.signing_key = '../privatekeys/coinmarketcap_lite.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/coinmarketcap_lite'
end
