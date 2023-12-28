

### Client packages


## To run old chromium headless 
# Install xvfb
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb

## Chrome HAR capturer for PLT tests
# Install npm 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y npm
# Install chrome-har-capturer npm package in global scope 
# choose capture version based on QUIC_VERSION.
# Since, we use different browser versions for different QUIC_VERSIONs
if [ "$QUIC_VERSION" = "RFCv1" ]; then
    sudo npm install -g chrome-har-capturer
else
    sudo npm install -g chrome-har-capturer@0.9.5
fi