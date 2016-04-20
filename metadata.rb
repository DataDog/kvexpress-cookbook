# Encoding: utf-8
name 'kvexpress'
maintainer 'DatadogHQ Inc.'
maintainer_email 'darron@froese.org'
license 'Apache 2.0'
description 'Installs/Configures kvexpress'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.2'
recipe 'kvexpress::default', 'Installs/configures kvexpress'

depends 'apt'
