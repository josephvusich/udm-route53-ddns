FROM alpine

RUN apk add --no-cache bash; \
      apk add --no-cache curl; \
      apk add --no-cache jq; \
      mkdir /ddns;

WORKDIR /ddns

COPY route53-dynamic-dns-with-lambda/route53-ddns-client.sh /ddns
COPY container-main.sh /ddns
CMD /ddns/container-main.sh
