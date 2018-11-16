# Contributing to media-docker

## Issues

Always feel free to open enhancement requests, request new applications, or open issues.

## Contributing

 1. **Fork** the project on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the latest from "upstream" before making a pull request!

## Contribution Requirements

When opening a pull request, you should ensure that all changes made conform to the following standards where applicable:

- Shell scripts:
    1. Only use `Bash` for executable scripts.
    2. Executable scripts should have `.sh` as their file extension.
    3. Start all scripts with:
        ```bash
        #!/bin/env bash
        set -euo pipefail
        ```
    5. Use our logging functions as applicable: <info/success/err>
    6. Indent with two spaces.
    7. No lines longer than 80 characters.
    8. All shell scripts conform to standard Bashate and ShellCheck rules.
        - This can be check by executing the tests `v_bashate` and `v_shellcheck`
- Applications:
    1. Each supported application consists of a directory containing at least four files. All four files must exist to allow the application to function and for the pull request to be accepted.
        1. \$APP.yaml
            - Contains core configuration.
        2. \$APP-port.yaml
            - Contains the port mappings used by the application.
        3. \$APP-port.yaml
            - Contains the labels used by Traefik for this application.
        4. \$APP-\$ARCH.yaml
            - Contains the image for the noted processor architecture for the application.
    2. The ports mapped for the application must not collide with any other pre-existing application. This can be confirmed by executing the `t_ports` test. 