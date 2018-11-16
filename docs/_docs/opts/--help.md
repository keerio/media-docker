---
title: --help
permalink: /docs/opts/--help/
---

The `--help` option shows the usage message for media-docker.

{% assign option = site.data.cli_opts | where:"long-name","--help" %}
{% for opt in option %}
```bash
{{ opt.output }}
```
{% endfor %}
