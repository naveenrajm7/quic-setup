

### Client packages


## To run old chromium headless 
# Install xvfb
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb

## Chrome HAR capturer for PLT tests
# Install npm 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y npm
# Install chrome-har-capturer npm package in global scope
sudo npm install -g chrome-har-capturer