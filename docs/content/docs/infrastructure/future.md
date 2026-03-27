+++
title = 'Future'
date = 2023-12-17T13:43:57-05:00
draft = false
weight = 1
+++

## Expand cluster

### Redundant nodes

Right now the "cluster" is a single node running on the NAS. This hosts consolidates are functions of my homelab and represents a single point of failure. In order to address this, I'd like to expand the cluster to a redundant set of Nucs, or similar devices, running as kubernetes servers and demote `nas` to be an agent within the cluster.

### Thoughtful PVCs
