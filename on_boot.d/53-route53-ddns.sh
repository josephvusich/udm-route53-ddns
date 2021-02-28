#!/bin/sh

CONTAINER=route53-ddns

. /mnt/data/route53-ddns/config
if [ -z "$DDNS_IMAGE" ]; then DDNS_IMAGE="josephvusich/route53-ddns:unifi"; fi

if podman container exists "$CONTAINER"; then
  podman start "$CONTAINER"
else
  podman run --interactive --detach --rm \
    --net=host \
    --name="$CONTAINER" \
    --security-opt=no-new-privileges \
    -v /mnt/data/route53-ddns:/etc/route53-ddns:ro \
    "$DDNS_IMAGE"
fi
