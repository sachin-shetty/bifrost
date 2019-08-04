# Development

## Local Install
1. Install helm and minikube: https://continuous.lu/2017/04/28/minikube-and-helm-kubernetes-package-manager
2. Install Virtualbox
2. Start minikube
    - minikube start

Running Locally:
1. minikube start
1. helm init

Install bifrost locally:
1. Install chart
   - cd chart/bifrost
   - helm upgrade --recreate-pods --install bifrost-dev .
3. Check current helm install
   - helm ls
4. Delete installed helm package
   - helm delete --purge bifrost-dev 

Launch bifrost
1. Fetch the kubenetes service name
   - kubectl get service
2. Get the Url to the service
   - minikube service bifrost-dev --url
3. curl url
4. kubectl exec -it $(kubectl get pods -o=name | sed -e 's/.*\///') -- /bin/bash

Some minikube commands:
1. minikube dashboard
2. minikube stop
3. minukube delete

Local install with docker for debugging:
1. docker rm bitfrost-devel && docker run -v bifrost/git/bifrost/chart/bifrost/config/nginx/nginx_pop.conf:/etc/nginx/conf.d/nginx_pop.conf -v bifrost/git/bifrost/chart/bifrost/config/nginx/ssl:/usr/local/openresty/nginx/conf/ssl -v bifrost/git/bifrost/chart/bifrost/config/nginx/routes.json:/usr/local/openresty/nginx/bifrost/routes.json -p 4443:4443 --name "bitfrost-devel" openresty/openresty:alpine-fat
2. docker exec -it bitfrost-devel "/bin/bash"
3. cd /usr/local/openresty/nginx/logs/
4. curl -k -H "Host: www.mockbin.org" https://localhost:4443

# Deploying to Google k8s

Setup Variables:

* PROJECT_NAME="Project Name"
* REGION="Project Region"
* ZONE="Project Zone"
* $KEY_FILE="Service Account File"
* $CLUSTER_NAME="Cluster Name"

Commands:

gcloud config set project $PROJECT_NAME

gcloud config set compute/zone $ZONE

gcloud auth activate-service-account --key-file $KEY_FILE

gcloud compute addresses create bifrost-lb-ip --region $REGION --project $PROJECT

gcloud compute addresses describe bifrost-lb-ip --region $REGION

gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT

kubectl create -f service_account.yaml

helm init --service-account helm


Deploy:

helm upgrade --recreate-pods --install --set service.loadBalancerIP="IP OF bifrost-lb-ip"  bifrost-gke-dev .

kubectl get service

curl -v -k -H "Host: www.google.com" https://bifrost-lb-ip:4443

Cleanup: 
helm delete --purge bifrost-gke-dev

Delete the cluster: **Careful if the cluster is shared**
gcloud container clusters delete $CLUSTER_NAME --region $REGION --project $PROJECT_NAME

gcloud compute addresses delete bifrost-lb-ip --region asia-south1 --project free-apis-199609
