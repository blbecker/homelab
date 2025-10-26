#!/bin/bash 

cat /home/blbecker/.sops/tartarus-us.sops.agekey |
kubectl create secret generic sops-age \
  --namespace=flux-system \
  --from-file=age.agekey=/dev/stdin