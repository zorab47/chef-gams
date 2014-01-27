# GAMS Cookbook

Installs [GAMS][] from a provided GAMS installer URL.

## Requirements

- Chef 10
- Ubuntu
- Ruby >= 1.9

## Attributes

- `node["gams"]["version"]`       - Version to install (e.g. "24.2.1").
- `node["gams"]["installer_url"]` - Installer URL see [GAMS downloads][].
  (e.g. "http://gamsfiles.gams.com.s3.amazonaws.com/distributions/24.2.1/linux/linux_x64_64_sfx.exe")
- `node["gams"]["license"]`       - A **required** GAMS license to provision
   a fully functional GAMS.
- `node["gams"]["install_path"]`  - Installation path. Default: `/opt/gams`.
- `node["gams"]["symlink"]`       - Global system symlink, if desired. Default:
  `/usr/local/bin/gams`.

## Usage

Include the recipe in the node or role to install GAMS.

[GAMS]: http://gams.com
[GAMS downloads]: http://gams.com/download
