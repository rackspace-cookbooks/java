require 'spec_helper'

describe 'rackspace_java::oracle_i586' do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new
    runner.converge('rackspace_java::oracle_i586')
  end

  it 'should include the set_java_home recipe' do
    expect(chef_run).to include_recipe('rackspace_java::set_java_home')
  end

  it 'should configure a java_ark[jdk] resource' do
    pending 'Testing LWRP use is not required at this time, this is tested post-converge.'
  end
end
