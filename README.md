# Overview

Docker Compose for Scroll rollup

Meant to be used with [central-proxy-docker](https://github.com/CryptoManufaktur-io/central-proxy-docker) for traefik
and Prometheus remote write; use `:ext-network.yml` in `COMPOSE_FILE` inside `.env` in that case.

If you want the l2geth RPC ports exposed locally, use `scroll-shared.yml` in `COMPOSE_FILE` inside `.env`.

The `./scrolld` script can be used as a quick-start:

`./scrolld install` brings in docker-ce, if you don't have Docker installed already.

`cp default.env .env`

`nano .env` and adjust variables as needed, particularly `L1_RPC`

`./scrolld up`

To update the software, run `./scrolld update` and then `./scrolld up`

This is Scroll Docker v1.0.0
