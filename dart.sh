sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install apt-transport-https

sudo mkdir -p /usr/share/keyrings

wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg

sudo mkdir -p /etc/apt/sources.list.d

echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list

sudo apt-get update && sudo apt-get install dart