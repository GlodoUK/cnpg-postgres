# PostgreSQL / CNPG Container Images

These images are built on top of the [CNPG postgres-containers](https://github.com/cloudnative-pg/postgres-containers)
and adds the following software:

- pg_repack (distributed under the BSD 3-Clause License)

## Thanks

With thanks to:

- [tensorchord/cloudnative-pgvecto.rs](https://github.com/tensorchord/cloudnative-pgvecto.rs)
  for the inspiration for using renovate and the basics of the github workflow found in
  this repository.
- [CNPG](https://github.com/cloudnative-pg) for being awesome.

## Building

To build the Dockerfile locally, you need to pass the CNPG_TAG, DISTRO and PG_REPACK_TAG args. 

For example:
`docker build . --build-arg="CNPG_TAG=16.3" --build-arg="PG_REPACK_TAG=1.5.1" --build-arg="DISTRO=bullseye"`
