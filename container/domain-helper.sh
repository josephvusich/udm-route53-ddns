#!/bin/sh

if [ -z "$1" ]; then
  echo "No config file specified."
  exit 1
fi

. "$1"

if [ -z "$DDNS_API_KEY" ]; then
  echo "$1: DDNS_API_KEY not specified, skipping."
  exit 1
fi
if [ -z "$DDNS_SECRET" ]; then
  echo "$1: DDNS_SECRET not specified, skipping"
  exit 1
fi
if [ -z "$DDNS_HOSTNAME" ]; then
  echo "$1: DDNS_HOSTNAME not specified, skipping."
  exit 1
fi
if [ -z "$DDNS_URL" ]; then
  echo "$1: DDNS_URL not specified, skipping."
  exit 1
fi
if [ -z "$DDNS_IPVERSIONS" ]; then
  echo "$1: DDNS_IPVERSIONS not specified, skipping."
  exit 1
fi

if [ -z "$DDNS_TTL" ]; then DDNS_TTL="60"; fi

echo "$1: $DDNS_HOSTNAME"

while true; do
  for i in $(echo "$DDNS_IPVERSIONS" | sed "s/,/ /g"); do
    echo "$DDNS_HOSTNAME Updating $i..."
    ./route53-ddns-client.sh \
      --hostname "$DDNS_HOSTNAME" \
      --secret "$DDNS_SECRET" \
      --api-key "$DDNS_API_KEY" \
      --url "$DDNS_URL" \
      --ip-version "$i" 2>&1 | sed -e "s/^/$DDNS_HOSTNAME /;"
  done
  echo "$DDNS_HOSTNAME Update finished $(date)"
  echo "$DDNS_HOSTNAME Next update in ${DDNS_TTL}s."
  sleep "$DDNS_TTL"
done
