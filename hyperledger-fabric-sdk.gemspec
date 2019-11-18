Gem::Specification.new do |s|
  s.name          = 'hyperledger-fabric-sdk'
  s.version       = '0.1.0'
  s.date          = '2019-11-12'
  s.summary       = "This SDK enables Ruby developers to interact with hyperledger-fabric"
  s.description   = ""
  s.authors       = ["Alexandr Kirshin(kirshin)", "(qiusugang)", "Bryan Padron(djlazz3)"]
  s.files         = ["lib/hyperledger-fabric-sdk.rb"]
  s.files         += Dir['lib/*.rb']
  s.files         += Dir['lib/**/*.rb']
  s.require_paths = [
    "lib",
    "lib/crypto_suite",
    "lib/fabric",
    "lib/fabric_ca",
    "lib/fabric_ca/faraday_middleware",
    "lib/protos",
    "lib/protos/commmon",
    "lib/protos/discovery",
    "lib/protos/gossip",
    "lib/protos/idemix",
    "lib/protos/ledger",
    "lib/protos/ledger/queryresult",
    "lib/protos/ledger/rwset",
    "lib/protos/ledger/rwset/kvrwset",
    "lib/protos/msp",
    "lib/protos/orderer",
    "lib/protos/peer",
    "lib/protos/transientstore",
  ]
  s.homepage      = 'https://github.com/kirshin/hyperledger-fabric-sdk'
end
