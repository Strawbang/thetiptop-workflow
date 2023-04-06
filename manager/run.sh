#Creation des dossiers
if  [ ! -d $(pwd)/data ]
then
        mkdir $(pwd)/data
fi

if [ ! -d $(pwd)/data/jenkins ]
then
        mkdir $(pwd)/data/jenkins
fi

if [ ! -d $(pwd)/data/gogs ]
then
        mkdir $(pwd)/data/gogs
fi

if [ ! -d $(pwd)/data/nexus ]
then
        mkdir $(pwd)/data/nexus
fi

if [ ! -d $(pwd)/data/portainer ]
then
        mkdir $(pwd)/data/portainer
fi

if [ ! -d $(pwd)/data/elasticsearch ]
then
        mkdir $(pwd)/data/elasticsearch
fi

if [ ! -d $(pwd)/letsencrypt ]
then
        mkdir $(pwd)/letsencrypt
fi

#Gestion des droits
chown 1000 -R $(pwd)/data/jenkins
chown 200 -R $(pwd)/data/nexus
# chown 600 -R $(pwd)/letsencrypt/acme.json

#Restart server
#docker-compose stop
#truncate -s 0 /var/lib/docker/containers/*/*-json.log
#docker-compose up --build -d

#Restart Stack workflow
docker stack rm workflow
truncate -s 0 /var/lib/docker/containers/*/*-json.log
docker stack deploy --compose-file docker-compose.yml workflow
