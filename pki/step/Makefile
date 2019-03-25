PKI_DOMAIN=pulsifer.dev
PKI_ORGANIZATION=Pulsifer Technologies
PKI_ORGANIZATIONAL_UNIT=Development
PKI_LOCALITY=Ottawa
PKI_PROVINCE=Ontario
PKI_COUNTRY=CA

.PHONY: all
all: clean step root intermediate issuing-intermediate wildcard-domain-certificate client-certificate

.PHONY: step
easypki: ## runs go get to download easypki
	:

.PHONY: root
root: ## Create Root Certificate Authority with 10 year expiry
	step certificate create \
	  "${PKI_ORGANIZATION} Root Certificate Authority"\
	  root-ca.crt \
	  root-ca.key \
	  --profile=root-ca \
	  --kty=EC \
	  --curve=P-384 \
	  --not-after=87600h

.PHONY: intermediate
intermediate: ## Create Intermediate Certificate Authority with 5 year expiry
	step certificate create \
	  "${PKI_ORGANIZATION} Intermediate Certificate Authority" \
	  intermediate-ca.crt \
	  intermediate-ca.key \
	  --profile=intermediate-ca \
	  --ca=./root-ca.crt \
	  --ca-key=./root-ca.key \
	  --not-after=43800h

.PHONY: issung-intermediate
issuing-intermediate: ## Create Issuing Intermediate Certificate Authority with 2 year expiry
	step certificate create \
	  "${PKI_DOMAIN} Issuing Intermediate Certificate Authority" \
	  ${PKI_DOMAIN}-ca.crt \
	  ${PKI_DOMAIN}-ca.key \
	  --profile=intermediate-ca \
	  --ca=./intermediate-ca.crt \
	  --ca-key=./intermediate-ca.key \
	  --san=${PKI_DOMAIN} \
	  --not-after=8760h

.PHONY: wildcard-domain-certificate
wildcard-domain-certificate: ## Create Wildcard TLS Certificate *.PKI_DOMAIN with 1 year expiry
	step certificate create \
	  "${PKI_DOMAIN} wildcard certificate" \
	  star.${PKI_DOMAIN}.crt \
	  star.${PKI_DOMAIN}.key \
	  --profile=leaf \
	  --san="*.${PKI_DOMAIN}" \
	  --san=${PKI_DOMAIN} \
	  --ca=./${PKI_DOMAIN}-ca.crt \
	  --ca-key=./${PKI_DOMAIN}-ca.key \
	  --not-after=8760h

.PHONY: client-certificate
client-certificate: ## Create Client Certificate client@PKI_DOMAIN with 6 month expiry
	step certificate create \
	  "client@${PKI_DOMAIN}" \
	  client.${PKI_DOMAIN}.crt \
	  client.${PKI_DOMAIN}.key \
	  --profile=leaf \
	  --ca=./${PKI_DOMAIN}-ca.crt \
	  --ca-key=./${PKI_DOMAIN}-ca.key \
	  --not-after=8760h

.PHONY: help
help: ## ty jessfraz
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Remove build artifacts
	rm -f *.{crt,key}
