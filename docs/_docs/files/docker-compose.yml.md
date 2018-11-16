---
title: docker-compose.yml
permalink: /docs/files/docker-compose.yml/
---

This file is built by the media-docker process according to your selections through the installation. The source files from which it is built can be located in the `./.containers/` directory. Each service container has three files: the base container configuration, the ports used for direct host port mapping, and the labels required by traefik for reverse proxying. The selected options through the install process determine which files are used.

After completion of the media-docker configuration process, this file will contain all of the instructions Docker Compose needs to pull, build, and configure the entire media environment. All user-configurable items are requested by the install process and are also exposed for later configuration changes through the dotenv file.
