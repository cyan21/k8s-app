#!/bin/bash

ns="build-plane"
sa="yann-tooling"
email="yannc@jfrog.com"

backend_registry_name="backend-registry-jupiter"
backend_registry_url="platform-us.staging.gcp.devopsacc.team"
backend_registry_user="yannc@jfrog.com"
backend_registry_pass="AKCp8ii9EF5t1uxMamxLx6VgCfZaLbRjzZpLMuf1xGMy2A5goYu74drkZZavEAgvmZaSfaimv"

frontend_registry_name="front-registry-mars"
frontend_registry_url="platform-us.staging.gcp.devopsacc.team"
frontend_registry_user="yannc@jfrog.com"
frontend_registry_pass="AKCp8ii9EF5t1uxMamxLx6VgCfZaLbRjzZpLMuf1xGMy2A5goYu74drkZZavEAgvmZaSfaimv"

# create namespace, service account, role, role binding
sed "s/MY_NAMESPACE/$ns/g" demo.yaml.tpl > demo.yaml
sed -i '' "s/MY_SVC_ACCOUNT/$sa/g" demo.yaml

sudo kubectl apply -f demo.yaml 

sudo kubectl create secret docker-registry $frontend_registry_name \
    --docker-server=$frontend_registry_url \
    --docker-username=$frontend_registry_user --docker-password=$frontend_registry_pass --docker-email=$email -n $ns

sudo kubectl create secret docker-registry $backend_registry_name \
    --docker-server=$backend_registry_url \
    --docker-username=$backend_registry_user --docker-password=$backend_registry_pass --docker-email=$email -n $ns


# generate kubeconfig (for JFrog Pipelines)
####################

# install yq
#sudo curl -LO https://github.com/mikefarah/yq/releases/download/v4.4.0/yq_linux_amd64
#sudo chmod u+x yq_linux_amd64 && sudo mv yq_linux_amd64 /usr/bin/yq 
sudo yq --version

# get kubeconfig  
sudo kubectl config view --flatten --minify > myKubeConfig

# get token from secret
token=`sudo kubectl describe secrets $sa -n $ns | grep "^token" | tr -d "[[:space:]]" | cut -d: -f2`

# add authentication by token 
sudo  yq -i e ".users[0].user.token = \"$token\"" myKubeConfig 

# remove authentication via gcp 
sudo yq -i e "del(.users[0].user.auth-provider)" myKubeConfig