# udm-route53-ddns

## Installation
* Set up the DDNS Lambda using the [awslabs CloudFormation template](https://github.com/awslabs/route53-dynamic-dns-with-lambda).
* Install the [on_boot.d package](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script) on the UDM.
* Copy the [on_boot.d script from this repo](on_boot.d/53-route53-ddns.sh) to `/mnt/data/on_boot.d/`
* `chmod +x /mnt/data/on_boot.d/53-route53-ddns.sh`
* Create config on UDM at `/mnt/data/route53-ddns/config`
* Run `/mnt/data/on_boot.d/53-route53-ddns.sh` or reboot the UDM.

## Example config
```
# apiKey from CloudFormation Outputs
DDNS_API_KEY=""

# shared_secret field from DynamoDB
DDNS_SECRET=""

# hostname field from DynamoDB, including any trailing dot
# Example: "dynamic.example.com."
DDNS_HOSTNAME=""

# apiUrl from CloudFormation Outputs, with 'https://' prefix
# Example: "https://api-gateway.example.com"
DDNS_URL=""

# Comma-delimited list of IP versions
# 'ipv4' = A record
# 'ipv6' = AAAA record
DDNS_IPVERSIONS="ipv4,ipv6"

# (Optional) Refresh rate in seconds
# Less or equal to the TTL configured in DynamoDB
# Defaults to: 60
DDNS_TTL=""
```
