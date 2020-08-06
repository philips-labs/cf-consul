#!/usr/bin/env sh

if [ -f ./vars.yml ]; then
    CONSUL=$(grep 'consul_app:' vars.yml | awk '{print $2}')
else
    echo "vars.yml does not appear to exist in the current directory!"
    exit 1
fi

CF=$(which cf)

$CF v3-create-app $CONSUL --app-type docker

if [ -n "$CF" ]; then
    $CF add-network-policy $CONSUL --destination-app $CONSUL --protocol tcp --port 8600
    $CF add-network-policy $CONSUL --destination-app $CONSUL --protocol udp --port 8600
    $CF add-network-policy $CONSUL --destination-app $CONSUL --protocol tcp --port 8300-8302
    $CF add-network-policy $CONSUL --destination-app $CONSUL --protocol udp --port 8301-8302
    $CF add-network-policy $CONSUL --destination-app $CONSUL --protocol tcp --port 21000-21255
else
    echo "Cannot find cf binary in your path, please install the latest cf cli tools."
fi
