#!/bin/sh

for cfg in /etc/route53-ddns/config /etc/route53-ddns/*.cfg /etc/route53-ddns/*.conf; do
  if [ -f "$cfg" ]; then
    /ddns/domain-helper.sh "$cfg" &
  fi
done

sleep infinity
