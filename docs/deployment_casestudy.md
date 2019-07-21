In this document we discuss the process to evaluate if bifrost deployment will speed up your global access
and figure our an optimal deployment topology.

bifrost deploys a few simple download end points to test speed to the pop. 

If you have named your helm chart bifrost-virginia, you will be able to test speeds with different 
files sizes to your end point as follows

```
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/1GB.dat -o /dev/null
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/100MB.dat -o /dev/null
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/10MB.dat -o /dev/null
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/1MB.dat -o /dev/null
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/10KB.dat -o /dev/null
curl -v -k https://35.186.190.136/speed-test-bifrost-virginia/1KB.dat -o /dev/null
```

Using pre-seeded test payloads, you can determine the speeds your users are likely to get to the bifrost pop.

Using a combination of such pops, you can simulate the user experience and the benefits of using bifrost.

