protoc-generate:
	rm -rf grpc/*
	protoc --php_out=grpc/ grpc.proto
	composer dump-autoload

start:
	php bin/hyperf.php start

benchmarking:
	@echo "Starting gRPC benchmark..."
	ghz --insecure --proto grpc.proto --call grpc.hi/sayHello --duration=30s --concurrency=100 --connections=6 0.0.0.0:9503
	@echo "Sleep some seconds before continue..."
	@sleep 15
	@echo "Starting HTTP benchmark..."
	wrk --connections=100 --threads=6 --duration=30s http://0.0.0.0:9501

