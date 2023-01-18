# QUIC setup


## Vagrant Setup

```bash
vagrant up
```

After setup

```bash
# start server
./server --htdocs=${PWD}/root --max-udp-payload-size=1200 localhost 10101 ../ci/cert/server.key ../ci/cert/server.crt
# start client
./client --max-udp-payload-size=1200 localhost 10101 "https://localhost:10101/test.txt"
```

## CloudLab setup

[profile](profile.py)