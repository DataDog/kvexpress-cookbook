kvexpress Cookbook
=============
Installs `kvexpress` and provides and LWRP to use it from within Chef.

Requirements
------------
Consul.

kvexpress

Attributes
----------
`default['kvexpress']['version']`

Usage
-----
Use `kvexpress::default` to install the binary.

Use the LWRP to get configuration from Consul during a Chef run.

License and Authors
-------------------
Authors:

Darron Froese
