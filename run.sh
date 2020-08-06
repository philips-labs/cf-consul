#!/bin/sh
if [ -z "$PORT" ]; then
    echo "[run] Defaulting to port 8080"
    PORT=8080
fi

if [ -z "$CF_INSTANCE_INTERNAL_IP" ]; then
    echo "[run] Defaulting to CF_INSTANCE_INTERNAL_IP=127.0.0.1"
    CF_INSTANCE_IP=127.0.0.1
fi

if [ -z "$CONSUL_DC" ]; then
    echo "[run] Defaulting to CONSUL_DC=us-east"
    CONSUL_DC=us-east
fi

if [ -z "$CONSUL_TOKEN" ]; then
    echo "[run] Fatal: no CONSUL_TOKEN provided"
    exit 1
fi

if [ "$CF_INSTANCE_INDEX" == "0" ]; then
   BOOTSTRAP="-bootstrap"
fi

if [ "x$GOSSIP_TOKEN" == "x" ]; then
   echo "[run] No gossip token set"
else
   cat <<EOF > /app/config/gossip.json
{
  "encrypt": "$GOSSIP_TOKEN"
}
EOF

fi

echo "[run] Datacenter: $CONSUL_DC"
echo "[run] Host: $CF_INSTANCE_IP"
echo "[run] Port: $PORT"

cat <<EOF > /app/config/dc.json
{
  "primary_datacenter": "$CONSUL_DC",
  "datacenter": "$CONSUL_DC"
}
EOF

cat <<EOF > /app/config/acl.json
{
  "acl": {
      "default_policy": "allow",
      "enable_token_persistence": true,
      "enabled": true,
      "tokens": {
        "master": "$CONSUL_TOKEN"
      }
  }
}
EOF

/app/consul agent -config-dir=/app/config $BOOTSTRAP -server -data-dir=/tmp -bind=$CF_INSTANCE_INTERNAL_IP -client=$CF_INSTANCE_INTERNAL_IP -http-port=$PORT -ui
