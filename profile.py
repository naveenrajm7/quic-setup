"""# The dumbbell topology for experimenting with QUIC fairness 

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
# quic_version is used to decide which OS version, chrome-har-capturer version is used.
pc.defineParameter( "quic_version", "Specify the quic version to setup (Q037, RFCv1)", portal.ParameterType.STRING, "RFCv1" )
# project is used to specify the project path to give permissions to apache server.
pc.defineParameter( "project", "Specify the emulab project name", portal.ParameterType.STRING, "FEC-HTTP" )

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()

# Check parameter validity.
# Add custom conditions here
valid_versions = ["Q037", "RFCv1"]
if params.quic_version not in valid_versions:
    error = portal.ParameterError("Invalid quic_version. It should be either 'Q037' or 'RFCv1'.", ['quic_version'])
    pc.reportError(error)

# this function will spit out some nice JSON-formatted exception info on stderr
pc.verifyParameters()

# Add a raw PC to the request.
quic_server = request.RawPC("quic_server")
# d430 -> 64GB ECC Memory, Two Intel E5-2630v3 8-Core CPUs at 2.4 GHz (Haswell)
quic_server.hardware_type = 'd430'
# https://docs.emulab.net/advanced-topics.html , Public IP Access
# server.routable_control_ip = True
iface1 = quic_server.addInterface()
# Specify the IPv4 address
# iface1.addAddress(pg.IPv4Address("192.168.1.2", "255.255.255.0"))

# Add a raw PC to the request.
tcp_server = request.RawPC("tcp_server")
# d430 -> 64GB ECC Memory, Two Intel E5-2630v3 8-Core CPUs at 2.4 GHz (Haswell)
tcp_server.hardware_type = 'd430'
# https://docs.emulab.net/advanced-topics.html , Public IP Access
# server.routable_control_ip = True
iface2 = tcp_server.addInterface()
# Specify the IPv4 address
# iface2.addAddress(pg.IPv4Address("192.168.1.3", "255.255.255.0"))



quic_client = request.RawPC("quic_client")
# d710 -> 12 GB memory, 2.4 GHz quad-core
quic_client.hardware_type = 'd710'
# client.routable_control_ip = True
iface3 = quic_client.addInterface()
# Specify the IPv4 address
# iface3.addAddress(pg.IPv4Address("192.168.2.2", "255.255.255.0"))

tcp_client = request.RawPC("tcp_client")
# d710 -> 12 GB memory, 2.4 GHz quad-core
tcp_client.hardware_type = 'd710'
# client.routable_control_ip = True
iface4 = tcp_client.addInterface()
# Specify the IPv4 address
# iface4.addAddress(pg.IPv4Address("192.168.2.3", "255.255.255.0"))

ubuntu_22 = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD"
ubuntu_18 = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD"
fbsd_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:FBSD132-64-STD"

# Request that a specific image be installed on this node
ubuntu_image = ubuntu_22 if params.quic_version == 'RFCv1' else ubuntu_18
quic_server.disk_image = ubuntu_image
tcp_server.disk_image = ubuntu_image
quic_client.disk_image = ubuntu_image
tcp_client.disk_image = ubuntu_image

# Create the bridged link between the two nodes.
link_bridge = request.Bridge('link_bridge_bridge', 'if1', 'if0')
link_bridge.hardware_type = 'd710'
link_bridge.disk_image = fbsd_image

link_bridge.pipe1.bandwidth = 0
link_bridge.pipe1.latency = 0
link_bridge.pipe1.lossrate = 0.0
link_bridge.pipe0.bandwidth = 0
link_bridge.pipe0.latency = 0
link_bridge.pipe0.lossrate = 0.0

iface5 = link_bridge.iface0
iface6 = link_bridge.iface1

# Link link_bridge_left
link_bridge_left = request.Link('link_bridge_left')
link_bridge_left.Site('undefined')
link_bridge_left.addInterface(iface6)
link_bridge_left.addInterface(iface1)
link_bridge_left.addInterface(iface2)

# Link link_bridge_right
link_bridge_right = request.Link('link_bridge_right')
link_bridge_right.Site('undefined')
link_bridge_right.addInterface(iface5)
link_bridge_right.addInterface(iface3)
link_bridge_right.addInterface(iface4)


# Give bridge some shaping parameters. (Implict parameter found in real link)
# link.bandwidth = 10000
# link.latency   = 36  # Implicit latency in live network link (IMC'17)

# pass variable to script
project = params.project
# Install and execute a script that is contained in the repository.
tcp_server.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))
quic_server.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))
tcp_client.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))
quic_client.addService(pg.Execute(shell="sh", command="export PROJECT="+ project + " QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-deps.sh"))


# Install specific packages
tcp_server.addService(pg.Execute(shell="sh", command="/local/repository/scripts/install-apache.sh"))
tcp_client.addService(pg.Execute(shell="sh", command="export QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-client.sh"))
quic_client.addService(pg.Execute(shell="sh", command="export QUIC_VERSION="+ params.quic_version +" && /local/repository/scripts/install-client.sh"))
link_bridge.addService(pg.Execute(shell="sh", command="/local/repository/scripts/bridge-tunning.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)