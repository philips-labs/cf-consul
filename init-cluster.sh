#!/usr/bin/env sh

if [ -f ./vars.yml ]; then
    CONSUL=$(grep 'consul_app:' vars.yml | awk '{print $2}')
else
    echo "vars.yml does not appear to exist in the current directory!"
    exit 1
fi

CF=$(which cf)

ip1=$($CF ssh -i 0 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP")
ip2=$($CF ssh -i 1 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP")
ip3=$($CF ssh -i 2 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP")

echo IPs: $ip1 $ip2 $ip3

cf ssh $CONSUL -c "/app/consul join -http-addr=http://\$CF_INSTANCE_INTERNAL_IP:8080 $ip1 $ip2 $ip3"
