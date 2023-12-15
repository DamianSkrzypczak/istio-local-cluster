module github.com/DamianSkrzypczak/envoy-http-example

// the version should >= 1.18
go 1.20

replace github.com/envoyproxy/envoy => github.com/envoyproxy/envoy v1.28.0

require (
	github.com/cncf/xds/go v0.0.0-20231128003011-0fa0005c9caa
	github.com/envoyproxy/envoy v0.0.0-00010101000000-000000000000
	google.golang.org/protobuf v1.31.0
)

require (
	github.com/envoyproxy/protoc-gen-validate v1.0.2 // indirect
	github.com/golang/protobuf v1.5.3 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20230822172742-b8732ec3820d // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20230822172742-b8732ec3820d // indirect
)
