require 'spec_helper'

describe 'rackspace_java::default recipe' do

  context 'openjdk - default' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
      end.converge('rackspace_java::default')
    end

    it 'should include the openjdk recipe by default' do
      expect(chef_run).to include_recipe('rackspace_java::openjdk')
    end
  end

  context 'oracle' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_java']['install_flavor'] = 'oracle'
      end.converge('rackspace_java::default')
    end

    it 'should include the oracle recipe' do
      expect(chef_run).to include_recipe('rackspace_java::oracle')
    end
  end

  context 'oracle_i586' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_java']['install_flavor'] = 'oracle_i586'
      end.converge('rackspace_java::default')
    end

    it 'should include the oracle_i586 recipe' do
      expect(chef_run).to include_recipe('rackspace_java::oracle_i586')
    end
  end

  context 'oracle_rpm' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_java']['install_flavor'] = 'oracle_rpm'
      end.converge('rackspace_java::default')
    end

    it 'should include the oracle_i586 recipe' do
      expect(chef_run).to include_recipe('rackspace_java::oracle_rpm')
    end
  end

end
