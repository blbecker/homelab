+++
title = 'Storage'
date = 2023-12-17T14:14:45-05:00
draft = false
weight = 10
+++

## Local storage

K3s deploys a local storage PVC provider out of the box and that is currently used for some types of storage in the cluster. A number of services I'm running use sqlite3, which does not like to be run accessed over nfs. Rather than risk database corruption, I'm currently using local storage for these services, located on the nas (the only node in the cluster currently). I've deployed 1 service ([bazarr](../services/bazarr)) using the new postgresql support in the Arrs. I'd like to migrate the rest of the arrs over to use postgres for their DB and then store their remaining /config dirs on Longhorn. That will make these base systems fully portable.

## NAS

There's NFS storage available hosted on [nas](../hosts/nas).

## Longhorn (Future)
