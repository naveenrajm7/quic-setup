# Emulab Experiment

0. Create profile in Emulab using this git repository  
    0.1 Experiments -> Create Experiment Profile  
    0.2 Give it a name 'quic'  
    0.3 Select project  
    0.4 In 'Source code' , choose 'Git Repo' and point it to this repository.  

1. Instatiate 'quic' Profile to Experiment.  
    Give project and path in parameters section

After experiment is instantiated.

2. Login to nodes  
    5 terminals, 2 server , 2 client. 1 link bridge

3. Check Apache Status

```bash
user@server:/proj/FEC-HTTP/long-quic$ service apache2 status
```

4. Generate SPKI for TCP


```bash
# Get Apache spki 
user@server:/proj/FEC-HTTP/long-quic$ openssl x509 -pubkey < "/etc/ssl/certs/apache-selfsigned.crt" | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 > "apache-selfsigned-spki.txt"

# Get QUIC spki
user@server:/proj/FEC-HTTP/long-quic/long-look-quic/quic/out$ openssl x509 -pubkey < "leaf_cert.pem" | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 > "server_pub_spki.txt"
```


5. TCP Test

Apache Server is always running as system service. 

Client

Terminal 1
```bash
user@client:/proj/FEC-HTTP$ /proj/FEC-HTTP/long-quic/chrome-linux/chrome111  --no-sandbox --headless --disable-gpu --remote-debugging-port=9222  --user-data-dir=/tmp/chrome-profile --enable-benchmarking --enable-net-benchmarking --ignore-certificate-errors-spki-list=$(cat /proj/FEC-HTTP/long-quic/apache-selfsigned-spki.txt)  --no-proxy-server   --disable-quic    --host-resolver-rules='MAP www.example-tcp.org 192.168.1.1'
```

Terminal 2
```bash
user@client:~$ chrome-har-capturer --force --port 9222 -o tcp_index.har https://www.example-tcp.org/
- https://www.example-tcp.org/ ✓
user@client:~$ chrome-har-capturer --force --port 9222 -o tcp_5k.har https://www.example-tcp.org/5k.html
- https://www.example-tcp.org/5k.html ✓
user@client:~$ vim tcp_index.har 
```

6. QUIC Test

Server

```bash
user@server:/proj/FEC-HTTP/long-quic/quiche/bazel-bin/quiche$ ./quic_server --quic_response_cache_dir=/proj/FEC-HTTP/long-quic/long-look-quic/quic/www.example-quic.org   --certificate_file=/proj/FEC-HTTP/long-quic/long-look-quic/quic/out/leaf_cert.pem --key_file=/proj/FEC-HTTP/long-quic/long-look-quic/quic/out/leaf_cert.key
```

> For Debugging --v=1 --stderrthreshold=0

Client

Terminal 1
```bash
user@client:/proj/FEC-HTTP$ /proj/FEC-HTTP/long-quic/chrome-linux/chrome111 --no-sandbox --headless --disable-gpu --remote-debugging-port=9222  --user-data-dir=/tmp/chrome-profile1  --enable-benchmarking --enable-net-benchmarking --ignore-certificate-errors-spki-list=$(cat /proj/FEC-HTTP/long-quic/long-look-quic/quic/out/server_pub_spki.txt)  --no-proxy-server   --enable-quic   --origin-to-force-quic-on=www.example-quic.org:443   --host-resolver-rules='MAP www.example-quic.org:443 192.168.1.1:6121'
```

> For Debugging --enable-logging --v=3

Terminal 2
```bash
user@client:~$ chrome-har-capturer --force --port 9222 -o quic_index.har https://www.example-quic.org/
- https://www.example-quic.org/ ✓
user@client:~$ chrome-har-capturer --force --port 9222 -o quic_5k.har https://www.example-quic.org/5k.html
- https://www.example-quic.org/5k.html ✓
user@client:~$ vim quic_5k.har 
```


