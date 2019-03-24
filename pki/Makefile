BUILD_DIR=build
export PKI_DOMAIN=pulsifer.dev
export PKI_ORGANIZATION=Pulsifer Technologies
export PKI_ORGANIZATIONAL_UNIT=Development
export PKI_LOCALITY=Ottawa
export PKI_PROVINCE=Ontario
export PKI_COUNTRY=CA
export PKI_ROOT=$(BUILD_DIR)



.PHONY: all
all: clean easypki root intermediate issuing-intermediate wildcard-domain-certificate client-certificate

.PHONY: easypki
easypki: ## runs go get to download easypki
	go get github.com/google/easypki/cmd/easypki

.PHONY: root
root: ## Create Root Certificate Authority with 10 year expiry
	mkdir $(PKI_ROOT)
	easypki create \
	  --ca \
	  --filename=root \
	  --expire=3650 \
	  "${PKI_ORGANIZATION} Root Certificate Authority"

.PHONY: intermediate
intermediate: ## Create Intermediate Certificate Authority with 5 year expiry
	easypki create \
	  --ca-name=root \
	  --filename=intermediate \
	  --intermediate \
	  --expire=1825 \
	  "${PKI_ORGANIZATION} Intermediate Certificate Authority"

.PHONY: issung-intermediate
issuing-intermediate: ## Create Issuing Intermediate Certificate Authority with 2 year expiry
	easypki create \
	  --ca-name=intermediate \
	  --filename=issuing-intermediate \
	  --intermediate \
	  --expire=730 \
	  "${PKI_ORGANIZATION} Development Certificate Authority"

.PHONY: wildcard-domain-certificate
wildcard-domain-certificate: ## Create Wildcard TLS Certificate *.PKI_DOMAIN with 1 year expiry
	easypki create \
	  --ca-name=issuing-intermediate \
	  --expire=365 \
	  --dns="*.${PKI_DOMAIN}" \
	  "*.${PKI_DOMAIN}"

.PHONY: client-certificate
client-certificate: ## Create Client Certificate client@PKI_DOMAIN with 6 month expiry
	easypki create \
	  --ca-name=issuing-intermediate \
	  --client \
	  --expire=180 \
	  --email="client@${PKI_DOMAIN}" \
	  "client@${PKI_DOMAIN}"

.PHONY: help
help: ## ty jessfraz
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Remove build artifacts
	if [ -d $(BUILD_DIR) ]; then rm -r $(BUILD_DIR); else echo "$(BUILD_DIR) does not exist. Nothing to do."; fi
