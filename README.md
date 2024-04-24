# cf-consul

Consul cluster release on Cloudfoundry

## Disclaimer

> [!Important]
> This repository is managed as Philips Inner-source / Open-source.
> This repository is NOT endorsed or supported by HSSA&P or I&S Cloud Operations. 
> You are expected to self-support or raise tickets on the Github project and NOT raise tickets in HSP ServiceNow. 

## configuration

| ENV | Description | Default | Requires |
|-----|-------------|---------|----------|
| CONSUL\_DC | Datacenter name | us-east | N |
| CONSUL\_TOKEN | Master token value | | Y |

## deployment

1. Use the `manifest.example.yml` as a template and deploy
2. Run `create-network-policies.sh` to set up the network policies for Raft
3. Run `init-cluster.sh` to initialize the cluster

## operating

As Cloudfoundry does not have persistent disk storage you will need
to use something like `consul snapshot` to occasionally back up the
state your Consul cluster.

## contact / getting help

Andy Lo-A-Foe (<andy.lo-a-foe@philips.com>)

## license
License is MIT
