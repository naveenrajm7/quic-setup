


### Client packages

# Dependecies for running chromium ( After binary is available )
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y gperf
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev

## Chrome HAR capturer for PLT tests
# Install npm 
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y npm
# Install chrome-har-capturer npm package in global scope
sudo npm install -g chrome-har-capturer