#!/bin/sh

CONTAINER=route53-ddns

if podman container exists "$CONTAINER"; then
  podman start "$CONTAINER"
else
  podman run --interactive --detach --rm \
    --net=host \
    --name="$CONTAINER" \
    --security-opt=no-new-privileges \
    -v /mnt/data/route53-ddns:/etc/route53-ddns:ro \
    josephvusich/route53-ddns:unifi
fi
