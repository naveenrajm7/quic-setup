"""# The profile for experimenting with QUIC protocol  
The profile has two nodes: *server* and *client*  
The Execute script install required packages for ngtcp2 and nghttp3 libraries

Instructions:
After the experiment is instatiated, 
Get ngtcp2 and nghttp3 libraries and start running example server from server node,
and example client from client node.
"""


# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()
 
# Add a raw PC to the request.
server = request.RawPC("server")
server.routable_control_ip = True

client = request.RawPC("client")
client.routable_control_ip = True

# Request that a specific image be installed on this node
server.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD"
server.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD"

# Create a link between them
link1 = request.Link(members = [server,client])

# Install and execute a script that is contained in the repository.
server.addService(pg.Execute(shell="sh", command="/local/repository/scripts/install-deps.sh"))
client.addService(pg.Execute(shell="sh", command="/local/repository/scripts/install-deps.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)