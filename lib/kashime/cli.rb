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
      headers = %i(id tenant primary_ip device_id)

      ports = Yao::Port.list

      tsv = CSV.generate(headers: headers, write_headers: options['with-header'], col_sep: "\t") do |csv|
        ports.each do |port|
          next if options['only-availables'] && port.device_id.present?

          csv << CSV::Row.new(
            headers,
            [
              port.id,
              tenant_name(port.tenant_id),
              port.primary_ip,
              port.device_id
            ]
          )
        end
      end

      puts tsv
    end

    desc 'create_port', 'create new port'
    def create_port(network_name)
      network = Yao::Network.list.find {|n| n.name == network_name }

      puts Yao::Port.create(network_id: network.id).inspect
    end

    desc 'cleanup_ports', 'delete all unattached ports'
    option 'tenant', type: :string, aliases: :t, default: nil, desc: 'tenant name'
    option 'dry-run', type: :boolean, aliases: :d, default: false
    def cleanup_ports
      Yao::Port.list(tenant_id: tenant_id(options[:tenant])).each do |port|
        if port.device_id.empty?
          puts "Deleting port: #{tenant_name(port.tenant_id)} #{port.primary_ip} #{port.id}"
          Yao::Port.destroy(port.id) unless options['dry-run']
        end
      end
    end

    private

    def tenant_id(name)
      tenants.find {|t| t.name == name}.try(:id)
    end

    def tenant_name(tenant_id)
      tenants.find {|t| t.id == tenant_id}.try(:name)
    end

    def tenants
      @_tenants ||= Yao::Project.list
    end
  end
end
