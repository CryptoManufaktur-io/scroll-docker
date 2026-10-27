# Overview

Docker Compose for Scroll rollup

Meant to be used with [central-proxy-docker](https://github.com/CryptoManufaktur-io/central-proxy-docker) for traefik
and Prometheus remote write; use `:ext-network.yml` in `COMPOSE_FILE` inside `.env` in that case.

If you want the l2geth RPC ports exposed locally, use `scroll-shared.yml` in `COMPOSE_FILE` inside `.env`.

The l2geth P2P port (`P2P_PORT`, default 30303, tcp and udp) is published on the host so that peers can connect to the node;
without inbound peers the node depends on the few peers it manages to dial out to.

The `./scrolld` script can be used as a quick-start:

`./scrolld install` brings in docker-ce, if you don't have Docker installed already.

`cp default.env .env`

`nano .env` and adjust variables as needed, particularly `L1_RPC`

`./scrolld up`

The public HTTP API does not expose the `debug` namespace, since it allows rewinding the chain head and profiling. To re-enable it, set `EXTRAS=--http.api eth,net,web3,scroll,debug` in your untracked `.env` and re-create the container with `./scrolld up`; `EXTRAS` is appended after the built-in flags and the last `--http.api` wins, so no tracked file needs editing.

To update the software, run `./scrolld update` and then `./scrolld up`

This is Scroll Docker v3.0.0
