# Introduction

bifrost is an cloud-native openresty based application, deployed as a helm chart in to kubernetes cluster. 

### Preparing to deploy
1. Identify the region where you should deploy bifrost. bifrost should be deployed in a region closest to your users, for e.g. if your application is deployed in US West and you have a lot of users in Singapore complaining about speed, you should deploy bifrost in a APAC and in sub-region closest to your users

2. Identify the cloud provider where you should deploy bifrost. If your application is deployed in a public cloud like AWS, Google or Azure, you should use the same provider for bifrost as well. Using the same provider adds to the network acceration you are likely to get with bifrost due to optimized network routing between different regions of the same provider. If your application is not deployed in a public cloud, you should run some speed tests and see which cloud provider and region closest to your users get the best speeds to your application and pick one based on the tests. 

### Configure and Deploy bifrost

Following things needs to be configured
1. SSL Certificates: Since users https connections terminate at bifrost, bifrost should present a certificate similar to your application for your users to trust it. It does not have to be the same key pair as your end application, but the server name and CA should be acceptable to your users.

2. Configuring the routes: bifrost needs to know the end point to forward the connections, this is configured in a json file
      
```json
{
    "myapp1-apac.mydomain.com": "myapp1.mydomain.com",
    "myapp2.mydomain.com": "200.150.100.20"
}
```

With the above json file, bifrost with forward all https connections with Host header myapp1.mydomain.com to 200.150.100.10 and so on. 

3. Making sure your users are routed to the bifrost instead of actual remote application. This can be done with one of following
     1. You can create an new A record in your DNS that points to the bifrost end point for example myapp1-apac.mydomain.com will resolve to the public ip of bifrost
     2. You can use a global traffic routing DNS provider - More details <TBD> 
