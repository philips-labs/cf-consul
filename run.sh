#!/bin/sh
if [ -z "$PORT" ]; then
    echo "[run] Defaulting to port 8080"
    PORT=8080
fi

if [ -z "$CF_INSTANCE_INTERNAL_IP" ]; then
    echo "[run] Defaulting to CF_INSTANCE_INTERNAL_IP=127.0.0.1"
    CF_INSTANCE_INTERNAL_IP=127.0.0.1
fi

if [ -z "$CONSUL_DC" ]; then
    echo "[run] Defaulting to CONSUL_DC=us-east"
    CONSUL_DC=us-east
fi

if [ -z "$CONSUL_TOKEN" ]; then
    echo "[run] Fatal: no CONSUL_TOKEN provided"
    exit 1
fi

if [ "CF_INSTANCE_INDEX" == "0" ]; then
   BOOTSTRAP="-bootstrap"
fi


echo "[run] Datacenter: $CONSUL_DC"
echo "[run] Host: $CF_INSTANCE_INTERNAL_IP"
echo "[run] Port: $PORT"

cat <<EOF > /app/config/dc.json
{
  "acl_datacenter": "$CONSUL_DC",
  "datacenter": "$CONSUL_DC"
}
EOF

cat <<EOF > /app/config/acl.json
{
  "acl_master_token": "$CONSUL_TOKEN",
  "acl_default_policy": "deny",
  "acl_down_policy": "deny"
}
EOF

/app/consul agent -config-dir=/app/config $BOOTSTRAP -server -data-dir=/tmp -bind=$CF_INSTANCE_INTERNAL_IP -client=$CF_INSTANCE_INTERNAL_IP -http-port=$PORT -ui
