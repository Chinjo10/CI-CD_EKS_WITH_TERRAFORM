# kojitechs-ci-cd-demo-infra-pipeline-tf

## Install plugins
Go to `manage jenkins`, `manage plugins` 
- sonarqube scanner 
- slack notification
- Quality Gates

## configure maven 
```sh
source ~/.bash_profile
```
### 
Setting up webhook configuration for jenkins and github
```hcl
http://18.205.191.218:8080/github-webhook/
```
### Configuring maven 

## Assign shell to jenkins user 
```sh
vi /etc/passwd 
change shell from /bin/fasle to /bin/bash
```
```
maven {
    3.8.1
}
```
### Slack notification
```
slack notification
global configuration
```
### configuring sonarqube server
```
manage plugin
SonarQube ScannerVersion
2.15
Sonar Quality GatesVersion
1.3.1
Blue OceanVersion
1.27.0
```
configure system.
```
SonarQube servers
add SonarQube
name: sonar 
Server URL: http://18.206.246.242:9000
```
3. 
Go to SonarQube server and generate a token 
- sign in
username: admin
password: admin
- Create a jenkins user 
- generate a token

4. 
###  Configure quality Gate
Go to sonarqube server 
- create a webhook 
administration
webhooks
- create webhook
name: jenkins
URL: http://18.205.191.218:8080/sonarqube-webhook/

### Tools to connect with eks cluster 
```
aws-cli 
kubectl
```
## How to connect to eks cluster 
```
aws eks --region us-east-1 update-kubeconfig  --name ci-cd-demo-eks-demo
```
## Troubleshooting
```sh
rm ~/.kube/config

```
# Kubernetes  - PODs
