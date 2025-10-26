#!/bin/bash 

flux bootstrap github \
  --token-auth=false \
  --owner=blbecker \
  --repository=homelab \
  --branch=main \
  --path=flux/clusters/tartarus.us \
  --personal