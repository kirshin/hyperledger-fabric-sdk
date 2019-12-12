Gem::Specification.new do |s|
  s.name          = 'hyperledger-fabric-sdk'
  s.version       = '0.2.0'
  s.date          = '2019-11-12'
  s.summary       = "This SDK enables Ruby developers to interact with hyperledger-fabric"
  s.description   = ""
  s.authors       = ["Alexandr Kirshin(kirshin)", "(qiusugang)", "Bryan Padron(djlazz3)"]
  s.add_dependency 'faraday_middleware', '~>0.13'
  s.add_dependency 'faraday', '~>0.17'
  s.add_dependency 'grpc', '~>1.25'
  s.add_dependency 'google-protobuf', '~>3.10'
  s.add_dependency 'digest-sha3', '~>1.1'
  s.add_dependency 'hashie', '~>4.0'
  s.add_development_dependency "bundler", "~> 2.0"
  s.add_development_dependency "rake", "~> 10.0"
  s.files         = ["lib/hyperledger-fabric-sdk.rb"]
  s.files         += Dir['lib/*.rb']
  s.files         += Dir['lib/**/*.rb']
  s.files         << "Gemfile"
  s.files         << "Gemfile.lock"
  s.files         << "LICENSE.txt"
  s.files         << "Rakefile"
  s.require_paths = [
    "lib",
    "lib/fabric",
    "lib/fabric/protos/commmon",
    "lib/fabric/protos/discovery",
    "lib/fabric/protos/gossip",
    "lib/fabric/protos/idemix",
    "lib/fabric/protos/ledger",
    "lib/fabric/protos/ledger/queryresult",
    "lib/fabric/protos/ledger/rwset",
    "lib/fabric/protos/ledger/rwset/kvrwset",
    "lib/fabric/protos/msp",
    "lib/fabric/protos/orderer",
    "lib/fabric/protos/orderer/etcdraft",
    "lib/fabric/protos/peer",
    "lib/fabric/protos/token",
    "lib/fabric/protos/transientstore",
    "lib/fabric/protos/definitions",
    "lib/fabric/protos/definitions/commmon",
    "lib/fabric/protos/definitions/discovery",
    "lib/fabric/protos/definitions/gossip",
    "lib/fabric/protos/definitions/idemix",
    "lib/fabric/protos/definitions/ledger",
    "lib/fabric/protos/definitions/ledger/queryresult",
    "lib/fabric/protos/definitions/ledger/rwset",
    "lib/fabric/protos/definitions/ledger/rwset/kvrwset",
    "lib/fabric/protos/definitions/msp",
    "lib/fabric/protos/definitions/orderer",
    "lib/fabric/protos/definitions/orderer/etcdraft",
    "lib/fabric/protos/definitions/peer",
    "lib/fabric/protos/definitions/token",
    "lib/fabric/protos/definitions/transientstore",
    "lib/fabric_ca",
    "lib/fabric_ca/faraday_middleware"
  ]
  s.homepage = 'https://github.com/kirshin/hyperledger-fabric-sdk'
end
