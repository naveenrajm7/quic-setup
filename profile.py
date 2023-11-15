"""# The profile for experimenting with QUIC protocol  
The profile has two nodes: **server** and **client** 
The Execute script install required packages for ngtcp2 and nghttp3 libraries

Instructions:
After the experiment is instatiated, 
Start running example server from server node,
and example client from client node.
"""


# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the emulab extensions library. (BridgedLink)
import geni.rspec.emulab as emulab

# Create a portal context, needed to defined parameters
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

# Describe the parameter(s) this profile script can accept.
pc.defineParameter( "do_compile", "Do you want to compile your code", portal.ParameterType.BOOLEAN, False )
pc.defineParameter( "proto_quic_path", "Specify the path to proto-quic source code", portal.ParameterType.STRING, "/proj/FEC-HTTP/" )
pc.defineParameter( "quic_version", "Specify the quic version to setup (Q037, RFCv1, RFCv2)", portal.ParameterType.STRING, "RFCv1" )
pc.defineParameter( "project", "Specify the emulab project name", portal.ParameterType.STRING, "FEC-HTTP" )

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()

# Check parameter validity.
# Add custom conditions here
pc.verifyParameters()

# Add a raw PC to the request.
server = request.RawPC("server")
# 64GB ECC Memory, Two Intel E5-2630v3 8-Core CPUs at 2.4 GHz (Haswell)
server.hardware_type = 'd710'
# https://docs.emulab.net/advanced-topics.html , Public IP Access
# server.routable_control_ip = True
iface1 = server.addInterface()
# Specify the IPv4 address
iface1.addAddress(pg.IPv4Address("192.168.1.1", "255.255.255.0"))

client = request.RawPC("client")
# 12 GB memory, 2.4 GHz quad-core
client.hardware_type = 'pc3000'
# client.routable_control_ip = True
iface2 = client.addInterface()
# Specify the IPv4 address
iface2.addAddress(pg.IPv4Address("192.168.1.2", "255.255.255.0"))

ubuntu_22 = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD"
ubuntu_18 = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD"
fbsd_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:FBSD132-64-STD"

# Request that a specific image be installed on this node
ubuntu_image = ubuntu_18 if params.quic_version != 'RFCv1' else ubuntu_22
server.disk_image = ubuntu_image
client.disk_image = ubuntu_image

# Create the bridged link between the two nodes.
link = request.BridgedLink("link")
# link.bridge.hardware_type = NODETYPE
# Add the interfaces we created above.
link.addInterface(iface1)
link.addInterface(iface2)

link.bridge.disk_image = fbsd_image

# Give bridge some shaping parameters. (Implict parameter found in real link)
# link.bandwidth = 10000
# link.latency   = 36  # Implicit latency in live network link (IMC'17)

# pass variable to script
project = params.project
# Install and execute a script that is contained in the repository.
server.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))
client.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))

# Install specific packages
server.addService(pg.Execute(shell="sh", command="/local/repository/scripts/install-apache.sh"))
client.addService(pg.Execute(shell="sh", command="/local/repository/scripts/install-client.sh"))

# Take action based on the user parameter
if params.do_compile: 
    # compile only once since it is shared file path
    server.addService(pg.Execute(shell="sh", command="/local/repository/scripts/compile-quic.sh " + params.src_path ))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)