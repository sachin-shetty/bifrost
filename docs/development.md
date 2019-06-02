# Development

Local Install:
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

Some minikube commands:
1. minikube dashboard
2. minikube stop
3. minukube delete

Local install with docker for debugging:
1. docker rm bitfrost-devel && docker run -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx/nginx_pop.conf:/etc/nginx/conf.d/nginx_pop.conf -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx/ssl:/usr/local/openresty/nginx/conf/ssl -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx/routes.json:/usr/local/openresty/nginx/bifrost/routes.json -p 4443:4443 --name "bitfrost-devel" openresty/openresty:alpine-fat
2. docker exec -it bitfrost-devel "/bin/bash"
3. cd /usr/local/openresty/nginx/logs/
4. curl -k -H "Host: www.mockbin.org" https://localhost:4443

# Deploying to Google k8s
Setup:

gcloud config set project free-apis-199609

gcloud config set compute/zone asia-south1-a

gcloud auth activate-service-account --key-file

gcloud compute addresses create bifrost-lb-ip --region asia-south1 --project free-apis-199609

gcloud container clusters get-credentials bifrost-gke-dev --zone asia-south1-a --project free-apis-199609

kubectl create -f service_account.yaml

helm init --service-account helm


Deploy:

helm upgrade --recreate-pods --install bifrost-gke-dev .

kubectl get service

curl -v -k -H "Host: www.google.com" https://35.222.223.192:4443

Delete:

helm delete --purge bifrost-gke-dev

gcloud container clusters delete bifrost-gke-dev --region asia-south1-a --project free-apis-199609

gcloud compute addresses delete bifrost-lb-ip --region asia-south1 --project free-apis-199609
