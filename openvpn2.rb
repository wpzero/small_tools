#!/usr/bin/ruby

require 'pty'
require 'expect'

config_file = "Piwang.ovpn"

class OpenVpn
  def initialize(config_file, sudo_password, workspace)
    @config_file = config_file
    @sudo_password = sudo_password
    @workspace = workspace
  end

  def run
    prepare_workspace
    PTY.spawn("echo #{@sudo_password} | sudo -S openvpn --config #{@config_file}") do |r, w, pid|
      r.expect(/Enter\s*Private\s*Key\s*Password:/, 100) do |result|
        w.write("c7ZQ4Z2GG1zw\n")
        write_pid(pid.to_s)
      end
    end
  end

  def prepare_workspace
    Dir.chdir @workspace
  end

  def write_pid(pid)
    file = File.open("#{@workspace}/mssqlvpn.pid", "w")
    file.write(pid)
    file.close
  end

end

OpenVpn.new(config_file, "1", "/usr/local/etc/openvpn").run
