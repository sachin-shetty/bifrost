# Introduction

bifrost is an cloud-native openresty based application, deployed as a helm chart in to kubernetes cluster. 

### Preparing to deploy
1. Identify the region where you should deploy bifrost. bifrost should be deployed in a region closest to your users, for e.g. if your application is deployed in US West and you have a lot of users in Singapore complaining about speed, you should deploy bifrost in a APAC and in sub-region closest to your users

2. Identify the cloud provider where you should deploy bifrost. If your application is deployed in a public cloud like AWS, Google or Azure, you should use the same provider for bifrost as well. Using the same provider adds to the network acceration you are likely to get with bifrost due to optimized network routing between different regions of the same provider. If your application is not deployed in a public cloud, you should run some speed tests and see which cloud provider and region closest to your users get the best speeds to your application and pick one based on the tests. 

### Configure bifrost

Following things needs to be configured
1. SSL Certificates: Since users https connections terminate at bifrost, bifrost should present a certificate similar to your application for your users to trust it. It does not have to be the same key pair as your end application, but the server name and CA should be acceptable to your users.

2. Configuring the routes: bifrost needs to know the end point to forward the connections, this is configured in a json file
      
```json
{
    "myapp1-apac.mydomain.com": "200.150.100.10"
    "myapp2.mydomain.com": "200.150.100.20"
}
```

With the above configuration, bifrost with forward all https connections with Host header myapp1i-apac.mydomain.com to 200.150.100.10 and so on. 

3. Making sure your users are routed to the bifrost instead of actual remote application. This can be done with one of following:
     1. You can create an new A record in your DNS that points to the bifrost end point for example myapp1-apac.mydomain.com will resolve to the public ip of bifrost
     2. You can use a global traffic routing DNS provider - More details TBD


4. Provision a public ip in your public cloud
   gcloud compute addresses create bifrost-lb-ip --region asia-south1 --project free-apis-199609

5. git clone https://github.com/sachin-shetty/bifrost.git

6. create a values.xml by copying chart/bifrost/values.yaml and edit the values

7. helm upgrade --install bifrost-gke-dev --values chart/bifrost/values.yaml .

### Deploying using ingress

bifrost can be deployed behing ingress. This has the following advantages
1. SSL keys and processing can be managed by ingress
2. Shared public ip between bifrost and other applications

To deploy bifrost with ingress
1. Set bifrost.tlsenabled: false
2. Set Service.type = NodePort
2. Setup you ingress to route traffic to bifrost

### Multi-hop deployment

Sometimes for better performance, you may need multiple hops of bifrost before your traffic hits your application server. Consider a case where your application is 
deployed in some local datacenter in east coast and most of your users are in Singapore. One possible deployment option would be deploy a bifrost hop in Singapore which directly routed traffic to your application in east coast, but this may not produce best results. A multi-hop  approach would be better for such use cases

1. Deploy a hop in US East Cloud. Configure routes to send traffic to your app
2. Deploy a hop in Singapore. Configure routes to send traffic to US East Hop
3. Point your users to Singapore hop

User --> Singapore Bifrost Hop --> US East Bifrost Hop --> You App in Each coast DC

This configuration routes 90% of traffic through better managed routes.
