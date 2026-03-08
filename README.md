docker compose config
=====================

Review docker-compose.yml, especially bind-mounted volumes.
Your system may be different (ex. you dont use vim).

Create .env file
================

```console
echo "UID $(id -u)" > .env
echo "GID $(id -g)" >> .env
echo "USR=$(whoami)" >> .env
echo "HOSTNAME=$(hostname)" >> .env
```

Create AnycubicSlicerNext config directory on host
==================================================

This directory is bind-mounted to container

```console
mkdir -p ~/.config/AnycubicSlicerNext/
```

Downloading AnycubicSlicerNext deb package from Anycuibic cloud
===============================================================

```console

REPO_URL=https://cdn-universe-slicer.anycubic.com/prod
wget ${REPO_URL}/dists/noble/main/binary-amd64/Packages
PACKAGE_PATH=`cat Packages |grep '^Filename: ' |sed 's/^Filename: //g'`
echo ${REPO_URL}/${PACKAGE_PATH}
wget ${REPO_URL}/${PACKAGE_PATH}
```

***WARNING***
Edit Dockerfile and replace ***.deb*** package version with one you have downloaded.


Build image and start container
===============================

```console
docker compose up --build --detach anycubic
```

Attach to running container
===========================

```console
docker exec -it anycubic  /bin/bash
```
