#!/usr/bin/env sh

if [ -f ./vars.yml ]; then
    CONSUL=$(grep 'consul_app:' vars.yml | awk '{print $2}')
else
    echo "vars.yml does not appear to exist in the current directory!"
    exit 1
fi

CF=$(which cf)

$CF ssh -i 0 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP"
$CF ssh -i 1 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP"
$CF ssh -i 2 $CONSUL -c "echo \$CF_INSTANCE_INTERNAL_IP"
