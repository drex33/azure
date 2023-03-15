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

# 포탈에서 연결
# 유저, 그룹 생성 후 FQDN (전역관리자 도메인)으로 생성한유저에게 Principal ID 할당 
# 그 유저에 AKS Admin 권한 부여.
# 전역관리자 즉, 구독을 가지고있는 contributor는 클러스터 어드민으로 지정불가함

# 네임스페이스 분리운영을 위한 그룹 생성 
az ad group create --display-name appdev --mail-nickname appdev --query Id -o tsv

# 명시적인 롤 부여
az role assignment create \
  --assignee 그룹개체 ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope AKS 개체 ID

# 사용자 계정 생성 (기본 제공된 FQDN 사용)
az ad user create \
  --display-name "AKS Dev" \
  --user-principal-name FQDN 지정 \
  --password 비밀번호 \
  --query objectId -o tsv

# 그룹에 추가
az ad group member add --group appdev --member-id "위 생성된 그룹개체 ID"

# 네임스페이스 생성
kubectl create ns dev

# Role , Rolebinding YAML FILE APPLY

