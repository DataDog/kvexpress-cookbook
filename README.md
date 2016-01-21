kvexpress Cookbook
=============
Installs [kvexpress](https://github.com/DataDog/kvexpress) and provides an LWRP to use it from within Chef.

Requirements
------------
* Consul
* Ubuntu

If you're not using Ubuntu - you can download [binary releases from Github](https://github.com/DataDog/kvexpress/releases).

Attributes
----------
```ruby
default['kvexpress']['version'] = '1.9-1'
default['datadog']['url'] = 'https://app.datadoghq.com'

# Where to place the JSON watches.
default['consul']['config_dir'] = '/etc/consul.d'

# If you're using Consul ACLs to protect the 'kvexpress/' KV space and kvexpress::server_config:
# default['consul']['acl']['kvexpress'] = 'acl-goes-here'

# If you're using the Datadog API to send events and kvexpress::server_config:
# default['datadog']['api_key'] = 'api_key_goes_here'
# default['datadog']['application_key'] = 'app_key_goes_here'

# If you're using the Datadog agent:
default['kvexpress']['dogstatsd'] = false
```

Default Usage with a Consul watch
-----
Use `kvexpress::default` to install the binary.

Use the LWRP to get configuration from Consul during a Chef run - here's an example kvexpress resource:

```ruby
kvexpress 'consul_dns_hosts' do
  location '/etc/hosts.consul'
  key 'hosts'
  mode '00644'
  command 'sudo pkill -HUP dnsmasq'
  notifies :reload, 'service[consul]', :delayed
end
```

During the Chef run, that resource will do the following:

1. If there's no file at `/etc/hosts.consul`, it will try to download the key `kvexpress/hosts/data` and save it. It will fail silently if there's no key there - that's by design.
2. It will create a Consul watch inside of `/etc/consul.d` and reload Consul so any updates are automatically replicated.
3. If it saves a new file, it will send a SIGHUP to dnsmasq to reload it.

The Consul watch will look something like this:

```json
{
  "watches": [
    {
      "type": "key",
      "key": "/kvexpress/hosts/checksum",
      "handler": "kvexpress out -k hosts -f /etc/hosts.consul -l 10 -c 00644 -e 'sudo pkill -HUP dnsmasq'"
    }
  ]
}
```

If you don't use Chef - you can manually create the JSON needed for the Consul watch - use the above as a template.

Ad-Hoc Usage with Consul exec
-----

Detailed [here](https://github.com/DataDog/kvexpress#ad-hoc-usage-with-consul-exec).

## Contributing

We love pull requests from anyone. [Details are available here](https://github.com/DataDog/kvexpress-cookbook/blob/master/CONTRIBUTING.md).

## Code of Conduct

This project adheres to the [Open Code of Conduct][code-of-conduct]. By participating, you are expected to honor this code.
[code-of-conduct]: http://todogroup.org/opencodeofconduct/#kvexpress/darron@froese.org
