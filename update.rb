#!/usr/bin/env ruby

require "erb"
require "ostruct"
require "yaml"

# run external command and test success
def run(cmd)
  puts "#{cmd}"
  success = system(cmd)
  exit $?.exitstatus unless success
end

def status(msg)
  puts "\n==> #{msg}"
end

# update docker files for version
def update_version(branch, version, opts={})
  dir = File.join(branch, version)
  status "Update version #{dir}"

  # initialize directory
  run "rm -rf #{dir}"
  run "mkdir -p #{dir}"
  run "cp docker-entrypoint.sh #{dir}"

  if branch == "ensocoin"
    run "sed -i 's/printtoconsole=1/addnode=178.88.115.118\\\n    addnode=194.87.146.58\\\n    printtoconsole=1/' #{dir}/docker-entrypoint.sh"

    run "sed -i 's/bitcoin.conf/ensocoin.conf/' #{dir}/docker-entrypoint.sh"
    run "sed -i 's/bitcoin-cli/ensocoin-cli/' #{dir}/docker-entrypoint.sh"
    run "sed -i 's/bitcoin-tx/ensocoin-tx/' #{dir}/docker-entrypoint.sh"
    run "sed -i 's/test_bitcoin/test_ensocoin/' #{dir}/docker-entrypoint.sh"
    run "sed -i 's/bitcoind/ensocoind/' #{dir}/docker-entrypoint.sh"
    run "sed -i 's/\\\.bitcoin/.ensocoin/' #{dir}/docker-entrypoint.sh"
  end

  # render Dockerfile
  opts[:version] = version
  opts[:home] = '.bitcoin'
  opts[:ports] = '8332 8333 18332 18333'

  if branch == "ensocoin"
    opts[:home] = '.ensocoin'
    opts[:ports] = '7992 7993 17992 17993'
  end

  dockerfile = ERB.new(File.read("Dockerfile.erb"), nil, "-")
  result = dockerfile.result(OpenStruct.new(opts).instance_eval { binding })
  File.write(File.join(dir, "Dockerfile"), result)
end

def load_versions
  versions = YAML.load_file('versions.yml')
  versions.select! { |k, v| k === ENV['BRANCH'] } if ENV['BRANCH']
  versions
end

if __FILE__ == $0
  load_versions.each do |branch, versions|
    versions.each do |version, opts|
      update_version(branch, version, opts)
    end
  end
end
