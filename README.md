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
   - helm install .
3. Check current helm install
   - helm ls
4. Delete installed helm package
   - helm delete <package name>

Launch bifrost
1. Fetch the kubenetes service name
   - kubectl get service
2. Get the Url to the service
   - minikube service <service-name> --url
3. curl url

Some minikube commands:
1. minikube dashboard
2. minikube stop
3. minukube delete

   
