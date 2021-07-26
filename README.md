### Introdução

Este é teste para verificar a performance do servidor HTTP vs gRPC do Hyperf

### Requisitos

- [Protocol Buffer Compiler Installation](https://grpc.io/docs/protoc-installation/)
- [wrk - a HTTP benchmarking tool](https://github.com/wg/wrk)
- [gRPC benchmarking and load testing tool](https://github.com/bojand/ghz)

### Projeto 

- O `proto file` está na raiz do projeto em `grpc.proto`
- Para gerar os arquivos em PHP a partir do `proto file` use `make protoc-generate`
- No arquivo `config/autoload/server.php` temos os dois servidores, o `http` e o `grpc`, as configurações básicas estão lá. 
- Para iniciar os dois servidores utilize: `make start`
- Para rodar o benchmarking utilize: `make benchmarking`

### Benchmark

#### HTTP
```
wrk --connections=100 --threads=6 --duration=10s http://0.0.0.0:9501
```

```
Running 10s test @ http://0.0.0.0:9501
  6 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.11ms  316.40us  21.58ms   95.79%
    Req/Sec    14.46k     0.86k   15.26k    86.67%
  863296 requests in 10.00s, 156.43MB read
Requests/sec:  86323.13
Transfer/sec:     15.64MB
```

#### gRPC 

```
ghz --insecure --proto grpc.proto --call grpc.hi/sayHello --duration=10s --concurrency=100 --connections=6 0.0.0.0:9503
```

```
Summary:
  Count:	779850
  Total:	30.00 s
  Slowest:	144.59 ms
  Fastest:	0.46 ms
  Average:	3.80 ms
  Requests/sec:	25995.00

Response time histogram:
  0.457 [1]	|
  14.870 [769705]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  29.284 [4794]	|
  43.698 [2394]	|
  58.111 [1523]	|
  72.525 [783]	|
  86.939 [375]	|
  101.352 [110]	|
  115.766 [23]	|
  130.180 [26]	|
  144.594 [16]	|

Latency distribution:
  10 % in 2.78 ms
  25 % in 2.96 ms
  50 % in 3.22 ms
  75 % in 3.55 ms
  90 % in 4.06 ms
  95 % in 4.71 ms
  99 % in 23.20 ms

Status code distribution:
  [Unavailable]   100 responses
  [OK]            779750 responses

Error distribution:
  [100]   rpc error: code = Unavailable desc = transport is closing
```

