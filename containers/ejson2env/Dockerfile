FROM golang:1.12-alpine AS builder
WORKDIR /go/src/github.com/Shopify
RUN apk add --no-cache git \
 && git clone https://github.com/Shopify/ejson2env.git \
 && go install -v github.com/Shopify/ejson2env/cmd/ejson2env

FROM scratch
USER 65534:65534
COPY --from=builder /go/bin/ejson2env /
WORKDIR /tmp
ENTRYPOINT ["/ejson2env"]
