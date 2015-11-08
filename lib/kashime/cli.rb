require 'active_support'
require 'active_support/core_ext'
require 'csv'
require 'yao'
require 'thor'

module Kashime
  class CLI < Thor

    desc 'ports', 'show all port list'
    option 'only-availables', type: :boolean, aliases: :o, default: false
    option 'with-header', type: :boolean, default: false
    def ports
      headers = %i(id mac_address primary_ip device_id)

      ports = Yao::Port.list

      ports = ports.select {|port| port.device_id.empty? } if options['only-availables']

      attrs = ports.map {|port|
        headers.map {|h|
          port.__send__ h
        }
      }

      tsv = CSV.generate(headers: headers, write_headers: options['with-header'], col_sep: "\t") do |csv|
        attrs.each do |port|
          csv << CSV::Row.new(headers, port)
        end
      end

      puts tsv
    end

    desc 'create_port', 'create new port'
    def create_port(network_name)
      network = Fog::Network[:openstack].networks.find {|n| n.name == network_name }

      puts Fog::Network[:openstack].ports.create(network_id: network.id).inspect
    end

    desc 'cleanup_ports', 'delete all unattached ports'
    option 'dry-run', type: :boolean, aliases: :d, default: false
    def cleanup_ports
      Fog::Network[:openstack].ports.each do |port|
        if port.device_id.empty?
          puts "Deleting port id: #{port.id}"
          port.destroy unless options['dry-run']
        end
      end
    end
  end
end
