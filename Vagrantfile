# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
VAGRANT_MIN_VERSION = ">= 1.5.0"
VAGRANT_MAX_VERSION = "< 1.6.0"

# Requirements
require 'yaml'
require 'json'

# Settings
file = File.expand_path('settings.yaml', File.dirname(__FILE__))

if File.exists?(file)
	settings = YAML.load_file(file)
else
	abort('No settings.yaml file found.')
end

# Vagrant version
Vagrant.require_version VAGRANT_MIN_VERSION, VAGRANT_MAX_VERSION

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Base
	if !settings['guest']['box'].nil?
		config.vm.box = settings['guest']['box']['box_name']
		config.vm.box_url = settings['guest']['box']['box_url']
		if !settings['guest']['box']['check_sum'].nil? and !settings['guest']['box']['check_sum_type'].nil?
			config.vm.box_download_checksum = settings['guest']['box']['check_sum']
			config.vm.box_download_checksum_type = settings['guest']['box']['check_sum_type']
		end
	else
		abort('No box settings have been specified.')
	end

	# General
	config.vm.hostname = settings['guest']['hostname']

	# Network
	if !settings['guest']['network']['private_network'].nil?
		# Private Network
		config.vm.network :private_network, ip: settings['guest']['network']['private_network']
	else
		# Public Network
		config.vm.network :public_network
	end

	# Ports
	if !settings['guest']['network']['forwarded_ports'].nil?
		settings['guest']['network']['forwarded_ports'].each do |host_port, guest_port|
			config.vm.network :forwarded_port, guest: guest_port, host: host_port
		end
	end

  	# Virtualbox Specific Customizations
	config.vm.provider :virtualbox do |virtualbox|
		virtualbox.gui = false
		virtualbox.name = settings['guest']['name']
		virtualbox.customize ['modifyvm', :id, '--acpi', 'on']

		# CPUs
		if !settings['guest']['cpus'].nil?
			virtualbox.customize ['modifyvm', :id, '--cpus', settings['guest']['cpus']]
			if settings['guest']['cpus'].to_i > 1
				virtualbox.customize ['modifyvm', :id, '--ioapic', 'on']
			end
		end

		# CPU Excution Cap
		if !settings['guest']['cpu_execution_cap'].nil?
			virtualbox.customize ['modifyvm', :id, '--cpuexecutioncap', settings['guest']['cpu_execution_cap']]
		end

		# Memory
		if !settings['guest']['memory'].nil?
			virtualbox.customize ["modifyvm", :id, "--memory", settings['guest']['memory']]
		end

		# ACPI
		if !settings['guest']['acpi'].nil?
			virtualbox.customize ['modifyvm', :id, '--acpi', settings['guest']['acpi'] == 'on' ? 'on' : 'off']
		end

		# PAE
		if !settings['guest']['pae'].nil?
			virtualbox.customize ['modifyvm', :id, '--pae', settings['guest']['pae'] == 'on' ? 'on' : 'off']
		end

		# HW Acceleration
		if !settings['guest']['acceleration'].nil?
			# Extensions
			if !settings['guest']['acceleration']['extensions'].nil?
				virtualbox.customize ['modifyvm', :id, '--hwvirtex', settings['guest']['acceleration']['extensions'] == 'on' ? 'on' : 'off']
			end

			# Nested Paging
			if !settings['guest']['acceleration']['nestedpaging'].nil?
				virtualbox.customize ['modifyvm', :id, '--nestedpaging', settings['guest']['acceleration']['nestedpaging'] == 'on' ? 'on' : 'off']
			end
		end

		if !settings['guest']['natdns'].nil?
			if !settings['guest']['natdns']['hostresolver'].nil?
				virtualbox.customize ['modifyvm', :id, '--natdnshostresolver1', settings['guest']['natdns']['hostresolver'] == 'on' ? 'on' : 'off' ]
			end

			if !settings['guest']['natdns']['proxy'].nil?
				virtualbox.customize ['modifyvm', :id, '--natdnsproxy1', settings['guest']['natdns']['proxy'] == 'on' ? 'on' : 'off' ]
			end
		end
	end

	config.vm.provision :shell, :path => '.chef/initialization.sh'

	VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes','vagrant.json').read)

	config.vm.provision :chef_solo do |chef|
		chef.cookbooks_path = ['./cookbooks/', './site-cookbooks/']
   	chef.roles_path = './roles/'
   	chef.data_bags_path = './data_bags/'
		chef.provisioning_path = "/tmp/vagrant-chef"
		chef.run_list = VAGRANT_JSON.delete('run_list')
		chef.json = VAGRANT_JSON
	end
end
