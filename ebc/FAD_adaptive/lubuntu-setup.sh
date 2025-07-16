#! /bin/bash

# variables
FORTIPOCIP="10.1.1.254"
FORTIPOCDIR="static/docs/latest"
LOGFILE=/tmp/lubuntu-setup-$$.log
LUBUNTUVERSION="`lsb_release -rs`" # Check which Lubuntu version is running.

# functions
function startmsg {
       	echo -n " "$1"...."
}

function endmsg {
       	echo "done"
}

# Populate hosts file so we can use FQDN's instead of IP-addresses
startmsg "Populating /etc/hosts file"
cat << EOF >> /etc/hosts
10.2.2.200  dvwa.fortinet.demo www.fortinet.demo
10.2.2.201  bwapp.fortinet.demo
10.2.2.202  finance.fortinet.demo
10.2.2.203  petstore.fortinet.demo
10.2.2.204  crapi.fortinet.demo crapi-mail.fortinet.com
10.2.2.254  badsite.fortinet.demo fortipoc.fortinet.demo
10.2.2.1    fad.fortinet.demo
EOF
endmsg

# Set Lubuntu password so you can SSH into Lubuntu
startmsg "Setting lubuntu user pwd"
/usr/bin/passwd lubuntu << EOF > /tmp/passwd 2>&1
fortinet
fortinet
EOF
endmsg

# Disabling X11 screensaver to reduce network load
startmsg "Disabling screensaver"
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/config/xscreensaver -O /home/lubuntu/.xscreensaver > /dev/null 2>&1
endmsg

# Check if Downloads directory exist
startmsg "Checking Downloads directory"
[ -d /home/lubuntu/Downloads ] || mkdir /home/lubuntu/Downloads
endmsg

# Create two files 10Kb, 500Kb for hidden parameter tampering demo
startmsg "Creating upload file"
dd if=/dev/urandom of=/home/lubuntu/Downloads/10K.foo bs=1024 count=10 > /tmp/file10k 2>&1
dd if=/dev/urandom of=/home/lubuntu/Downloads/500K.foo bs=1024 count=500 > /tmp/file500k 2>&1
chown lubuntu:lubuntu /home/lubuntu/Downloads/*.foo > /dev/null 2>&1
endmsg

# Download some password protected php test files
startmsg "Downloading malware files"
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/malware.zip -O /home/lubuntu/Downloads/malware.zip > /dev/null 2>&1
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/trojan.zip -O /home/lubuntu/Downloads/trojan.zip > /dev/null 2>&1
cd /home/lubuntu/Downloads
sudo unzip -P fortinet malware.zip
sudo unzip -P fortinet trojan.zip
rm *.zip
chown lubuntu:lubuntu /home/lubuntu/Downloads/*.php > /dev/null 2>&1
endmsg

# Downloading FortiADC request generators
startmsg "Downloading FortiADC request generators"
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/petstore-get.sh -O /home/lubuntu/Downloads/petstore-get.sh > /dev/null 2>&1
sudo chmod +x /home/lubuntu/Downloads/petstore-get.sh
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/petstore-post.sh -O /home/lubuntu/Downloads/petstore-post.sh > /dev/null 2>&1
sudo chmod +x /home/lubuntu/Downloads/petstore-post.sh
# Section below added for Adaptive-learning
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/menu -O /usr/local/bin/menu > /dev/null 2>&1
sudo chmod +x /usr/local/bin/menu
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/petstore-get -O /usr/local/bin/petstore-get > /dev/null 2>&1
sudo chmod +x /usr/local/bin/petstore-get
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/petstore-post -O /usr/local/bin/petstore-post > /dev/null 2>&1
sudo chmod +x /usr/local/bin/petstore-post
endmsg

# Install FortiDemo RootCA into Firefox
startmsg "Installing FortiDemo RootCA into Firefox"
wget http://${FORTIPOCIP}/${FORTIPOCDIR}/config/rootca.fortinet.demo.crt -O /usr/local/share/ca-certificates/rootca.fortinet.demo.crt > /dev/null 2>&1

# Lubuntu prior to 22.04 (Jammy) works with filesystem for Firefox, not snapd packages
if [ "$LUBUNTUVERSION" != "22.04" ]; then
    [ ! -d /usr/lib/firefox/distribution ] && mkdir -p /usr/lib/firefox/distribution
    cat << EOF > /usr/lib/firefox/distribution/policies.json
{
    "policies": {
        "Certificates": {
            "Install": [
            "/usr/local/share/ca-certificates/rootca.fortinet.demo.crt"
            ]
        }
    }
}
EOF
fi

# Lubuntu 22.04 (Jammy) works with snapd packages for Firefox. CA-root certificate loading changed.
if [ "$LUBUNTUVERSION" = "22.04" ]; then
    mkdir -p /etc/firefox/policies/ca-certificates
    cat << EOF > /etc/firefox/policies/policies.json
{
    "policies": {
        "Certificates": {
            "Install": [
            "/etc/firefox/policies/ca-certificates/rootca.fortinet.demo.crt"
            ]
        }
    }
}
EOF
    # The certificate file needs to be in a /etc/firefox subdirectory, a symbolic link doesn't work.
    cp /usr/local/share/ca-certificates/rootca.fortinet.demo.crt /etc/firefox/policies/ca-certificates/rootca.fortinet.demo.crt
fi
endmsg

# Adding FortiDemo RootCA to OpenSSL trusted certs
startmsg "Adding FortiDemo RootCA to OpenSSL"
sudo update-ca-certificates > /dev/null 2>&1
endmsg

# Installing AttackSamplest.txt file on Desktop
startmsg "Installing AttackSamples.txt onto Desktop"
sudo wget http://${FORTIPOCIP}/${FORTIPOCDIR}/AttackSamples.txt -O /home/lubuntu/Desktop/AttackSamples.txt > /dev/null 2>&1
endmsg

# Install some additional packages
echo " *** You may continue while packages are installed in the background ***"
startmsg "Installing additional packages"
sudo apt update > /dev/null 2>&1
sudo apt install -y -qq curl ssh sqlmap > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
if [ "$LUBUNTUVERSION" != "22.04" ]; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl ssh florence > /dev/null 2>&1
else
    # Lubuntu 22.04 has a builtin virtual keyboard and Florence package is not available (yet) 
    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq curl ssh > /dev/null 2>&1
fi
endmsg

# Making space on / partition
#startmsg "Cleaning root patition space"
#sudo rm /var/cache/apt/archive/*.deb > /dev/null @>&1
#endmsg
