require 'byebug'
require_relative '../../lib/hyperledger-fabric-sdk.rb'

FabricCA.configure do |config|
  config.endpoint = 'https://localhost:7054'
  config.ca_name = 'ca-org1'
  config.connection_opts = { ssl: { verify: false } }
end

Fabric.configure do |config|
  config.crypto_suite = Fabric.crypto_suite
  config.peers = [
    {
      url: "localhost:7051",
      tls_ca_cert: "-----BEGIN CERTIFICATE-----\nMIICVzCCAf2gAwIBAgIQHKCC2Ks5wcgnd7FjzoodXDAKBggqhkjOPQQDAjB2MQsw\nCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy\nYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0GA1UEAxMWdGxz\nY2Eub3JnMS5leGFtcGxlLmNvbTAeFw0xOTExMjQwNjQ3MDBaFw0yOTExMjEwNjQ3\nMDBaMHYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH\nEw1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBvcmcxLmV4YW1wbGUuY29tMR8wHQYD\nVQQDExZ0bHNjYS5vcmcxLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0D\nAQcDQgAESNlXVHNKfBB9Ia6dJoIEDGkcnp11jNcsvb1pWeMhJeze+TS6hAAlG649\nOBdYIafXdQAtmccn0QmK2EAsdIzX6qNtMGswDgYDVR0PAQH/BAQDAgGmMB0GA1Ud\nJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MCkGA1Ud\nDgQiBCA1Xr+JLVmK0raio0NBnVI+i5jmQkP2S9AyslFJXYiKsDAKBggqhkjOPQQD\nAgNIADBFAiEAxUoixZfMefq3qirdxQPvhNegpnOONALxotOACjKKpYkCIEQo7SGf\nsbW+X/2xg9PIhS587PKBIFPfM3Kt6alcPXA0\n-----END CERTIFICATE-----\n",
      grpc_options: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
  config.orderers = [
    {
      url: "localhost:7050",
      tls_ca_cert: "-----BEGIN CERTIFICATE-----\nMIICQzCCAemgAwIBAgIQPciXJNwsYtFYBZDohT1vajAKBggqhkjOPQQDAjBsMQsw\nCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy\nYW5jaXNjbzEUMBIGA1UEChMLZXhhbXBsZS5jb20xGjAYBgNVBAMTEXRsc2NhLmV4\nYW1wbGUuY29tMB4XDTE5MTEyNDA2NDcwMFoXDTI5MTEyMTA2NDcwMFowbDELMAkG\nA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBGcmFu\nY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5leGFt\ncGxlLmNvbTBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABDW5FgGN1XCA32GfDePI\nNoMwj3TrUwrFQ4q8wgFRJnevTBC3z/HrgdYiVddOKswO1q4Y4lv2soDt+fA0wJiz\nw/qjbTBrMA4GA1UdDwEB/wQEAwIBpjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYB\nBQUHAwEwDwYDVR0TAQH/BAUwAwEB/zApBgNVHQ4EIgQgWsTfmy2soL4gR55r++cu\nKzfewzhDJQvdx+foH8qpSVEwCgYIKoZIzj0EAwIDSAAwRQIhAJoTsimyiNK5pzzh\nWog5youW6vZNq/kpVAPJgh3q0ZSHAiBjA3k8L2Mi3jmRgnHFOxFnBitXZdvmqk+f\noYX0B2hG2Q==\n-----END CERTIFICATE-----\n",
      grpc_options: {
        "grpc.ssl_target_name_override": "orderer.example.com"
      }
    }
  ]
  config.event_hubs = [
    {
      url: "localhost:7051",
      tls_ca_cert: "-----BEGIN CERTIFICATE-----\nMIICVzCCAf2gAwIBAgIQHKCC2Ks5wcgnd7FjzoodXDAKBggqhkjOPQQDAjB2MQsw\nCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy\nYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0GA1UEAxMWdGxz\nY2Eub3JnMS5leGFtcGxlLmNvbTAeFw0xOTExMjQwNjQ3MDBaFw0yOTExMjEwNjQ3\nMDBaMHYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH\nEw1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBvcmcxLmV4YW1wbGUuY29tMR8wHQYD\nVQQDExZ0bHNjYS5vcmcxLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0D\nAQcDQgAESNlXVHNKfBB9Ia6dJoIEDGkcnp11jNcsvb1pWeMhJeze+TS6hAAlG649\nOBdYIafXdQAtmccn0QmK2EAsdIzX6qNtMGswDgYDVR0PAQH/BAQDAgGmMB0GA1Ud\nJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MCkGA1Ud\nDgQiBCA1Xr+JLVmK0raio0NBnVI+i5jmQkP2S9AyslFJXYiKsDAKBggqhkjOPQQD\nAgNIADBFAiEAxUoixZfMefq3qirdxQPvhNegpnOONALxotOACjKKpYkCIEQo7SGf\nsbW+X/2xg9PIhS587PKBIFPfM3Kt6alcPXA0\n-----END CERTIFICATE-----\n",
      grpc_options: {
        "grpc.ssl_target_name_override": "peer0.org1.example.com"
      }
    }
  ]
end
