require 'spec_helper'

describe 'rackspace_java::oracle_rpm' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rackspace_java']['install_flavor'] = 'oracle_rpm'
    end.converge('rackspace_java::oracle_rpm')
  end

  it 'should install the necessary files for jdk' do
    expect(chef_run).to upgrade_package('jdk')
  end
end
