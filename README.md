# Emulab QUIC profile

This repository contains :

[Emulab profile](profile.py)
The geni-lib script to create topology in Emulab.

[Installation Scripts](scripts/)
The bash scripts to automate package installation after the emulab node are up and running.

[Setup Instructions](emulab-demo.md)
Instructions on how to start the experiment 

>NOTE: Configuring this repo as profile in Emulab will give 
a working setup for conduction QUIC experiments. However,
the workloads, chrome browser, QUIC and TCP server should be manually placed in appropriate path in the respective nodes. Workloads is shared as seperate artifact, browser and server can be obtained from [Chromium](https://www.chromium.org/quic/playing-with-quic/). These were not included in our automation setup script due to the size of the artifacts.