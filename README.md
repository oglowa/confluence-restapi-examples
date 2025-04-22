[<img src="https://www.arvato-systems.de/resource/crblob/192802/c1761df5c2dd23860dde84dcc0a7189f/arvato-logo-svg-data.svg" alt="Logo" title="Arvato Systems GmbH" width="250px"/>](https://www.arvato-systems.de/resource/crblob/192802/c1761df5c2dd23860dde84dcc0a7189f/arvato-logo-svg-data.svg "Arvato Systems GmbH")

# Confluence REST API Examples

![Latest Version](https://img.shields.io/badge/release-latest-blue?logo=bitbucket&style=plastic&longCache=true "Latest Version") ![Software License](https://img.shields.io/badge/license-by_Arvato_Systems_GmbH-brightgreen.svg?longCache=true&style=plastic "Software License")

(c) 2024 Oliver Glowa (glo03) / Arvato Systems GmbH

# Description

Containing examples for the [Confluence REST API](https://developer.atlassian.com/server/confluence/confluence-rest-api-examples/) using shell scripts.

# Requirements

- Linux / Unix Shell
  or
- Windows Shell
- Cygwin + Curl
    - Intune-Client or
    - https://curl.se/windows/

# How to use it

1. Copy the file `common/my.cfg.tpl` to `~/.restapi`
2. Rename the file to `~/.restapi/my.cfg`
3. Edit the file `~/.restapi/my.cfg`
    - Set the variables
        - `CONF_BASE_URL_*` = URLs of your Confluence instance
        - `CONF_PAT_*` = Personal access tokens for authentication to your Confluence instance

# Notice

__Examples are working with privat access token (PAT) only!__

