# udm-route53-ddns

Route53 Dynamic DNS support for the UDM and UDM Pro, using [boostchicken's on_boot.d package](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script) and the [awslabs Route53 Dynamic DNS stack](https://github.com/awslabs/route53-dynamic-dns-with-lambda).

## Requirements
* UniFi Dream Machine (UDM) or Dream Machine Pro (UDMP) running firmware 1.6.4+ (required for [on_boot.d support](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script)).
* (Optional) Docker, for building your own image.

## Building
If you do not build your own image, the default will be used, as shown in the [example config](#Example-config).
* Clone this repository with `--recurse-submodules`
* Run [`docker-build.sh`](docker-build.sh)
* Tag `route53-ddns:unifi` to your remote repository and `docker push`
* During [Installation](#Installation), set `DDNS_IMAGE` in your [global config](#Global-config) file.

## Installation
* Set up a DDNS endpoint for each domain, using the [awslabs CloudFormation template](https://github.com/awslabs/route53-dynamic-dns-with-lambda).
* Install the [on_boot.d package](https://github.com/boostchicken/udm-utilities/tree/master/on-boot-script) on the UDM.
* Install [container-common](https://github.com/boostchicken/udm-utilities/tree/master/container-common) to limit container log size and avoid filling the UDM's storage.
* Copy the [on_boot.d script from this repo](on_boot.d/53-route53-ddns.sh) to `/mnt/data/on_boot.d/`
* `chmod +x /mnt/data/on_boot.d/53-route53-ddns.sh`
* (Optional) If using a custom Docker image, set `DDNS_IMAGE` in the [global config](#Global-config) file.
* Create `${DOMAIN}.conf` for each domain. See the [per-domain config](#Per-domain-config) for an example.
* Run `/mnt/data/on_boot.d/53-route53-ddns.sh` or reboot the UDM.

## Modifying config
To apply configuration changes without rebooting:
* SSH to the UDM.
* `podman restart route53-ddns`

## Updating
To update to a new version:
* SSH to the UDM.
* `podman stop route53-ddns`
* `docker rmi route53-ddns:unifi`
* Copy the [on_boot.d script from this repo](on_boot.d/53-route53-ddns.sh) to `/mnt/data/on_boot.d/`
* `chmod +x /mnt/data/on_boot.d/53-route53-ddns.sh`
* Run `/mnt/data/on_boot.d/53-route53-ddns.sh`

## Checking status
To check status of the container:
* SSH to the UDM.
* `docker ps` should show the `route53-ddns` container, if running.
* `docker logs route53-ddns` to show the container log.

## Example config
### Global config
```
# /mnt/data/route53-ddns/config

# (Optional) Replace this with your own image built from this repo
# Defaults to: josephvusich/route53-ddns:unifi
DDNS_IMAGE=""

# Per-domain configuration now lives in separate .conf files. For
# backwards-compatibility, the global config file is still checked
# for a valid domain configuration.
```

### Per-domain config
```
# /mnt/data/route53-ddns/*.conf

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
