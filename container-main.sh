#!/bin/sh

. /etc/route53-ddns/config
if [ -z "$DDNS_API_KEY" ]; then
  echo "DDNS_API_KEY not specified."
  exit 1
fi
if [ -z "$DDNS_SECRET" ]; then
  echo "DDNS_SECRET not specified."
  exit 1
fi
if [ -z "$DDNS_HOSTNAME" ]; then
  echo "DDNS_HOSTNAME not specified."
  exit 1
fi
if [ -z "$DDNS_URL" ]; then
  echo "DDNS_URL not specified."
  exit 1
fi
if [ -z "$DDNS_IPVERSIONS" ]; then
  echo "DDNS_IPVERSIONS not specified."
  exit 1
fi

if [ -z "$DDNS_TTL" ]; then DDNS_TTL="60"; fi

while true; do
  for i in $(echo "$DDNS_IPVERSIONS" | sed "s/,/ /g"); do
    echo "Updating $i..."
    ./route53-ddns-client.sh \
      --hostname "$DDNS_HOSTNAME" \
      --secret "$DDNS_SECRET" \
      --api-key "$DDNS_API_KEY" \
      --url "$DDNS_URL" \
      --ip-version "$i"
  done
  echo Update finished $(date)
  sleep "$DDNS_TTL"
done
