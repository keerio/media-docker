---
title: Quick Start
permalink: /docs/
redirect_from:
  - /docs/home/
---

media-docker is your all-in-one deployment and configuration tool for an all-in-one media server, running on docker. You run the tool, it'll ask you some questions, and it sets everything up for you. Through the process, you'll decide where things are stored, what apps you want to run, and you may need to set some specific values depending on the apps you enable.

# Instructions

1. Be a sudo-er and have `git` installed on your machine.
2. Download media-docker:
    ```bash
    git clone {{ site.repository }} ./media-docker
    ```
3. Make sure that the tool is executable: 
    ```bash
    cd ./media-docker
    chmod +x ./media-docker.sh
    ```
4. Run the tool*:
    ```bash
    sudo ./media-docker.sh
    ```

    *After your first run, you can run media-docker by its name from anywhere:

    ```bash
    sudo media-docker
    ```

If you encounter any unexpected errors during the above, please refer to the troubleshooting and requirements pages, or open an issue on GitHub.
