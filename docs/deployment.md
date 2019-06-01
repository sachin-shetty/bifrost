# Introduction

bifrost is an cloud-native openresty based application, deployed as a helm chart in to kubernetes cluster. 

### Preparing to deploy
1. Identify the region where you should deploy bifrost. bifrost should be deployed in a region closest to your users, for e.g. if your application is deployed in US West and you have a lot of users in Singapore complaining about speed, you should deploy bifrost in a APAC and in sub-region closest to your users

2. Identify the cloud provider where you should deploy bifrost. If your application is deployed in a public cloud like AWS, Google or Azure, you should use the same provider for bifrost as well. Using the same provider adds to the network acceration you are likely to get with bifrost due to optimized network routing between different regions of the same provider. If your application is not deployed in a public cloud, you should run some speed tests and see which cloud provider and region closest to your users get the best speeds to your application and pick one based on the tests. 

### Configure and Deploy bifrost
      
