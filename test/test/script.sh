# Azure CLI install
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Azure AKS CLI install (kubectl , kubelogin)
az aks install-cli

# Login
az login

# AKS credential information get
az aks get-credentials -g <resourcegroup> -n <AKS name>

# official docker 이미지를 따오기위한 도커설치 (점프박스 기준)
apt-get install -y docker.io

# ACR (Azure Container Registry) login
az acr login --name <Registry name>

# Jumpbox 에 도커 설치
apt-get install -y docker.io

# nginx , wordpress official image pull
docker pull nginx
docker pull wordpress
docker pull wlstjq6617/was:0.1 # (제작해둔 JDBC driver 포함 tomcat 이미지)

# official image tag
docker tag nginx:latest jssong.azurecr.io/project/nginx
docker tag wordpress:latest jssong.azurecr.io/project/wordpress
docker tag wlstjq6617/was:0.1 jssong.azurecr.io/project/was

# ACR image push
docker push jssong.azurecr.io/project/nginx
docker push jssong.azurecr.io/project/wordpress
docker push jssong.azurecr.io/project/was

# Ingress Controller 설치를 (Ubuntu base)
snap install helm --classic # helm install
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx # helm 리포지토리 추가
kubectl create ns ingress-nginx # Ingress Controller ns create
helm repo update 
helm search repo ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx

# 이후 YAML FILE 적용
# DNS 영역 생성 후
az network dns record-set a add-record
    --resource-group <resouregroupname> \
    --zone-name <my domain> \
    --record-set-name "*.ingress" \
    --ipv4-address <MY_EXTERNAL_IP>