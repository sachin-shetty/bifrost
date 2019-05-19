#Introduction



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
1. docker run -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx_conf.d/nginx_pop.conf:/etc/nginx/conf.d/nginx_pop.conf  -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx_conf.d/ssl:/usr/local/openresty/nginx/conf/ssl  -v /home/egnyte/work/bifrost/git/bifrost/chart/bifrost/config/nginx_conf.d/routes.json:/usr/local/openresty/nginx/conf/routes.json -p 4443:4443 --name "bitfrost-devel" openresty/openresty:alpine-fat
2. docker exec -it bitfrost-devel "/bin/bash"
3. cd /usr/local/openresty/nginx/logs/
4. curl -k -H "Host: mockbin.org" https://localhost:4443
   
