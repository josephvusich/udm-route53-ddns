#!/bin/sh

. /etc/route53-ddns/config
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
  sleep 60
done