> Verify response protocol , status and size in HAR file

7. Experiment

* Start Iperf 

```bash
user@server:/proj/FEC-HTTP/long-quic$ iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------


```

* Start quic server

```bash
user@server:/proj/FEC-HTTP/long-quic/quiche/bazel-bin/quiche$ ./quic_server --quic_response_cache_dir=/proj/FEC-HTTP/long-quic/long-look-quic/quic/www.example-quic.org   --certificate_file=/proj/FEC-HTTP/long-quic/long-look-quic/quic/out/leaf_cert.pem --key_file=/proj/FEC-HTTP/long-quic/long-look-quic/quic/out/leaf_cert.key
```

* Activate python env

```bash
user@client:/proj/FEC-HTTP$ source nenv/bin/activate
(nenv) user@client:/proj/FEC-HTTP$ 
```

* Update Script for defaults

```bash
vim  long-look-quic/test_src/engineWrapper.py
```

* Start experiment

```bash
(nenv) user@client:/proj/FEC-HTTP/long-quic/long-look-quic/test_src$ python engineWrapper.py  --browserPath=/proj/FEC-HTTP/long-quic/chrome-linux/chrome111 --mainDir='/proj/FEC-HTTP/long-quic/long-look-quic/data/demo1' --quic-version=RFCv1 --rounds=1 --networkInt=enp7s0f0 --experiment=demo --rates="10_36_0,50_36_0" --indexes="5k,10k"
```

8. Extracting Results

The experiment will output HAR files for each runs, we have a script which loads all these HAR files , extracts the page load times , subtracts the DNS times and reports the result . Finally computes the average over the total number of runs and produces time for TCP and QUIC.

>Parameters are hardcoded in the script, change them before excuting

```bash
(nenv) user@client:/proj/FEC-HTTP/long-quic/long-look-quic/test_src$ python getTimes.py 
Setting : X_36_0
Object : 5k.html
1.3816038678505005 1.1946499908307662
Performance Difference Statistically Significant
HTTPS:  180.82444999995977
QUIC:  146.52499999960665

Object : 10k.html
1.1461368701626866 1.461937495430736
Performance Difference Statistically Significant
HTTPS:  184.13365000007002
QUIC:  150.07939999932947
....

QUIC Version :  ../data/tcpBBR_quicV1BBRv2/
Setting : X_36_0
Total Runs : 20
TCP Times
     5k.html   10k.html  100k.html  200k.html  500k.html    1mb.html   10mb.html
0  180.82445  184.13365   284.8286  375.68580  640.38365  1055.98375  8616.63475
1  174.20595  175.99035   272.0083  306.43845  365.19035   453.51265  1987.28875
2  174.51155  175.78580   270.7998  305.18360  355.01590   459.12400  1193.18840

['180.82445 184.13365 284.8286 375.68580 640.38365 1055.98375 8616.63475',
 '174.20595 175.99035 272.0083 306.43845 365.19035  453.51265 1987.28875',
 '174.51155 175.78580 270.7998 305.18360 355.01590  459.12400 1193.18840']

QUIC Times
    5k.html   10k.html  100k.html  200k.html  500k.html   1mb.html   10mb.html
0  146.5250  150.07940  228.99785  315.23850  578.76270  991.67750  8605.78995
1  141.9913  143.39385  209.35405  249.34725  311.20360  417.06865  1959.42185
2  142.5145  142.60395  209.19610  249.06035  306.50985  354.72555  1395.88385

['146.5250 150.07940 228.99785 315.23850 578.76270 991.67750 8605.78995',
 '141.9913 143.39385 209.35405 249.34725 311.20360 417.06865 1959.42185',
 '142.5145 142.60395 209.19610 249.06035 306.50985 354.72555 1395.88385']

```

9. Plotting Results 

The TCP and QUIC times produced by the script are pasted into the heatmap ploting script to get the plots
