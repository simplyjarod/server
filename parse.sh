#!/bin/bash



# INSTALACIÓN DE MONGO:
./mongodb-install.sh


# INSTALACIÓN DE NODE:
curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
yum -y install nodejs
yum install gcc-c++ make git -y



# ejecutar en el directorio previo o moverlo o X (creará un dir llamado parse-server)
git clone https://github.com/ParsePlatform/parse-server.git


cd parse-server


npm install -g parse-server mongodb-runner
mongodb-runner start

# You can use any arbitrary string as your application id and master key. These will be used by your clients to authenticate with the Parse Server.
parse-server --appId 111111111111111111111111 --masterKey 2222222222222222222222222222




# TEST IT:
# curl -X POST \
# -H "X-Parse-Application-Id: APPLICATION_ID" \
# -H "Content-Type: application/json" \
# -d '{"score":1337,"playerName":"Sean Plott","cheatMode":false}' \
# http://localhost:1337/parse/classes/GameScore

# You should get a response similar to this:
# {
#   "objectId": "2ntvSpRGIK",
#   "createdAt": "2016-03-11T23:51:48.050Z"
# }

# You can now retrieve this object directly (make sure to replace 2ntvSpRGIK with the actual objectId you received when the object was created):
# curl -X GET   
# -H "X-Parse-Application-Id: APPLICATION_ID"   
# http://YOUR_IP:1337/parse/classes/GameScore/bzEnCP451v
