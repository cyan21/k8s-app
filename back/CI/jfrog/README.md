# PRE REQUISITES

JFrog platform enabling Artifactory, Xray, Pipelines

| Service | Type | Name | Description | 
| ----------- | ----------- |----------- | ----------- |
| Artifactory | Gradle virtual repo | jupiter-grdl | aggregate nuget dev local and remote | 
| Artifactory | Gradle local repo   | jupiter-dev-grdl-local | | 
| Artifactory | Gradle local repo   | jupiter-rc-grdl-local | for Gradle promotion | 
| Artifactory | Gradle remote repo  | jupiter-jcenter-grdl-remote | | 
| Artifactory | Docker virtual repo | jupiter-docker | | 
| Artifactory | Docker local repo   | jupiter-dev-docker-local | | 
| Artifactory | Docker local repo   | jupiter-release-docker-local | | 
| Artifactory | Docker remote repo  | jupiter-dockerhub-remote | | 
| Artifactory | Docker remote repo  | jupiter-bintray-remote | | 
| Artifactory | Helm virtual repo   | saturn-helm | | 
| Artifactory | Helm local repo     | saturn-dev-helm-local | | 
| Artifactory | Helm remote repo    | saturn-chartcenter-remote | | 
| Pipelines   | Github Integration | yann_github | pointing to https://github.com/cyan21 |
| Pipelines   | Artifactory Integration | artifactory_eu | |
| Pipelines   | K8S Integration | yann_k8s | see k8s-object-api folder to create it|


## Repository creation

see `chart/CI/jfrog/init.sh`

if you change the repo names, make sure to edit environment variables in **pipelines.steps.yaml**

## Integration creation

integrations have to be created manually for now on JFrog pipelines