# cf-consul

Consul cluster release on Cloudfoundry

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
