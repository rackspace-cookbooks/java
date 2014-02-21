require 'spec_helper'

describe 'rackspace_java::set_java_home' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.node.set['rackspace_java']['java_home'] = '/opt/java'
    runner.converge('rackspace_java::set_java_home')
  end
  it 'it should set the java home environment variable' do
    expect(chef_run).to execute_ruby_block('set-env-java-home')
  end

  it 'should create the profile.d directory' do
    expect(chef_run).to create_directory('/etc/profile.d')
  end

  it 'should create jdk.sh with the java home environment variable' do
    expect(chef_run).to render_file('/etc/profile.d/jdk.sh').with_content(
      'export JAVA_HOME=/opt/java'
    )
  end

end
