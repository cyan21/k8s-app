#!/bin/bash


# requires : XRAY POLICY (see policy name in watch.json)

usage() {
    echo "$0 -u <JPD_URL> -l <ADMIN_USER> -p <ADMIN_PASS>"
}

JPD_URL="http://artifactory-eu-yannc3-0.soleng-emea-staging.jfrog.team"
ADMIN_USER="admin"
BUILD_NAMES="k8s_backapp_gradle,k8s_backapp_gradle_docker,k8s_frontapp_js,k8s_frontapp_js_docker"  #list with comma as a separator

while getopts "u:l:p:" option; do
    case "${option}" in
        u) JPD_URL=${OPTARG} ;;
        l) ADMIN_USER=${OPTARG} ;;
        p) ADMIN_PASS=${OPTARG} ;;
        *) usage && exit 1;;
    esac
done

if [ -z "$ADMIN_PASS" ]; then
    echo "[ERROR] missing ADMIN PASSWORD"
    exit 1
fi

creds="-u$ADMIN_USER:$ADMIN_PASS"

# create repo
echo "[ARTIFACTORY] creating repositories for chart..."
curl -XPATCH $creds \
    -H "Content-Type: application/yaml" -T repo.yaml \
    $JPD_URL/artifactory/api/system/configuration 
    
echo "[ARTIFACTORY] creating repositories for backend..."
curl -XPATCH $creds \
    -H "Content-Type: application/yaml" -T back_repo.yaml \
    $JPD_URL/artifactory/api/system/configuration 

echo "[ARTIFACTORY] creating repositories for frontend..."
curl -XPATCH $creds \
    -H "Content-Type: application/yaml" -T front_repo.yaml \
    $JPD_URL/artifactory/api/system/configuration 

# index build
echo -e "\n[XRAY] indexing builds ... "
curl -XPOST $creds \
    -H "Content-Type: application/json" -d "{\"names\":[\"`echo $BUILD_NAMES | sed 's/,/","/g'`\"]}" \
    $JPD_URL/xray/api/v1/binMgr/builds

# create watch
echo -e "\n[XRAY] creating watch for backend ... !"
curl -XPOST $creds \
    -H "Content-Type: application/json" -d @back_watch.json \
    $JPD_URL/xray/api/v2/watches

echo -e "\n[XRAY] creating watch for frontend ... !"
curl -XPOST $creds \
    -H "Content-Type: application/json" -d @front_watch.json \
    $JPD_URL/xray/api/v2/watches


