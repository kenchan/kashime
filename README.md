# Kashime

Kashime is OpenStack Network Managment tool - Alternatives `neutron`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kashime', github: 'kenchan/kashime'
```

And then execute:

    $ bundle

## Usage

You need to put fog configuration to home directory.

```
% cat ~/.fog
default:
  openstack_auth_url: "http://your-openstack-endpoint/v2.0/tokens"
  openstack_username: "admin"
  openstack_tenant: "admin"
  openstack_api_key: "admin-no-password"
```

### Ports

```
kashime ports
kashime ports -o (only available ports)
kashime create_port your-network-name
kashime cleanup_ports
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/kenchan/kashime/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
