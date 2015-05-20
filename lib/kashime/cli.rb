require 'active_support'
require 'active_support/core_ext'
require 'csv'
require 'fog'
require 'thor'

module Kashime
  class CLI < Thor

    desc 'ports', 'show all port list'
    option :only_availables, type: :boolean, aliases: :o, default: false
    def ports
      headers = %i(id mac_address fixed_ips device_id)

      ports = Fog::Network[:openstack].ports

      ports = ports.select {|port| port.device_id.empty? } if options['only_availables']

      ports = ports.map {|port| port.attributes.slice(*headers) }

      tsv = CSV.generate(headers: headers, write_headers: true, col_sep: "\t") do |csv|
        ports.each do |port|
          csv << CSV::Row.new(headers, port.values)
        end
      end

      puts tsv
    end

    desc 'create_port', 'create new port'
    def create_port(network_name)
      network = Fog::Network[:openstack].networks.find {|n| n.name == network_name }

      puts Fog::Network[:openstack].ports.create(network_id: network.id).inspect
    end
  end
end
