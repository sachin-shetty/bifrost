In this document we discuss the process to evaluate if bifrost deployment will speed up your global access
and figure our an optimal deployment topology.

bifrost deploys a few simple download end points to test speed to the pop. 

If you have named your helm chart bifrost-virginia, you will be able to test speeds with different 
files sizes to your end point as follows

```
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/1GB.dat -o /dev/null
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/100MB.dat -o /dev/null
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/10MB.dat -o /dev/null
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/1MB.dat -o /dev/null
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/10KB.dat -o /dev/null
curl -v -k https://<BIFROST-IP>/speed-test-bifrost-virginia/1KB.dat -o /dev/null
```

Using pre-seeded test payloads, you can determine the speeds your users are likely to get to the bifrost pop.

Using a combination of such pops, you can simulate the user experience and the benefits of using bifrost.

Consider an example where your application is located in US East region, your users are in Singapore and are complaining about speeds. 

So you are esentially trying to determine if setting up a bifrost pop in Singapore will benefit your users. You can simulate and test your speeds as follows

1. Deploy a bifrost pop in US East Region. This will simulate your end application. Let's call the helm chart bifrost-useast
2. Deploy a bifrost pop in Singapore. Let's call the helm chart bifrost-singapore
   1. Configure this bifrost app to send an appropriate host request to the pop deployed in #1. Let's call this "us-east.test-bifrost.com"

Now you can test speeds as follows
1. Speeds to the Singapore bifrost app can be measured as follows:
```
curl -v -k https://<bifrost-singapore-ip>/speed-test-bifrost-singapore/1GB.dat -o /dev/null
```
2. Speeds to the US east bifrost app via Singapore bifrost pop can be measured as follows:
```
curl -v -k -H "Host: us-east.test-bifrost.com"  https://<bifrost-singapore-ip>/speed-test-bifrost-useast/1GB.dat -o /dev/null
```
Notice how we send the requests to Singapore Bifrost pop, but set the host header and request uri for US east. This config ensures that the request is proxied to US East and you measure the end to end speed. The speed you get here is likely the speed you users in Singapore. will get if they were to access you app deployed in US East, using a bifrost app in Singapore.

3. To compare speed in #2 with the actual speed of hitting US East directly, without bifrost in between, you can try the following test
```
curl -v https://<bifrost-useast-ip>/speed-test-bifrost-useast/1GB.dat -o /dev/null
```
If #3 is better than #2, you are likely to benefit from bifrost deployment in Singapore. If not, you should find better providers or pop locations that would make #2 > #3.
