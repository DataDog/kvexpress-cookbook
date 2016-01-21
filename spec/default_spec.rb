# Encoding: utf-8

describe 'kvexpress::default' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  it 'install kvexpress' do
    expect(chef_run).to install_package('kvexpress')
  end
end
