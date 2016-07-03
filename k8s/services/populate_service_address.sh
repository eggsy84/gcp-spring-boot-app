#!/bin/bash

# This script is used by the Jenkins build and allows the identification
# of the external load balancer address. It needs the sleep functionality because
# the allocation of external IP address is an asynchronous actvity

FRONTEND_ADDRESS='';

while [[ "e$FRONTEND_ADDRESS" == "e" ]];
  do FRONTEND_ADDRESS=`kubectl describe service/app-service 2>/dev/null | grep "LoadBalancer\ Ingress" | cut -f2`;
  printf ".";
done;

echo "$FRONTEND_ADDRESS" > ./frontend_service_address
